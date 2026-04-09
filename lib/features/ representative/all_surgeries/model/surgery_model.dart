class SurgeryModel {
  final String id;
  final String patientName;
  final String procedureName;
  final String facility;
  final String dateTime;
  final String? imageAsset;

  const SurgeryModel({
    required this.id,
    required this.patientName,
    required this.procedureName,
    required this.facility,
    required this.dateTime,
    this.imageAsset,
  });
}

class SurgeryDetailModel {
  final String patientName;
  final String? avatarAsset;
  final String physician;
  final String ptId;
  final String facility;
  final String dateOfSurgery;
  final String surgeryType;
  final List<SurgeryAttachment> attachments;
  final List<SurgeryMaterialGroup> materials;
  final List<RadiologyImage> radiologyImages;

  const SurgeryDetailModel({
    required this.patientName,
    this.avatarAsset,
    required this.physician,
    required this.ptId,
    required this.facility,
    required this.dateOfSurgery,
    required this.surgeryType,
    required this.attachments,
    required this.materials,
    required this.radiologyImages,
  });
}

class SurgeryAttachment {
  final String fileName;
  final bool isPdf;

  const SurgeryAttachment({required this.fileName, required this.isPdf});
}

class SurgeryMaterialGroup {
  final String category; // SCREWS, RODS/CONNECTORS, PLATES, IMPLANTS, BIOLOGICS
  final String detail;

  const SurgeryMaterialGroup({
    required this.category,
    required this.detail,
  });
}

class RadiologyImage {
  final String label;
  final String? imageAsset;

  const RadiologyImage({required this.label, this.imageAsset});
}

// For add surgery form
class SurgeryFormData {
  String physician;
  String patientId;
  String facility;
  String dateOfSurgery;
  String surgeryType;
  String screws;
  String plates;
  String rodsConnectors;
  String implants;
  String biologics;
  String caseNotes;
  List<String> uploadedFiles;

  SurgeryFormData({
    this.physician = '',
    this.patientId = '',
    this.facility = '',
    this.dateOfSurgery = '',
    this.surgeryType = '',
    this.screws = '',
    this.plates = '',
    this.rodsConnectors = '',
    this.implants = '',
    this.biologics = '',
    this.caseNotes = '',
    List<String>? uploadedFiles,
  }) : uploadedFiles = uploadedFiles ?? [];
}