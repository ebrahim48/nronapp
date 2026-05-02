import 'package:intl/intl.dart';

enum SaleType { sold, consigned }

enum SaleStatus { approved, pending, rejected }

enum ImplantAvailability { available, inStock, backordered }

enum AuditType { success, info, warning }

// ── helpers ──────────────────────────────────────────────────────────────────

SaleStatus _statusFromApi(String s) {
  switch (s.toLowerCase()) {
    case 'approved':
      return SaleStatus.approved;
    case 'rejected':
      return SaleStatus.rejected;
    default:
      return SaleStatus.pending;
  }
}

String _fmt(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw).toLocal());
  } catch (_) {
    return raw;
  }
}

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

double _toDouble(dynamic v) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0;
  return 0;
}

// ── dropdown models ───────────────────────────────────────────────────────────

class VendorModel {
  final String id;
  final String name;

  const VendorModel({this.id = '', this.name = ''});

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? json['fullName']?.toString() ?? '',
      );
}

class FacilityDropdownModel {
  final String id;
  final String name;

  const FacilityDropdownModel({this.id = '', this.name = ''});

  factory FacilityDropdownModel.fromJson(Map<String, dynamic> json) =>
      FacilityDropdownModel(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ??
            json['facilityName']?.toString() ??
            json['title']?.toString() ??
            '',
      );
}

// ── list card model ───────────────────────────────────────────────────────────

class SaleModel {
  final String id;
  final String saleNumber;
  final String facility;
  final String saleTypeLabel;
  final String surgeon;
  final double totalBill;
  final SaleStatus status;

  const SaleModel({
    this.id = '',
    required this.saleNumber,
    required this.facility,
    required this.saleTypeLabel,
    required this.surgeon,
    required this.totalBill,
    required this.status,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final billingRaw = json['billing'];
    final physRaw = json['physician'];
    final facRaw = json['facility'];
    return SaleModel(
      id: json['_id']?.toString() ?? '',
      saleNumber: json['saleId']?.toString() ?? json['_id']?.toString() ?? '',
      facility: facRaw is Map
          ? (facRaw['name']?.toString() ??
              facRaw['facilityName']?.toString() ??
              '')
          : '',
      saleTypeLabel: _capitalize(json['salesType']?.toString() ?? ''),
      surgeon: physRaw is Map ? physRaw['fullName']?.toString() ?? '' : '',
      totalBill: billingRaw is Map ? _toDouble(billingRaw['totalAmount']) : 0,
      status: _statusFromApi(json['status']?.toString() ?? ''),
    );
  }
}

// ── detail models ─────────────────────────────────────────────────────────────

class InventoryItemModel {
  final String name;
  final String serial;
  final String tag;
  final int qty;
  final double price;

  const InventoryItemModel({
    required this.name,
    required this.serial,
    required this.tag,
    this.qty = 1,
    this.price = 0,
  });
}

class RepSplitModel {
  final String id;
  final String name;
  final String role;
  final int splitPercent;

  const RepSplitModel({
    this.id = '',
    required this.name,
    this.role = '',
    required this.splitPercent,
  });
}

class AttachmentFileModel {
  final String fileName;
  final String size;
  final String date;
  final bool isPdf;
  final String? url;

  const AttachmentFileModel({
    required this.fileName,
    required this.size,
    required this.date,
    required this.isPdf,
    this.url,
  });

  factory AttachmentFileModel.fromUrl(String url) {
    final name = url.split('/').last.split('?').first;
    final isPdf = name.toLowerCase().endsWith('.pdf');
    return AttachmentFileModel(
        fileName: name, size: '', date: '', isPdf: isPdf, url: url);
  }
}

class AuditTrailModel {
  final String title;
  final String subtitle;
  final String dateTime;
  final AuditType type;

  const AuditTrailModel({
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.type,
  });
}

class SaleDetailModel {
  final String id;
  final String saleNumber;
  final String saleType;
  final String physician;
  final String physicianId;
  final String facility;
  final String facilityId;
  final String procedureDate;
  final String serialNumbers;
  final String vendor;
  final String vendorId;
  final String ppoNumber;
  final double totalAmount;
  final double vendorPayment;
  final List<InventoryItemModel> inventoryItems;
  final String classification;
  final List<RepSplitModel> repSplits;
  final double totalCommission;
  final List<AttachmentFileModel> attachments;
  final String note;
  final List<AuditTrailModel> auditTrail;
  final bool isPackingSlipGenerated;
  final String salesTypeRaw;

