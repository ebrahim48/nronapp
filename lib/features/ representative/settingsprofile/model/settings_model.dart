class UserProfileModel {
  final String name;
  final String role;
  final String company;
  final String? avatarAsset;
  final int totalPos;
  final String commYtd;
  final double rating;
  final String email;
  final String phone;
  final String territory;
  final String employeeId;

  const UserProfileModel({
    required this.name,
    required this.role,
    required this.company,
    this.avatarAsset,
    required this.totalPos,
    required this.commYtd,
    required this.rating,
    required this.email,
    required this.phone,
    required this.territory,
    required this.employeeId,
  });
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