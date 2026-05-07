class TrackingEvent {
  final String status;
  final String timestamp;
  final String? location;
  final bool isDone;

  const TrackingEvent({
    required this.status,
    required this.timestamp,
    this.location,
    required this.isDone,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json, {bool isDone = false}) {
    return TrackingEvent(
      status: json['status']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ??
          json['createdAt']?.toString() ?? '',
      location: json['location']?.toString(),
      isDone: json['isCompleted'] == true || json['isDone'] == true || isDone,
    );
  }
}

class ShipmentProductItem {
  final String id;
  final String name;
  final String serialNumber;
  final String productType;

  const ShipmentProductItem({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.productType,
  });
}

class ShipmentModel {
  final String id;
  final String shipmentId;

  // Shipment Info
  final String company;
  final String jobName;
  final String recipientName;
  final String specialInstructions;
  final String priority;
  final String packageType;

  // Package Details
  final String serviceType;
  final String weight;
  final String dimensions;

  // Pickup
  final String pickupAddress;
  final String pickupContact;
  final String pickupPhone;
  final String pickupDate;
  final String pickupInstructions;
  final double? pickupLat;
  final double? pickupLng;

  // Dropoff
  final String dropoffAddress;
  final String dropoffContact;
  final String dropoffPhone;
  final String dropoffInstructions;
  final String dropoffFacility;
  final double? dropoffLat;
  final double? dropoffLng;

  // Status
  final String shipmentStatus;
  final String matchingStatus;
  final String driverName;
  final String driverPhone;

  // Collections
  final List<ShipmentProductItem> products;
  final List<TrackingEvent> trackingHistory;
  final List<String> fileUrls;

  const ShipmentModel({
    required this.id,
    required this.shipmentId,
    required this.company,
    required this.jobName,
    required this.recipientName,
    required this.specialInstructions,
    required this.priority,
    required this.packageType,
    required this.serviceType,
    required this.weight,
    required this.dimensions,
    required this.pickupAddress,
    required this.pickupContact,
    required this.pickupPhone,
    required this.pickupDate,
    required this.pickupInstructions,
    this.pickupLat,
    this.pickupLng,
    required this.dropoffAddress,
    required this.dropoffContact,
    required this.dropoffPhone,
    required this.dropoffInstructions,
    required this.dropoffFacility,
    this.dropoffLat,
    this.dropoffLng,
    required this.shipmentStatus,
    required this.matchingStatus,
    required this.driverName,
    required this.driverPhone,
    required this.products,
    required this.trackingHistory,
    required this.fileUrls,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    final info = json['shipmentInfo'] as Map<String, dynamic>? ?? {};
    final pkg = json['packageInfo'] as Map<String, dynamic>? ?? {};
    final pickup = json['pickupInfo'] as Map<String, dynamic>? ?? {};
    final dropoff = json['dropoffInfo'] as Map<String, dynamic>? ?? {};

    // GeoJSON coordinates: [longitude, latitude]
    final pickupLoc = pickup['location'] as Map<String, dynamic>? ?? {};
    final pickupCoords = pickupLoc['coordinates'] as List? ?? [];
    final dropoffLoc = dropoff['location'] as Map<String, dynamic>? ?? {};
    final dropoffCoords = dropoffLoc['coordinates'] as List? ?? [];

    final driverRaw = json['driver'];
    final driver = driverRaw is Map<String, dynamic> ? driverRaw : <String, dynamic>{};

    // Products
    final prodList = json['products'] as List? ?? [];
    final products = prodList.whereType<Map>().map((p) {
      final productRaw = p['product'];
      final product = productRaw is Map<String, dynamic> ? productRaw : <String, dynamic>{};
      return ShipmentProductItem(
        id: product['_id']?.toString() ?? p['_id']?.toString() ?? '',
        name: product['systemType']?.toString() ??
            product['name']?.toString() ??
            product['jobName']?.toString() ?? '',
        serialNumber: product['serialNumber']?.toString() ?? '',
        productType: p['productType']?.toString() ?? '',
      );
    }).toList();

    // Tracking history
    final trackList = json['trackingHistory'] as List? ?? [];
    final tracking = trackList.asMap().entries.map((e) {
      final t = e.value;
      if (t is! Map<String, dynamic>) return null;
      final isLast = e.key == trackList.length - 1;
      return TrackingEvent.fromJson(t, isDone: !isLast);
    }).whereType<TrackingEvent>().toList();

    // Files
    final fileList = json['files'] as List? ?? [];
    final fileUrls = fileList.whereType<Map>()
        .map((f) => f['url']?.toString() ?? f['path']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    return ShipmentModel(
      id: json['_id']?.toString() ?? '',
      shipmentId: json['shipmentId']?.toString() ?? '',
      company: info['company']?.toString() ?? '',
      jobName: info['jobName']?.toString() ?? info['name']?.toString() ?? '',
      recipientName: info['recipient']?.toString() ?? info['recipientName']?.toString() ?? '',
      specialInstructions: pkg['spacialInstructions']?.toString() ?? info['specialInstructions']?.toString() ?? '',
      priority: info['priority']?.toString() ?? '',
      packageType: info['packageType']?.toString() ?? '',
      serviceType: pkg['serviceType']?.toString() ?? '',
      weight: pkg['weight']?.toString() ?? '',
      dimensions: pkg['dimensions']?.toString() ?? '',
      pickupAddress: pickup['address']?.toString() ?? '',
      pickupContact: pickup['contactPerson']?.toString() ?? '',
      pickupPhone: pickup['phoneNumber']?.toString() ?? pickup['phone']?.toString() ?? '',
      pickupDate: pickup['pickupDate']?.toString() ?? '',
      pickupInstructions: pickup['instructions']?.toString() ?? '',
      pickupLat: pickupCoords.length > 1 ? (pickupCoords[1] as num?)?.toDouble() : null,
      pickupLng: pickupCoords.isNotEmpty ? (pickupCoords[0] as num?)?.toDouble() : null,
      dropoffAddress: dropoff['address']?.toString() ?? '',
      dropoffContact: dropoff['contactPerson']?.toString() ?? '',
      dropoffPhone: dropoff['phoneNumber']?.toString() ?? dropoff['phone']?.toString() ?? '',
      dropoffInstructions: dropoff['instructions']?.toString() ?? '',
      dropoffFacility: dropoff['facilityId']?.toString() ?? dropoff['facility']?.toString() ?? '',
      dropoffLat: dropoffCoords.length > 1 ? (dropoffCoords[1] as num?)?.toDouble() : null,
      dropoffLng: dropoffCoords.isNotEmpty ? (dropoffCoords[0] as num?)?.toDouble() : null,
      shipmentStatus: json['shipmentStatus']?.toString() ?? json['status']?.toString() ?? '',
      matchingStatus: json['matchingStatus']?.toString() ?? '',
      driverName: driver['name']?.toString() ??
          driver['firstName']?.toString() ?? '',
      driverPhone: driver['phone']?.toString() ?? '',
      products: products,
      trackingHistory: tracking,
      fileUrls: fileUrls.cast<String>(),
    );
  }

  // Display helpers
  String get displayTitle => jobName.isNotEmpty ? jobName : company;
  String get refDisplay => shipmentId.isNotEmpty ? shipmentId : '#${id.length > 8 ? id.substring(0, 8).toUpperCase() : id}';
}
