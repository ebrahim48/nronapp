enum ManagerPOStatus { all, complete, open, lost }

// ── Helpers ───────────────────────────────────────────────────────────────────

String _poFormatDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    final dt = DateTime.parse(raw);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  } catch (_) {
    return raw;
  }
}

// ── List item ─────────────────────────────────────────────────────────────────

class ManagerPOModel {
  final String id;
  final String date;
  final String serialNumber;
  final String doctor;
  final String facility;
  final String typeLabel;
  final double commissionAmount;
  final double totalAmount;
  final ManagerPOStatus status;
  final bool isSentToVendor;
  final String thumbnailUrl;

  const ManagerPOModel({
    required this.id,
    required this.date,
    required this.serialNumber,
    required this.doctor,
    required this.facility,
    required this.typeLabel,
    required this.commissionAmount,
    required this.totalAmount,
    required this.status,
    required this.isSentToVendor,
    this.thumbnailUrl = '',
  });

  static ManagerPOStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'complete': return ManagerPOStatus.complete;
      case 'open':     return ManagerPOStatus.open;
      case 'lost':     return ManagerPOStatus.lost;
      default:         return ManagerPOStatus.open;
    }
  }

  factory ManagerPOModel.fromJson(Map<String, dynamic> e) {
    // facility may be a nested object or a plain string
    final facilityRaw = e['facility'];
    final facilityStr = facilityRaw is Map
        ? ((facilityRaw)['facilityName']?.toString() ??
            (facilityRaw)['name']?.toString() ??
            (facilityRaw)['address']?.toString() ??
            '')
        : facilityRaw?.toString() ?? '';

    // doctor/physician may be a nested object or a plain string
    final physicianRaw = e['physician'] ?? e['physicianId'];
    final doctorStr = physicianRaw is Map
        ? ((physicianRaw)['fullName']?.toString() ??
            (physicianRaw)['name']?.toString() ??
            '')
        : physicianRaw?.toString() ?? '';

    return ManagerPOModel(
      id: e['_id']?.toString() ?? '',
      date: _poFormatDate(
          e['procedureDate']?.toString() ?? e['createdAt']?.toString()),
      serialNumber: e['purchaseOrderNumber']?.toString() ?? '',
      doctor: doctorStr,
      facility: facilityStr,
      typeLabel: e['orderType']?.toString() ?? '',
      commissionAmount:
          (e['commissionAmount'] as num?)?.toDouble() ??
          (e['commission'] as num?)?.toDouble() ??
          0.0,
      totalAmount: (e['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(e['status']?.toString()),
      isSentToVendor: e['isSentToVendor'] as bool? ?? false,
      thumbnailUrl: e['thumbnail']?.toString() ?? '',
    );
  }
}

// ── Detail model ──────────────────────────────────────────────────────────────

class ManagerPODetailModel {
  final String id;
  final String poNumber;
  final String urgencyTag;
  final String title;
  final String patientId;
  final String facility;
  final String facilityEmail;
  final String dateOfSurgery;
  final String surgeryTime;
  final String surgeon;
  final String surgeonSpecialty;
  final String vendor;
  final String vendorEmail;
  final double totalAmount;
  final String? imageAsset;
  final String? handWritePODoc;
  final String? notes;
  final bool isSentToVendor;
  final List<POProductItem> products;
  final List<PODocumentItem> documents;
  final List<POTimelineItem> timeline;
  final String? repName;
  final String? repAvatarAsset;

  const ManagerPODetailModel({
    required this.id,
    required this.poNumber,
    required this.urgencyTag,
    required this.title,
    required this.patientId,
    required this.facility,
    required this.facilityEmail,
    required this.dateOfSurgery,
    required this.surgeryTime,
    required this.surgeon,
    required this.surgeonSpecialty,
    required this.vendor,
    required this.vendorEmail,
    required this.totalAmount,
    this.imageAsset,
    this.handWritePODoc,
    this.notes,
    this.isSentToVendor = false,
    required this.products,
    required this.documents,
    required this.timeline,
    this.repName,
    this.repAvatarAsset,
  });

  factory ManagerPODetailModel.fromJson(Map<String, dynamic> e) {
    final facilityMap = e['facility'] is Map
        ? e['facility'] as Map<String, dynamic>
        : <String, dynamic>{};
    final vendorMap = e['sendMailToVendor'] is Map
        ? e['sendMailToVendor'] as Map<String, dynamic>
        : <String, dynamic>{};

    // Products
    final prodList = e['products'] as List? ?? [];
    final productItems = prodList
        .whereType<Map<String, dynamic>>()
        .map((p) {
          final items = p['listOfItems'] as List? ?? [];
          final itemNames = items
              .whereType<Map>()
              .map((i) => i['slName']?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .join(', ');
          return POProductItem(
            name: p['productName']?.toString() ?? '',
            spec: itemNames.isNotEmpty
                ? itemNames
                : p['productId']?.toString() ?? '',
            price: 0,
          );
        })
        .toList();

    // Documents
    final docList = e['documents'] as List? ?? [];
    final documentItems = docList.map((url) {
      final s = url.toString();
      final isPdf = s.toLowerCase().endsWith('.pdf');
      return PODocumentItem(
        fileName: s.split('/').last,
        url: s,
        size: '',
        date: '',
        isPdf: isPdf,
      );
    }).toList();

    // Timeline
    final status = e['status']?.toString() ?? '';
    final isSent = e['isSentToVendor'] as bool? ?? false;
    final timelineItems = _buildTimeline(
        status, isSent, e['createdAt']?.toString());

    return ManagerPODetailModel(
      id: e['_id']?.toString() ?? '',
      poNumber: 'PO #${e['purchaseOrderNumber']?.toString() ?? ''}',
      urgencyTag: e['orderType']?.toString() ?? '',
      title: e['purchaseOrderNumber']?.toString() ?? '',
      patientId: e['patientId']?.toString() ?? '',
      facility: facilityMap['address']?.toString() ??
          facilityMap['facilityName']?.toString() ??
          '',
      facilityEmail: e['facilityEmail']?.toString() ?? '',
      dateOfSurgery: _poFormatDate(e['procedureDate']?.toString()),
      surgeryTime: '',
      surgeon: '',
      surgeonSpecialty: '',
      vendor: vendorMap['name']?.toString() ?? '',
      vendorEmail: vendorMap['email']?.toString() ?? '',
      totalAmount: (e['totalAmount'] as num?)?.toDouble() ?? 0.0,
      imageAsset: null,
      handWritePODoc: e['handWritePODoc']?.toString(),
      notes: e['notes']?.toString(),
      isSentToVendor: isSent,
      products: productItems,
      documents: documentItems,
      timeline: timelineItems,
      repName: null,
      repAvatarAsset: null,
    );
  }

  static List<POTimelineItem> _buildTimeline(
      String status, bool isSent, String? createdAt) {
    return [
      POTimelineItem(
        title: 'Created',
        subtitle: _poFormatDate(createdAt),
        status: POTimelineStatus.done,
      ),
      POTimelineItem(
        title: 'Sent to Vendor',
        subtitle: isSent ? 'Sent' : 'Pending',
        status: isSent ? POTimelineStatus.done : POTimelineStatus.pending,
      ),
      POTimelineItem(
        title: 'Complete',
        subtitle: status == 'complete' ? 'Done' : 'Pending',
        status: status == 'complete'
            ? POTimelineStatus.done
            : POTimelineStatus.pending,
      ),
    ];
  }

  static const ManagerPODetailModel empty = ManagerPODetailModel(
    id: '',
    poNumber: '',
    urgencyTag: '',
    title: '',
    patientId: '',
    facility: '',
    facilityEmail: '',
    dateOfSurgery: '',
    surgeryTime: '',
    surgeon: '',
    surgeonSpecialty: '',
    vendor: '',
    vendorEmail: '',
    totalAmount: 0,
    products: [],
    documents: [],
    timeline: [],
  );
}

// ── Sub-models ────────────────────────────────────────────────────────────────

class POProductItem {
  final String name;
  final String spec;
  final double price;

  const POProductItem({
    required this.name,
    required this.spec,
    required this.price,
  });
}

class PODocumentItem {
  final String fileName;
  final String url;
  final String size;
  final String date;
  final bool isPdf;

  const PODocumentItem({
    required this.fileName,
    this.url = '',
    required this.size,
    required this.date,
    required this.isPdf,
  });
}

enum POTimelineStatus { done, inProgress, pending }

class POTimelineItem {
  final String title;
  final String subtitle;
  final POTimelineStatus status;

  const POTimelineItem({
    required this.title,
    required this.subtitle,
    required this.status,
  });
}
