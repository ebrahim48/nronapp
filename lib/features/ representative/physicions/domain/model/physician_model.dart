class ContactInfoModel {
  final String phoneNumber;
  final String cellNumber;
  final String email;
  final String dateOfBirth;

  const ContactInfoModel({
    this.phoneNumber = '',
    this.cellNumber = '',
    this.email = '',
    this.dateOfBirth = '',
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phoneNumber: json['phoneNumber'] ?? '',
      cellNumber: json['cellNumber'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
    );
  }
}

class PhysicianModel {
  final String id;
  final String fullName;
  final String practice;
  final String specialty;
  final String location;
  final ContactInfoModel contactInfo;
  final String noteToSelf;
  final List<String> documents;
  final String profileUrl;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  const PhysicianModel({
    this.id = '',
    this.fullName = '',
    this.practice = '',
    this.specialty = '',
    this.location = '',
    this.contactInfo = const ContactInfoModel(),
    this.noteToSelf = '',
    this.documents = const [],
    this.profileUrl = '',
    this.isDeleted = false,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory PhysicianModel.fromJson(Map<String, dynamic> json) {
    return PhysicianModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      practice: json['practice'] ?? '',
      specialty: json['specialty'] ?? '',
      location: json['location'] ?? '',
      contactInfo: json['contactInfo'] != null
          ? ContactInfoModel.fromJson(
              json['contactInfo'] as Map<String, dynamic>)
          : const ContactInfoModel(),
      noteToSelf: json['noteToSelf'] ?? '',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      profileUrl: json['profileUrl'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
