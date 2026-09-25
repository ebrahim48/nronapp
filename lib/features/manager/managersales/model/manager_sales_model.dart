enum ManagerSaleStatus { allSales, pending, paid, approved, rejected }

// ── List item ─────────────────────────────────────────────────────────────────

class ManagerSaleModel {
  final String id;
  final String saleId;
  final String facility;
  final String saleTypeLabel;
  final String surgeon;
  final double totalBill;
  final ManagerSaleStatus status;
  final String salesType;
  final String procedureDate;

  const ManagerSaleModel({
    required this.id,
    required this.saleId,
    required this.facility,
    required this.saleTypeLabel,
    required this.surgeon,
    required this.totalBill,
    required this.status,
    required this.salesType,
    required this.procedureDate,
  });

  static ManagerSaleStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'approved': return ManagerSaleStatus.approved;
      case 'rejected': return ManagerSaleStatus.rejected;
      case 'paid':     return ManagerSaleStatus.paid;
      default:         return ManagerSaleStatus.pending;
    }
  }

  factory ManagerSaleModel.fromJson(Map<String, dynamic> e) {
    final facilityMap = e['facility'] is Map
        ? e['facility'] as Map<String, dynamic>
        : <String, dynamic>{};
    final physicianMap = e['physician'] is Map
        ? e['physician'] as Map<String, dynamic>
        : <String, dynamic>{};
    final billingMap = e['billing'] is Map
        ? e['billing'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ManagerSaleModel(
      id: e['_id']?.toString() ?? '',
      saleId: e['saleId']?.toString() ?? '',
      facility: facilityMap['address']?.toString() ??
          facilityMap['facilityName']?.toString() ?? '',
      saleTypeLabel: e['salesType']?.toString() ?? '',
      surgeon: physicianMap['fullName']?.toString() ?? '',
      totalBill: (billingMap['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(e['status']?.toString()),
      salesType: e['salesType']?.toString() ?? '',
      procedureDate: e['procedureDate']?.toString() ?? '',
    );
  }
}

// ── Detail model ──────────────────────────────────────────────────────────────

class ManagerSaleDetailModel {
  final String id;
  final String saleNumber;
  final String repName;
  final String repProfileUrl;
  final String transactionStatus;
  final String saleType;
  final String doctor;
  final String doctorProfileUrl;
  final String facility;
  final String procedureDate;
  final String vendor;
  final String vendorProfileUrl;
  final String poNumber;
  final double totalBill;
  final double commission;
  final double commissionPercent;
  final List<SaleInventoryItem> inventoryItems;
  final List<SaleRepSplit> repSplits;
  final double totalCommissionPool;
  final List<SaleAttachmentItem> attachments;
  final bool billVerificationStatus;
  final String note;
  final String invoiceNumber;
  final String invoiceStatus;

  const ManagerSaleDetailModel({
    required this.id,
    required this.saleNumber,
    required this.repName,
    this.repProfileUrl = '',
    required this.transactionStatus,
    required this.saleType,
    required this.doctor,
    this.doctorProfileUrl = '',
    required this.facility,
    required this.procedureDate,
    required this.vendor,
    this.vendorProfileUrl = '',
    required this.poNumber,
    required this.totalBill,
    required this.commission,
    required this.commissionPercent,
    required this.inventoryItems,
    required this.repSplits,
    required this.totalCommissionPool,
    required this.attachments,
    required this.billVerificationStatus,
    required this.note,
    this.invoiceNumber = '',
    this.invoiceStatus = '',
  });

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) { return raw; }
  }

  factory ManagerSaleDetailModel.fromJson(Map<String, dynamic> e) {
    final physicianMap = e['physician'] is Map
        ? e['physician'] as Map<String, dynamic>
        : <String, dynamic>{};
    final facilityMap = e['facility'] is Map
        ? e['facility'] as Map<String, dynamic>
        : <String, dynamic>{};
    final billingMap = e['billing'] is Map
        ? e['billing'] as Map<String, dynamic>
        : <String, dynamic>{};
    final vendorMap = billingMap['vendor'] is Map
        ? billingMap['vendor'] as Map<String, dynamic>
        : <String, dynamic>{};
    final invoiceMap = e['invoice'] is Map
        ? e['invoice'] as Map<String, dynamic>
        : <String, dynamic>{};
    final repsMap = e['representatives'] is Map
        ? e['representatives'] as Map<String, dynamic>
        : <String, dynamic>{};
    final repUsers = repsMap['users'] is List
        ? repsMap['users'] as List
        : [];

    // Rep name from first user
    String repName = '';
    String repProfileUrl = '';
    double commissionRate = 0;
    double totalCommission = (repsMap['totalCommission'] as num?)?.toDouble() ?? 0;

    if (repUsers.isNotEmpty) {
      final firstUser = repUsers.first is Map
          ? repUsers.first as Map<String, dynamic>
          : <String, dynamic>{};
      final repMap = firstUser['representative'] is Map
          ? firstUser['representative'] as Map<String, dynamic>
          : <String, dynamic>{};
      repName = repMap['fullName']?.toString() ?? '';
      repProfileUrl = repMap['profileUrl']?.toString() ?? '';
      commissionRate = (firstUser['commissionRate'] as num?)?.toDouble() ?? 0;
    }

    // Splits
    final splits = repUsers.map((u) {
      final uMap = u is Map ? u as Map<String, dynamic> : <String, dynamic>{};
      final repMap = uMap['representative'] is Map
          ? uMap['representative'] as Map<String, dynamic>
          : <String, dynamic>{};
      return SaleRepSplit(
        name: repMap['fullName']?.toString() ?? uMap['assignRole']?.toString() ?? '',
        splitPercent: (uMap['commissionRate'] as num?)?.toInt() ?? 0,
      );
    }).toList();

    // Inventory items
    final products = e['inventoryProducts'] is List
        ? e['inventoryProducts'] as List
        : [];
    final inventoryItems = products.map((p) {
      final pMap = p is Map ? p as Map<String, dynamic> : <String, dynamic>{};
      final productType = pMap['productType']?.toString() ?? '';
      final prod = pMap['product'];
      String name = productType;
      String serial = '';
      if (prod is Map) {
        name = prod['itemName']?.toString() ??
            prod['title']?.toString() ??
            prod['name']?.toString() ??
            prod['systemType']?.toString() ??
            productType;
        serial = prod['serialNumber']?.toString() ??
            prod['lotNumber']?.toString() ??
            prod['trayId']?.toString() ??
            '';
      } else {
        // product not populated — never show the raw Mongo id
        serial = pMap['serialNumber']?.toString() ??
            pMap['lotNumber']?.toString() ??
            '';
      }
      return SaleInventoryItem(
        name: name.isEmpty ? productType : name,
        serial: serial,
        tag: productType,
      );
    }).toList();

    // Attachments from files + attachments arrays
    final fileUrls = e['files'] is List
        ? (e['files'] as List).map((f) => f.toString()).toList()
        : <String>[];
    final attUrls = e['attachments'] is List
        ? (e['attachments'] as List).map((f) => f.toString()).toList()
        : <String>[];
    final allFiles = [...fileUrls, ...attUrls];
    final attachments = allFiles.map((url) {
      final isPdf = url.toLowerCase().endsWith('.pdf');
      return SaleAttachmentItem(
        fileName: url.split('/').last,
        url: url,
        size: '',
        date: '',
        isPdf: isPdf,
      );
    }).toList();

    return ManagerSaleDetailModel(
      id: e['_id']?.toString() ?? '',
      saleNumber: 'Sale #${e['saleId']?.toString() ?? ''}',
      repName: repName,
      repProfileUrl: repProfileUrl,
      transactionStatus: e['status']?.toString() ?? '',
      saleType: e['salesType']?.toString() ?? '',
      doctor: physicianMap['fullName']?.toString() ?? '',
      doctorProfileUrl: physicianMap['profileUrl']?.toString() ?? '',
      facility: facilityMap['address']?.toString() ?? '',
      procedureDate: _formatDate(e['procedureDate']?.toString()),
      vendor: vendorMap['name']?.toString() ?? vendorMap['companyName']?.toString() ?? '',
      vendorProfileUrl: vendorMap['profileUrl']?.toString() ?? '',
      poNumber: billingMap['purchaseOrderNumber']?.toString() ?? '',
      totalBill: (billingMap['totalAmount'] as num?)?.toDouble() ?? 0.0,
      commission: totalCommission,
      commissionPercent: commissionRate,
      inventoryItems: inventoryItems,
      repSplits: splits,
      totalCommissionPool: totalCommission,
      attachments: attachments,
      billVerificationStatus: false,
      note: '',
      invoiceNumber: invoiceMap['invoiceNumber']?.toString() ?? '',
      invoiceStatus: invoiceMap['status']?.toString() ?? '',
    );
  }

  static const ManagerSaleDetailModel empty = ManagerSaleDetailModel(
    id: '', saleNumber: '', repName: '', transactionStatus: '',
    saleType: '', doctor: '', facility: '', procedureDate: '',
    vendor: '', poNumber: '', totalBill: 0, commission: 0,
    commissionPercent: 0, inventoryItems: [], repSplits: [],
    totalCommissionPool: 0, attachments: [], billVerificationStatus: false, note: '',
  );
}

// ── Sub-models ────────────────────────────────────────────────────────────────

class SaleInventoryItem {
  final String name;
  final String serial;
  final String tag;

  const SaleInventoryItem({
    required this.name,
    required this.serial,
    required this.tag,
  });
}

class SaleRepSplit {
  final String name;
  final int splitPercent;

  const SaleRepSplit({
    required this.name,
    required this.splitPercent,
  });
}

class SaleAttachmentItem {
  final String fileName;
  final String url;
  final String size;
  final String date;
  final bool isPdf;

  const SaleAttachmentItem({
    required this.fileName,
    this.url = '',
    required this.size,
    required this.date,
    required this.isPdf,
  });
}
