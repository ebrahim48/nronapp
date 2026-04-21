class DriverProfileModel {
  final String name;
  final String driverId;
  final bool isAvailable;
  final int completedDeliveries;
  final double successRate;
  final double totalEarnings;
  final String avatarInitial;

  const DriverProfileModel({
    required this.name,
    required this.driverId,
    required this.isAvailable,
    required this.completedDeliveries,
    required this.successRate,
    required this.totalEarnings,
    required this.avatarInitial,
  });

  DriverProfileModel copyWith({bool? isAvailable}) {
    return DriverProfileModel(
      name: name,
      driverId: driverId,
      isAvailable: isAvailable ?? this.isAvailable,
      completedDeliveries: completedDeliveries,
      successRate: successRate,
      totalEarnings: totalEarnings,
      avatarInitial: avatarInitial,
    );
  }
}

class PersonalInfoModel {
  final String fullName;
  final String address;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String bio;

  const PersonalInfoModel({
    required this.fullName,
    required this.address,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.bio,
  });
}

enum DocumentStatus { uploaded, notUploaded }

class DocumentItemModel {
  final String id;
  final String title;
  final String imageAsset;
  final DocumentStatus status;

  const DocumentItemModel({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.status,
  });
}