  const SaleDetailModel({
    this.id = '',
    required this.saleNumber,
    required this.saleType,
    required this.physician,
    this.physicianId = '',
    required this.facility,
    this.facilityId = '',
    required this.procedureDate,
    required this.serialNumbers,
    required this.vendor,
    this.vendorId = '',
    required this.ppoNumber,
    this.totalAmount = 0,
    this.vendorPayment = 0,
    required this.inventoryItems,
    required this.classification,
    required this.repSplits,
    required this.totalCommission,
    required this.attachments,
    required this.note,
    required this.auditTrail,
    this.isPackingSlipGenerated = false,
    this.salesTypeRaw = '',
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    // representatives
    final repData = json['representatives'];
    List<dynamic> repUsers = [];
    double totalCommission = 0;
    if (repData is Map) {
      repUsers = repData['users'] is List
          ? repData['users'] as List<dynamic>
          : [];
      totalCommission = _toDouble(repData['totalCommission']);
    } else if (repData is List) {
      repUsers = repData;
    }

    // physician / facility — may be populated object or bare ID string
    final physRaw = json['physician'];
    final physName =
        physRaw is Map ? physRaw['fullName']?.toString() ?? '' : '';
    final physId = physRaw is Map
        ? physRaw['_id']?.toString() ?? ''
        : physRaw?.toString() ?? '';
    final facRaw = json['facility'];
    final facName = facRaw is Map
        ? (facRaw['name']?.toString() ??
            facRaw['facilityName']?.toString() ??
            '')
        : '';
    final facId = facRaw is Map
        ? facRaw['_id']?.toString() ?? ''
        : facRaw?.toString() ?? '';

    // billing
    final billingRaw = json['billing'] is Map
        ? Map<String, dynamic>.from(json['billing'] as Map)
        : <String, dynamic>{};
    final vendorRaw = billingRaw['vendor'];
    final vendorName = vendorRaw is Map
        ? vendorRaw['name']?.toString() ?? ''
        : billingRaw['vendorName']?.toString() ?? '';
    // bare string ID when unpopulated
    final vendorId = vendorRaw is Map
        ? vendorRaw['_id']?.toString() ?? ''
        : vendorRaw?.toString() ?? '';
    final poNumber =
        billingRaw['purchaseOrderNumber']?.toString() ?? '';
    final totalAmount = _toDouble(billingRaw['totalAmount']);
    final vendorPayment = _toDouble(billingRaw['vendorPayment']);

    // inventory products
    final inventoryRaw = json['inventoryProducts'] is List
        ? json['inventoryProducts'] as List<dynamic>
        : <dynamic>[];
    final inventoryItems = inventoryRaw.map((e) {
      final prod = e['product'];
      final productType = e['productType']?.toString() ?? '';
      String itemName = '';
      String itemSerial = '';
      if (prod is Map) {
        itemName = prod['itemName']?.toString() ??
            prod['title']?.toString() ??
            prod['name']?.toString() ??
            productType;
        itemSerial = prod['serialNumber']?.toString() ??
            prod['lotNumber']?.toString() ??
            '';
      } else {
        itemName = productType;
        itemSerial = e['serialNumber']?.toString() ??
            e['lotNumber']?.toString() ??
            '';
      }
      return InventoryItemModel(
        name: itemName.isEmpty ? productType : itemName,
        serial: itemSerial,
        tag: productType,
        qty: _toInt(e['quantity'] ?? e['qty'] ?? 1),
        price: _toDouble(e['price'] ?? e['unitPrice'] ?? e['amount']),
      );
    }).toList();

    // rep splits
    final repSplits = repUsers.map((e) {
      final rep = e['representative'];
      final repId =
          rep is Map ? rep['_id']?.toString() ?? '' : '';
      final repName = rep is Map
          ? rep['fullName']?.toString() ?? ''
          : e['representativeName']?.toString() ?? '';
      return RepSplitModel(
        id: repId,
        name: repName,
        role: e['assignRole']?.toString() ?? '',
        splitPercent: _toInt(e['commissionRate']),
      );
    }).toList();

    // attachments — API may return them as 'attachments' or 'files'
    final attachmentsRaw = json['attachments'] is List
        ? json['attachments'] as List<dynamic>
        : json['files'] is List
            ? json['files'] as List<dynamic>
            : <dynamic>[];
    final attachments = attachmentsRaw
        .map((u) => AttachmentFileModel.fromUrl(u.toString()))
        .toList();

    // audit trail from available data
    final auditTrail = <AuditTrailModel>[];
    final createdAt = json['createdAt']?.toString() ?? '';
    final updatedAt = json['updatedAt']?.toString() ?? '';
    if (createdAt.isNotEmpty) {
      auditTrail.add(AuditTrailModel(
        title: 'Sale Record Created',
        subtitle: 'Auto-generated',
        dateTime: _fmt(createdAt),
        type: AuditType.info,
      ));
    }
    final status = json['status']?.toString() ?? '';
    if (status == 'approved') {
      auditTrail.add(AuditTrailModel(
        title: 'Sale Approved',
        subtitle: 'Status updated',
        dateTime: _fmt(updatedAt),
        type: AuditType.success,
      ));
    } else if (status == 'rejected') {
      auditTrail.add(AuditTrailModel(
        title: 'Sale Rejected',
        subtitle: 'Status updated',
        dateTime: _fmt(updatedAt),
        type: AuditType.warning,
      ));
    }
    final invoiceRaw = json['invoice'] is Map
        ? Map<String, dynamic>.from(json['invoice'] as Map)
        : null;
    if (invoiceRaw != null) {
      auditTrail.add(AuditTrailModel(
        title: 'Invoice Generated',
        subtitle: invoiceRaw['invoiceNumber']?.toString() ?? '',
        dateTime: _fmt(invoiceRaw['invoiceDate']?.toString()),
        type: AuditType.info,
      ));
    }

    final salesTypeRaw = json['salesType']?.toString() ?? '';

    return SaleDetailModel(
      id: json['_id']?.toString() ?? '',
      saleNumber:
          'Sale #${json['saleId']?.toString() ?? json['_id']?.toString() ?? ''}',
      saleType: _capitalize(salesTypeRaw),
      physician: physName,
      physicianId: physId,
      facility: facName,
      facilityId: facId,
      procedureDate: _fmt(json['procedureDate']?.toString()),
      serialNumbers: inventoryItems.map((i) => i.serial).join('\n'),
      vendor: vendorName,
      vendorId: vendorId,
      ppoNumber: poNumber,
      totalAmount: totalAmount,
      vendorPayment: vendorPayment,
      inventoryItems: inventoryItems,
      classification: _capitalize(salesTypeRaw),
      repSplits: repSplits,
      totalCommission: totalCommission,
      attachments: attachments,
      note: json['description']?.toString() ?? '',
      auditTrail: auditTrail,
      isPackingSlipGenerated:
          json['isPackingSlipGenerated'] == true,
      salesTypeRaw: salesTypeRaw,
    );
  }
}

// ── form / select-implants models ─────────────────────────────────────────────

class ImplantItem {
  final String id;
  final String name;
  final String serial;
  final String material;
  final String location;
  final ImplantAvailability availability;
  bool isSelected;

