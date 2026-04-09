class ImplantModel {
  final String id;
  final String serialNumber;
  final String name;
  final String lotNumber;
  final String material;
  final String systemType;
  final String vendor;
  final String status; 
  final String facility;
  final String recipientEmail;
  final String? imageAsset;
  final String? additionalNote;
  final List<ImplantFile> uploadedFiles;

  const ImplantModel({
    required this.id,
    required this.serialNumber,
    required this.name,
    required this.lotNumber,
    required this.material,
    required this.systemType,
    required this.vendor,
    required this.status,
    required this.facility,
    required this.recipientEmail,
    this.imageAsset,
    this.additionalNote,
    this.uploadedFiles = const [],
  });
}

class ImplantFile {
  final String fileName;
  final String size;
  final String date;
  final String category;

  const ImplantFile({
    required this.fileName,
    required this.size,
    required this.date,
    required this.category,
  });
}

class ReceivingBoxModel {
  final String boxCode;
  final String description;
  final int itemCount;
  final List<String> serialRanges;
  bool isExpanded;

  ReceivingBoxModel({
    required this.boxCode,
    required this.description,
    required this.itemCount,
    required this.serialRanges,
    this.isExpanded = false,
  });
}