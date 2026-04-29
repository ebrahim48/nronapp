// ── Common physician (from /common/all-physicians) ───────────────────────────
class CommonPhysicianModel {
  final String id;
  final String fullName;
  final String specialty;
  final String profileUrl;

  const CommonPhysicianModel({
    this.id = '',
    this.fullName = '',
    this.specialty = '',
    this.profileUrl = '',
  });

  factory CommonPhysicianModel.fromJson(Map<String, dynamic> json) {
    return CommonPhysicianModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      specialty: json['specialty'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
    );
  }
}

// ── Surgery list item (from /surgery/get-all) ─────────────────────────────────
class SurgeryModel {
  final String id;
  final String createdBy;
  final String physicianName;
  final String physicianProfileUrl;
  final String physicianId;
  final String patientId;
  final String facilityId;
  final String facilityName;
  final String dateOfSurgery;
  final String surgeryType;
  final String createdAt;

  const SurgeryModel({
    this.id = '',
    this.createdBy = '',
    this.physicianName = '',
    this.physicianProfileUrl = '',
    this.physicianId = '',
    this.patientId = '',
    this.facilityId = '',
    this.facilityName = '',
    this.dateOfSurgery = '',
    this.surgeryType = '',
    this.createdAt = '',
  });

  factory SurgeryModel.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>? ?? {};
    final physician = info['physician'];
    final facility = info['facility'];

    return SurgeryModel(
      id: json['_id'] ?? '',
      createdBy: json['createdBy'] ?? '',
      physicianName: info['fullName'] ?? '',
      physicianProfileUrl: info['profileUrl'] ?? '',
      physicianId: physician is String ? physician : (physician is Map ? physician['_id'] ?? '' : ''),
      patientId: info['patientId'] ?? '',
      facilityId: facility is String ? facility : (facility is Map ? facility['_id'] ?? '' : ''),
      facilityName: facility is Map ? facility['name'] ?? '' : '',
      dateOfSurgery: info['dateOfSurgery'] ?? '',
      surgeryType: info['surgeryType'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

// ── Surgery detail (from /surgery/find/:id) ───────────────────────────────────
class SurgeryDetailModel {
  final String id;
  final String createdBy;
  final String physicianName;
  final String physicianProfileUrl;
  final String physicianId;
  final String physicianPractice;
  final String physicianSpecialty;
  final String physicianPhone;
  final String physicianEmail;
  final String patientId;
  final String facilityId;
  final String facilityName;
  final String facilityAddress;
  final String dateOfSurgery;
  final String surgeryType;
  // materials
  final String screws;
  final String plates;
  final String rodsOrConnectors;
  final String implants;
  // radiology
  final String patientSticker;
  final String preOpAP;
  final String postOpAP;
  final String preOpLateral;
  final String postOpLateral;
  // docs & notes
  final List<String> files;
  final String caseNotes;
  final String createdAt;
  final String updatedAt;

  const SurgeryDetailModel({
    this.id = '',
    this.createdBy = '',
    this.physicianName = '',
    this.physicianProfileUrl = '',
    this.physicianId = '',
    this.physicianPractice = '',
    this.physicianSpecialty = '',
    this.physicianPhone = '',
    this.physicianEmail = '',
    this.patientId = '',
    this.facilityId = '',
    this.facilityName = '',
    this.facilityAddress = '',
    this.dateOfSurgery = '',
    this.surgeryType = '',
    this.screws = '',
    this.plates = '',
    this.rodsOrConnectors = '',
    this.implants = '',
    this.patientSticker = '',
    this.preOpAP = '',
    this.postOpAP = '',
    this.preOpLateral = '',
    this.postOpLateral = '',
    this.files = const [],
    this.caseNotes = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory SurgeryDetailModel.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>? ?? {};
    final physician = info['physician'] as Map<String, dynamic>? ?? {};
    final facility = info['facility'] as Map<String, dynamic>? ?? {};
    final contact = physician['contactInfo'] as Map<String, dynamic>? ?? {};
    final materials = json['surgeryMaterial'] as Map<String, dynamic>? ?? {};
    final radiology = json['radiologyClinicalFile'] as Map<String, dynamic>? ?? {};
    final docNotes = json['docAndNotes'] as Map<String, dynamic>? ?? {};

    return SurgeryDetailModel(
      id: json['_id'] ?? '',
      createdBy: json['createdBy'] ?? '',
      physicianName: info['fullName'] ?? '',
      physicianProfileUrl: info['profileUrl'] ?? '',
      physicianId: physician['_id'] ?? '',
      physicianPractice: physician['practice'] ?? '',
      physicianSpecialty: physician['specialty'] ?? '',
      physicianPhone: contact['phoneNumber'] ?? '',
      physicianEmail: contact['email'] ?? '',
      patientId: info['patientId'] ?? '',
      facilityId: facility['_id'] ?? '',
      facilityName: facility['name'] ?? '',
      facilityAddress: facility['address'] ?? '',
      dateOfSurgery: info['dateOfSurgery'] ?? '',
      surgeryType: info['surgeryType'] ?? '',
      screws: materials['screws'] ?? '',
      plates: materials['plates'] ?? '',
      rodsOrConnectors: materials['rodsOrconnectors'] ?? '',
      implants: materials['implants'] ?? '',
      patientSticker: radiology['patientSticker'] ?? '',
      preOpAP: radiology['preOpAP'] ?? '',
      postOpAP: radiology['postOpAP'] ?? '',
      preOpLateral: radiology['preOpLateral'] ?? '',
      postOpLateral: radiology['postOpLateral'] ?? '',
      files: (docNotes['files'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      caseNotes: docNotes['caseNotes'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

// ── Legacy support for widgets that use these ─────────────────────────────────
class SurgeryAttachment {
  final String fileName;
  final bool isPdf;
  final String? url;
  const SurgeryAttachment({required this.fileName, required this.isPdf, this.url});
}

class SurgeryMaterialGroup {
  final String category;
  final String detail;
  const SurgeryMaterialGroup({required this.category, required this.detail});
}

class RadiologyImage {
  final String label;
  final String? imageAsset;
  final String? networkUrl;
  const RadiologyImage({required this.label, this.imageAsset, this.networkUrl});
}
