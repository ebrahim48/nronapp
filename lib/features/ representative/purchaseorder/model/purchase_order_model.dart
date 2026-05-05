import 'package:intl/intl.dart';

enum POStatus { all, open, lost, complete }

// ── Detail Models ─────────────────────────────────────────────────────────────

class PoProductDetail {
  final String productId;
  final String productName;
  final List<String> listOfItems;
  bool isExpanded;

  PoProductDetail({
    required this.productId,
    required this.productName,
    required this.listOfItems,
    this.isExpanded = false,
  });

  factory PoProductDetail.fromJson(Map<String, dynamic> json) =>
      PoProductDetail(
        productId: json['productId']?.toString() ?? '',
        productName: json['productName']?.toString() ?? '',
        listOfItems: (json['listOfItems'] as List<dynamic>?)
                ?.map((e) => (e as Map<String, dynamic>)['slName']?.toString() ?? '')
                .where((s) => s.isNotEmpty)
                .toList() ??
            [],
      );
}

class PurchaseOrderDetailModel {
  final String id;
  final String status;
  final String orderType;
  final String thumbnail;
  final String patientId;
  final String surgeryId;
  final String surgeonName;
  final String surgeryType;
  final String surgeryDate;
  final String facilityId;
  final String facilityName;
  final String facilityEmail;
  final String facilityAddress;
  final String facilityPhone;
  final String facilityContacts;
  final String vendorId;
  final String vendorName;
  final String vendorEmail;
  final String procedureDate;
  final String purchaseOrderNumber;
  final bool isSentToVendor;
  final double totalAmount;
  final String notes;
  final String handWritePODoc;
  final List<PoProductDetail> products;
  final List<String> documents;
  final String createdAt;

  const PurchaseOrderDetailModel({
    required this.id,
    required this.status,
    required this.orderType,
    this.thumbnail = '',
    this.patientId = '',
    this.surgeryId = '',
    this.surgeonName = '',
    this.surgeryType = '',
    this.surgeryDate = '',
    this.facilityId = '',
    this.facilityName = '',
    this.facilityEmail = '',
    this.facilityAddress = '',
    this.facilityPhone = '',
    this.facilityContacts = '',
    this.vendorId = '',
    this.vendorName = '',
    this.vendorEmail = '',
    this.procedureDate = '',
    this.purchaseOrderNumber = '',
    this.isSentToVendor = false,
    this.totalAmount = 0,
    this.notes = '',
    this.handWritePODoc = '',
    this.products = const [],
    this.documents = const [],
    this.createdAt = '',
  });

  factory PurchaseOrderDetailModel.fromJson(Map<String, dynamic> json) {
    final surgery = json['surgery'];
    final surgeryMap = surgery is Map ? surgery as Map<String, dynamic> : <String, dynamic>{};
    final surgeryInfo = surgeryMap['info'] is Map
        ? surgeryMap['info'] as Map<String, dynamic>
        : <String, dynamic>{};
    final facility = json['facility'];
    final facilityMap =
        facility is Map ? facility as Map<String, dynamic> : <String, dynamic>{};
    final vendor = json['vendor'];
    final vendorMap =
        vendor is Map ? vendor as Map<String, dynamic> : <String, dynamic>{};

    final productsList = (json['products'] as List<dynamic>?)
            ?.map((e) => PoProductDetail.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PurchaseOrderDetailModel(
      id: json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      orderType: json['orderType']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      surgeryId: surgeryMap['_id']?.toString() ?? '',
      surgeonName: surgeryInfo['fullName']?.toString() ?? '',
      surgeryType: surgeryInfo['surgeryType']?.toString() ?? '',
      surgeryDate: _fmtDate(surgeryInfo['dateOfSurgery']?.toString()),
      facilityId: facilityMap['_id']?.toString() ?? '',
      facilityName: facilityMap['facilityName']?.toString() ?? facilityMap['name']?.toString() ?? '',
      facilityEmail: facilityMap['email']?.toString() ?? '',
      facilityAddress: facilityMap['address']?.toString() ?? '',
      facilityPhone: facilityMap['phoneNumber']?.toString() ?? '',
      facilityContacts: facilityMap['contacts']?.toString() ?? '',
      vendorId: vendorMap['_id']?.toString() ?? '',
      vendorName: vendorMap['name']?.toString() ?? '',
      vendorEmail: vendorMap['email']?.toString() ?? '',
      procedureDate: _fmtDate(json['procedureDate']?.toString()),
      purchaseOrderNumber: json['purchaseOrderNumber']?.toString() ?? '',
      isSentToVendor: json['isSentToVendor'] == true,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      notes: json['notes']?.toString() ?? '',
      handWritePODoc: json['handWritePODoc']?.toString() ?? '',
      products: productsList,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: _fmtDate(json['createdAt']?.toString()),
    );
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'lost':
        return 'Lost';
      case 'complete':
        return 'Complete';
      default:
        return status;
    }
  }

  String get orderTypeLabel =>
      orderType == 'bulkBioOrder' ? 'Bulk BIO' : 'Standard PO';
}

String _fmtDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw).toLocal());
  } catch (_) {
    return raw;
  }
}

// ── List Model ────────────────────────────────────────────────────────────────

class PurchaseOrderModel {
  final String id;
  final String status;
  final String orderType;
  final String thumbnail;
  final String patientId;
  final String surgeryId;
  final String facilityId;
  final String procedureDate;
  final String purchaseOrderNumber;
  final double totalAmount;
  final String notes;
  final List<String> documents;
  final String createdAt;

  const PurchaseOrderModel({
    required this.id,
    required this.status,
    required this.orderType,
    this.thumbnail = '',
    this.patientId = '',
    this.surgeryId = '',
    this.facilityId = '',
    this.procedureDate = '',
    this.purchaseOrderNumber = '',
    this.totalAmount = 0,
    this.notes = '',
    this.documents = const [],
    this.createdAt = '',
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    final surgery = json['surgery'];
    final facility = json['facility'];

    return PurchaseOrderModel(
      id: json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      orderType: json['orderType']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      surgeryId: surgery is Map ? surgery['_id']?.toString() ?? '' : surgery?.toString() ?? '',
      facilityId: facility is Map ? facility['_id']?.toString() ?? '' : facility?.toString() ?? '',
      procedureDate: json['procedureDate']?.toString() ?? '',
      purchaseOrderNumber: json['purchaseOrderNumber']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      notes: json['notes']?.toString() ?? '',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  POStatus get poStatus {
    switch (status.toLowerCase()) {
      case 'open':
        return POStatus.open;
      case 'lost':
        return POStatus.lost;
      case 'complete':
        return POStatus.complete;
      default:
        return POStatus.open;
    }
  }

  String get formattedDate {
    if (procedureDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(procedureDate).toLocal();
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return procedureDate;
    }
  }

  String get orderTypeLabel =>
      orderType == 'bulkBioOrder' ? 'Bulk BIO' : 'Standard PO';
}

// ── Dropdown helpers (used by create/edit forms) ──────────────────────────────

class PoDropdownItem {
  final String id;
  final String name;
  const PoDropdownItem({required this.id, required this.name});
}
