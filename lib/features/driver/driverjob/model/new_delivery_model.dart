class NewDeliveryModel {
  final String shipmentId;
  final bool isUrgent;
  final double earnings;
  final double distanceKm;

  // Pickup
  final String pickupName;
  final String pickupAddress;
  final String pickupContact;
  final String pickupPhone;

  // Dropoff
  final String dropoffName;
  final String dropoffAddress;
  final String dropoffContact;
  final String dropoffPhone;

  // Package
  final String servicesType;
  final String weight;
  final String dimensions;

  // Special instructions
  final String? specialInstructions;

  const NewDeliveryModel({
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
    required this.servicesType,
    required this.weight,
    required this.dimensions,
    this.specialInstructions,
  });
}