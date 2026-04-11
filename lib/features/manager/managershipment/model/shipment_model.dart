enum ShipmentStatus { pending, inTransit, delivered }

class ShipmentModel {
  final String id;
  final String title;
  final String refNumber;
  final String driver;
  final String pickupDate;
  final String pickup;
  final String dropAddress;
  final ShipmentStatus status;

  const ShipmentModel({
    required this.id,
    required this.title,
    required this.refNumber,
    required this.driver,
    required this.pickupDate,
    required this.pickup,
    required this.dropAddress,
    required this.status,
  });
}

class JobReviewModel {
  final String status;
  final String jobId;
  final String packageName;
  final String packageType;
  final String pickupDate;
  final String pickupTime;
  final String pickupLocation;
  final String pickupBuilding;
  final String pickupNote;
  final String dropoffEstTime;
  final String dropoffLocation;
  final String dropoffBuilding;
  final String dropoffNote;
  final String items;
  final String weight;
  final String service;

  const JobReviewModel({
    required this.status,
    required this.jobId,
    required this.packageName,
    required this.packageType,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupLocation,
    required this.pickupBuilding,
    required this.pickupNote,
    required this.dropoffEstTime,
    required this.dropoffLocation,
    required this.dropoffBuilding,
    required this.dropoffNote,
    required this.items,
    required this.weight,
    required this.service,
  });
}