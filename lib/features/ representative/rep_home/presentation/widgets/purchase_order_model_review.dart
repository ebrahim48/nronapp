
class PurchaseOrderModelreview {
  final String poNumber;
  final String poType; // 'Emergency' | 'Standard'
  final String title;
  final String heroImageAsset;

  // Info fields
  final String patientId;
  final String facility;
  final String facilityEmail;
  final String surgeon;
  final String surgeonSpecialty;
  final String dateOfSurgery;
  final String surgeryTime;
  final String vendor;
  final String vendorEmail;
  final double totalAmount;

  // Products
  final List<PoProductModel> products;

  // Attachments
  final List<PoDocumentModel> documents;

  const PurchaseOrderModelreview({
    required this.poNumber,
    required this.poType,
    required this.title,
    required this.heroImageAsset,
    required this.patientId,
    required this.facility,
    required this.facilityEmail,
    required this.surgeon,
    required this.surgeonSpecialty,
    required this.dateOfSurgery,
    required this.surgeryTime,
    required this.vendor,
    required this.vendorEmail,
    required this.totalAmount,
    required this.products,
    required this.documents,
  });
}

class PoProductModel {
  final String boxCode;
  final String description;
  final int itemCount;
  final List<String> serialRanges;
  bool isExpanded;

  PoProductModel({
    required this.boxCode,
    required this.description,
    required this.itemCount,
    this.serialRanges = const [],
    this.isExpanded = false,
  });
}

class PoDocumentModel {
  final String fileName;
  final String size;
  final String date;
  final String type; // 'pdf' | 'image'

  const PoDocumentModel({
    required this.fileName,
    required this.size,
    required this.date,
    required this.type,
  });
}