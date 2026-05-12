class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? profileUrl;
  final String? bio;
  final String? designation;
  final String? address;
  final bool isProfileSetupCompleted;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.profileUrl,
    this.bio,
    this.designation,
    this.address,
    this.isProfileSetupCompleted = false,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      profileUrl: json['profileUrl']?.toString(),
      bio: json['bio']?.toString(),
      designation: json['designation']?.toString(),
      address: json['address']?.toString(),
      isProfileSetupCompleted:
          json['isProfileSetupCompleted'] as bool? ?? false,
    );
  }

  String get avatarInitial =>
      fullName.isNotEmpty ? fullName[0].toUpperCase() : 'D';
}