  ImplantItem({
    this.id = '',
    required this.name,
    required this.serial,
    required this.material,
    required this.location,
    required this.availability,
    this.isSelected = false,
  });

  factory ImplantItem.fromJson(Map<String, dynamic> json) {
    final statusStr =
        json['productStatus']?.toString() ?? json['status']?.toString() ?? '';
    ImplantAvailability availability;
    switch (statusStr.toLowerCase()) {
      case 'available':
        availability = ImplantAvailability.available;
        break;
      case 'in stock':
      case 'instock':
        availability = ImplantAvailability.inStock;
        break;
      default:
        availability = ImplantAvailability.inStock;
    }
    return ImplantItem(
      id: json['_id']?.toString() ?? '',
      name: json['itemName']?.toString() ??
          json['title']?.toString() ??
          json['name']?.toString() ??
          '',
      serial: json['serialNumber']?.toString() ??
          json['lotNumber']?.toString() ??
          '',
      material:
          json['systemType']?.toString() ?? json['vendor']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      availability: availability,
    );
  }
}

class RepresentativeModel {
  final String id;
  final String name;
  final String role;
  final int commissionPercent;

  const RepresentativeModel({
    this.id = '',
    required this.name,
    required this.role,
    required this.commissionPercent,
  });
}

class PackingSlipItem {
  final String product;
  final String serial;
  final int qty;
  final double price;

  const PackingSlipItem({
    required this.product,
    required this.serial,
    required this.qty,
    required this.price,
  });
}
