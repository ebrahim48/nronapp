// Manager shipment model — mirrors the representative ShipmentModel structure
// so the same map/UI patterns apply.

enum ShipmentStatus { pending, inTransit, delivered, pendingApproval, accepted, other }

// ── Tracking event ────────────────────────────────────────────────────────────

class ManagerTrackingEvent {
  final String status;
  final String title;
  final String description;
  final String timestamp;
  final bool isDone;

  const ManagerTrackingEvent({
    required this.status,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isDone,
  });

  factory ManagerTrackingEvent.fromJson(Map<String, dynamic> e,
      {bool isDone = false}) {
    return ManagerTrackingEvent(
      status: e['status']?.toString() ?? '',
      title: e['title']?.toString() ?? e['status']?.toString() ?? '',
      description: e['description']?.toString() ?? '',
      timestamp: e['timestamp']?.toString() ?? '',
      isDone: isDone,
    );
  }
}

// ── Product item ──────────────────────────────────────────────────────────────

class ManagerShipmentProduct {
  final String id;
  final String name;
  final String serialNumber;
  final String productType;

  const ManagerShipmentProduct({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.productType,
  });
}

// ── Main model ────────────────────────────────────────────────────────────────

class ShipmentModel {
  final String id;
  final String shipmentId;

  // Shipment info
  final String company;
  final String type;
  final String priority;

  // Package
  final String serviceType;
  final String weight;
  final String dimensions;
  final String specialInstructions;

  // Pickup
  final String pickupAddress;
  final String pickupPhone;
  final String pickupDate;
  final String pickupInstructions;
  final double? pickupLat;
  final double? pickupLng;

  // Dropoff
  final String dropoffAddress;
  final String dropoffFacility;
  final String dropoffPhone;
  final String dropoffInstructions;
  final double? dropoffLat;
  final double? dropoffLng;

  // Status
  final String shipmentStatus;
  final String matchingStatus;
  final String status;

  // Driver
  final String driverName;
  final String driverEmail;
  final String driverProfileUrl;

  // Financials
  final double totalPrice;
  final String totalDistance;

  // Collections
  final List<ManagerShipmentProduct> products;
  final List<ManagerTrackingEvent> trackingHistory;
  final List<String> fileUrls;

  const ShipmentModel({
    required this.id,
    required this.shipmentId,
    required this.company,
    required this.type,
    required this.priority,
    required this.serviceType,
    required this.weight,
    required this.dimensions,
    required this.specialInstructions,
    required this.pickupAddress,
    required this.pickupPhone,
    required this.pickupDate,
    required this.pickupInstructions,
    this.pickupLat,
    this.pickupLng,
    required this.dropoffAddress,
    required this.dropoffFacility,
    required this.dropoffPhone,
    required this.dropoffInstructions,
    this.dropoffLat,
    this.dropoffLng,
    required this.shipmentStatus,
    required this.matchingStatus,
    required this.status,
    required this.driverName,
    required this.driverEmail,
    required this.driverProfileUrl,
    required this.totalPrice,
    required this.totalDistance,
    required this.products,
    required this.trackingHistory,
    required this.fileUrls,
  });

  // ── fromJson ────────────────────────────────────────────────────────────────

