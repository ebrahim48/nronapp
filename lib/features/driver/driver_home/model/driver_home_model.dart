class DriverStatModel {
  final String iconPath;
  final String value;
  final String label;

  const DriverStatModel({
    required this.iconPath,
    required this.value,
    required this.label,
  });
}

class JobRequestModel {
  final String id;
  final String shipmentId;
  final bool isUrgent;
  final String timeAway;
  final String pickup;
  final String dropoff;
  final double distanceKm;
  final double earnings;

  const JobRequestModel({
    required this.id,
    required this.shipmentId,
    required this.isUrgent,
    required this.timeAway,
    required this.pickup,
    required this.dropoff,
    required this.distanceKm,
    required this.earnings,
  });
}

class JobDetailModel {
  final String shipmentId;
  final bool isUrgent;
  final double earnings;
  final double distanceKm;
  final String pickupName;
  final String pickupAddress;
  final String pickupContact;
  final String pickupPhone;
  final String dropoffName;
  final String dropoffAddress;
  final String dropoffContact;
  final String dropoffPhone;
  final String serviceType;
  final String weight;
  final String dimensions;
  final String specialInstructions;

  const JobDetailModel({
    required this.shipmentId,
    required this.isUrgent,
    required this.earnings,
    required this.distanceKm,
    required this.pickupName,
    required this.pickupAddress,
    required this.pickupContact,
    required this.pickupPhone,
    required this.dropoffName,
    required this.dropoffAddress,
    required this.dropoffContact,
    required this.dropoffPhone,
    required this.serviceType,
    required this.weight,
    required this.dimensions,
    required this.specialInstructions,
  });
}