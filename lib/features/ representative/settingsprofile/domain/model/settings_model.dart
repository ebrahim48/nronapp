class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? profileUrl;
  final String? bio;
  final String? designation;
  final String? address;
  final String? employeeId;
  final String? territory;
  // kept for backward-compat with ProfileStatsRow
  final int totalPos;
  final String commYtd;
  final double rating;
  final String phone;

  const UserProfileModel({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.role = '',
    this.profileUrl,
    this.bio,
    this.designation,
    this.address,
    this.employeeId,
    this.territory,
    this.totalPos = 0,
    this.commYtd = '',
    this.rating = 0.0,
    this.phone = '',
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profileUrl: json['profileUrl'],
      bio: json['bio'],
      designation: json['designation'],
      address: json['address'],
      employeeId: json['employeeId'],
      territory: json['territory'],
    );
  }
}

class SettingsTileModel {
  final String iconPath;
  final String title;
  final String subtitle;
  final String route;

  const SettingsTileModel({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}

class OthersTileModel {
  final String iconPath;
  final String title;
  final String route;

  const OthersTileModel({
    required this.iconPath,
    required this.title,
    required this.route,
  });
}

class ContentModel {
  final String id;
  final String content;
  final String description;

  const ContentModel({
    required this.id,
    required this.content,
    required this.description,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
