class ShipmentModel {
  final String id;
  final String refNumber;
  final String title;
  final String status;
  final String driverName;
  final bool driverAssigned;
  final String pickupAddress;
  final String dropAddress;
  final String pickupDate;
  final String pickupTime;
  final String? packageType;
  final double? weight;
  final String? dimensions;
  final String? serviceType;
  final String? jobId;

  const ShipmentModel({
    required this.id,
    required this.refNumber,
    required this.title,
    required this.status,
    required this.driverName,
    required this.driverAssigned,
    required this.pickupAddress,
    required this.dropAddress,
    required this.pickupDate,
    required this.pickupTime,
    this.packageType,
    this.weight,
    this.dimensions,
    this.serviceType,
    this.jobId,
  });
}