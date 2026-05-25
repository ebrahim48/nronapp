class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? profileUrl;
  final String? bio;
  final String? designation;
  final String? address;
  final String? currentAddress;
  final bool isProfileSetupCompleted;
  final double? latitude;
  final double? longitude;
  // Stats
  final double totalEarnings;
  final int totalDeliveries;
  final double successRate;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.profileUrl,
    this.bio,
    this.designation,
    this.address,
    this.currentAddress,
    this.isProfileSetupCompleted = false,
    this.latitude,
    this.longitude,
    this.totalEarnings = 0.0,
    this.totalDeliveries = 0,
    this.successRate = 0.0,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // GET response wraps data in user/userStats; UPDATE response is flat
    final user = json['user'] as Map<String, dynamic>? ?? json;
    final stats = json['userStats'] as Map<String, dynamic>? ?? {};

    final coords =
        (user['location'] as Map<String, dynamic>?)?['coordinates'] as List?;

    return UserProfileModel(
      id: user['_id']?.toString() ?? '',
      fullName: user['fullName']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      role: user['role']?.toString() ?? '',
      profileUrl: user['profileUrl']?.toString(),
      bio: user['bio']?.toString(),
      designation: user['designation']?.toString(),
      address: user['address']?.toString(),
      currentAddress: user['currentAddress']?.toString(),
      isProfileSetupCompleted:
          user['isProfileSetupCompleted'] as bool? ?? false,
      // GeoJSON: [lng, lat]
      longitude: coords != null && coords.length >= 2
          ? (coords[0] as num?)?.toDouble()
          : null,
      latitude: coords != null && coords.length >= 2
          ? (coords[1] as num?)?.toDouble()
          : null,
      totalEarnings: (stats['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      totalDeliveries: (stats['totalDeliveries'] as num?)?.toInt() ?? 0,
      successRate: (stats['successRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get avatarInitial =>
      fullName.isNotEmpty ? fullName[0].toUpperCase() : 'D';
}