  factory ShipmentModel.fromJson(Map<String, dynamic> e) {
    final info = e['shipmentInfo'] is Map
        ? e['shipmentInfo'] as Map<String, dynamic>
        : <String, dynamic>{};
    final pkg = e['packageInfo'] is Map
        ? e['packageInfo'] as Map<String, dynamic>
        : <String, dynamic>{};
    final pickup = e['pickupInfo'] is Map
        ? e['pickupInfo'] as Map<String, dynamic>
        : <String, dynamic>{};
    final dropoff = e['dropoffInfo'] is Map
        ? e['dropoffInfo'] as Map<String, dynamic>
        : <String, dynamic>{};

    // GeoJSON: [longitude, latitude]
    final pickupLoc = pickup['location'] is Map
        ? pickup['location'] as Map<String, dynamic>
        : <String, dynamic>{};
    final pickupCoords = pickupLoc['coordinates'] as List? ?? [];
    final dropoffLoc = dropoff['location'] is Map
        ? dropoff['location'] as Map<String, dynamic>
        : <String, dynamic>{};
    final dropoffCoords = dropoffLoc['coordinates'] as List? ?? [];

    // Driver
    final driverRaw = e['assigneeDriver'];
    final driver = driverRaw is Map<String, dynamic>
        ? driverRaw
        : <String, dynamic>{};

    // Products
    final prodList = e['products'] as List? ?? [];
    final products = prodList.whereType<Map>().map((p) {
      final productRaw = p['product'];
      final product = productRaw is Map<String, dynamic>
          ? productRaw
          : <String, dynamic>{};
      return ManagerShipmentProduct(
        id: product['_id']?.toString() ?? p['_id']?.toString() ?? '',
        name: product['systemType']?.toString() ??
            product['name']?.toString() ?? '',
        serialNumber: product['serialNumber']?.toString() ?? '',
        productType: p['productType']?.toString() ?? '',
      );
    }).toList();

    // Tracking history
    final trackList = e['trackingHistory'] as List? ?? [];
    final tracking = trackList.asMap().entries.map((entry) {
      final t = entry.value;
      if (t is! Map<String, dynamic>) return null;
      final isDone = entry.key < trackList.length - 1;
      return ManagerTrackingEvent.fromJson(t, isDone: isDone);
    }).whereType<ManagerTrackingEvent>().toList();

    // Files
    final fileList = e['files'] as List? ?? [];
    final fileUrls = fileList
        .map((f) => f.toString())
        .where((s) => s.isNotEmpty)
        .toList();

    // Dropoff facility name
    final facilityRaw = dropoff['facility'];
    final facilityName = facilityRaw is Map
        ? (facilityRaw as Map)['name']?.toString() ??
            (facilityRaw)['address']?.toString() ?? ''
        : facilityRaw?.toString() ?? '';

    return ShipmentModel(
      id: e['_id']?.toString() ?? '',
      shipmentId: e['shipmentId']?.toString() ?? '',
      company: info['company']?.toString() ?? '',
      type: info['type']?.toString() ?? '',
      priority: info['priority']?.toString() ?? '',
      serviceType: pkg['serviceType']?.toString() ?? '',
      weight: pkg['weight']?.toString() ?? '',
      dimensions: pkg['dimensions']?.toString() ?? '',
      specialInstructions: pkg['spacialInstructions']?.toString() ?? '',
      pickupAddress: pickup['address']?.toString() ?? '',
      pickupPhone: pickup['phoneNumber']?.toString() ?? '',
      pickupDate: pickup['pickupDate']?.toString() ?? '',
      pickupInstructions: pickup['instructions']?.toString() ?? '',
      pickupLat: pickupCoords.length > 1
          ? (pickupCoords[1] as num?)?.toDouble()
          : null,
      pickupLng: pickupCoords.isNotEmpty
          ? (pickupCoords[0] as num?)?.toDouble()
          : null,
      dropoffAddress: dropoff['address']?.toString() ?? '',
      dropoffFacility: facilityName,
      dropoffPhone: dropoff['phoneNumber']?.toString() ?? '',
      dropoffInstructions: dropoff['instructions']?.toString() ?? '',
      dropoffLat: dropoffCoords.length > 1
          ? (dropoffCoords[1] as num?)?.toDouble()
          : null,
      dropoffLng: dropoffCoords.isNotEmpty
          ? (dropoffCoords[0] as num?)?.toDouble()
          : null,
      shipmentStatus: e['shipmentStatus']?.toString() ?? '',
      matchingStatus: e['matchingStatus']?.toString() ?? '',
      status: e['status']?.toString() ?? '',
      driverName: driver['fullName']?.toString() ?? driver['email']?.toString() ?? '',
      driverEmail: driver['email']?.toString() ?? '',
      driverProfileUrl: driver['profileUrl']?.toString() ?? '',
      totalPrice: (e['totalPrice'] as num?)?.toDouble() ?? 0.0,
      totalDistance: e['totalDistance']?.toString() ?? '',
      products: products,
      trackingHistory: tracking,
      fileUrls: fileUrls,
    );
  }

  // ── Display helpers ───────────────────────────────────────────────────────

  String get displayTitle =>
      shipmentId.isNotEmpty ? shipmentId : company.isNotEmpty ? company : id;

  String get displayStatus => shipmentStatus.isNotEmpty ? shipmentStatus : status;

  ShipmentStatus get statusEnum {
    switch (displayStatus.toLowerCase()) {
      case 'pending':
        return ShipmentStatus.pending;
      case 'in_transit':
      case 'intransit':
        return ShipmentStatus.inTransit;
      case 'delivered':
        return ShipmentStatus.delivered;
      case 'pending_approval':
        return ShipmentStatus.pendingApproval;
      case 'accepted':
        return ShipmentStatus.accepted;
      default:
        return ShipmentStatus.other;
    }
  }
}

// ── Legacy JobReviewModel (kept for backward compat) ─────────────────────────

class JobReviewModel {
  final String status;
  final String jobId;
  final String packageName;
  final String packageType;
  final String driverName;
  final String driverAvatar;
  final String serviceType;
  final String pickupDate;
  final String pickupTime;
  final String pickupLocation;
  final String pickupBuilding;
  final String pickupNote;
  final String dropoffEstTime;
  final String dropoffLocation;
  final String dropoffBuilding;
  final String dropoffNote;
  final String weight;
  final String dimensions;
  final String items;
  final String service;

  const JobReviewModel({
    required this.status,
    required this.jobId,
    required this.packageName,
    required this.packageType,
    required this.driverName,
    required this.driverAvatar,
    required this.serviceType,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupLocation,
    required this.pickupBuilding,
    required this.pickupNote,
    required this.dropoffEstTime,
    required this.dropoffLocation,
    required this.dropoffBuilding,
    required this.dropoffNote,
    required this.weight,
    required this.dimensions,
    required this.items,
    required this.service,
  });
}
