import 'package:intl/intl.dart';

enum DriverJobTab { newJobs, active, completed }

enum JobPriority { urgent, standard }

/// Raw shipmentStatus values from the API
enum ShipmentStatus {
  pendingApproval,  // → New tab
  accepted,         // → Active tab
  pickedUp,         // → Active tab
  inTransit,        // → Active tab
  delivered,        // → Completed tab
  unknown,
}

extension ShipmentStatusX on ShipmentStatus {
  static ShipmentStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'pending_approval': return ShipmentStatus.pendingApproval;
      case 'accepted':
      case 'active':           return ShipmentStatus.accepted;
      case 'picked_up':        return ShipmentStatus.pickedUp;
      case 'in_transit':       return ShipmentStatus.inTransit;
      case 'delivered':
      case 'completed':        return ShipmentStatus.delivered;
      default:                 return ShipmentStatus.unknown;
    }
  }

  String get label {
    switch (this) {
      case ShipmentStatus.pendingApproval: return 'Pending Approval';
      case ShipmentStatus.accepted:        return 'Accepted';
      case ShipmentStatus.pickedUp:        return 'Picked Up';
      case ShipmentStatus.inTransit:       return 'In Transit';
      case ShipmentStatus.delivered:       return 'Delivered';
      case ShipmentStatus.unknown:         return 'Unknown';
    }
  }

  bool get isNew       => this == ShipmentStatus.pendingApproval;
  bool get isActive    => this == ShipmentStatus.accepted ||
                          this == ShipmentStatus.pickedUp ||
                          this == ShipmentStatus.inTransit;
  bool get isCompleted => this == ShipmentStatus.delivered;
}

/// Displayed status on the Active job card
enum ActiveJobStatus { accepted, pickedUp, inTransit }

extension ActiveJobStatusX on ActiveJobStatus {
  static ActiveJobStatus fromShipmentStatus(ShipmentStatus s) {
    switch (s) {
      case ShipmentStatus.pickedUp:  return ActiveJobStatus.pickedUp;
      case ShipmentStatus.inTransit: return ActiveJobStatus.inTransit;
      default:                       return ActiveJobStatus.accepted;
    }
  }

  String get label {
    switch (this) {
      case ActiveJobStatus.accepted:  return 'Accepted';
      case ActiveJobStatus.pickedUp:  return 'Picked Up';
      case ActiveJobStatus.inTransit: return 'In Transit';
    }
  }
}

enum CompletedPeriod { today, thisWeek, thisMonth }

class NewJobModel {
  final String id;
  final String shipmentId;
  final JobPriority priority;
  final String timeAway;
  final String pickup;
  final String dropoff;
  final double distanceKm;
  final double earnings;

  const NewJobModel({
    required this.id,
    required this.shipmentId,
    required this.priority,
    required this.timeAway,
    required this.pickup,
    required this.dropoff,
    required this.distanceKm,
    required this.earnings,
  });

  factory NewJobModel.fromJson(Map<String, dynamic> json) {
    final priorityStr =
        (json['shipmentInfo']?['priority'] ?? 'standard').toString().toLowerCase();
    final distanceStr =
        (json['totalDistance'] ?? json['shippingCost']?['distance'] ?? '0km')
            .toString()
            .replaceAll(RegExp(r'[^0-9.]'), '');
    final distance = double.tryParse(distanceStr) ?? 0.0;

    return NewJobModel(
      id: json['_id']?.toString() ?? '',
      shipmentId: json['shipmentId']?.toString() ?? '',
      priority:
          priorityStr == 'urgent' ? JobPriority.urgent : JobPriority.standard,
      timeAway: '',
      pickup: json['pickupInfo']?['address']?.toString() ?? '',
      dropoff: json['dropoffInfo']?['address']?.toString() ?? '',
      distanceKm: distance,
      earnings: (json['totalPrice'] ?? json['shippingCost']?['totalCost'] ?? 0)
          .toDouble(),
    );
  }
}

class ActiveJobModel {
  final String id;
  final String shipmentId;
  final ActiveJobStatus status;
  final String from;
  final String to;
  final String eta;
  final double earnings;

  const ActiveJobModel({
    required this.id,
    required this.shipmentId,
    required this.status,
    required this.from,
    required this.to,
    required this.eta,
    required this.earnings,
  });

  factory ActiveJobModel.fromJson(Map<String, dynamic> json) {
    final shipmentStatus = ShipmentStatusX.fromString(
        json['shipmentStatus']?.toString() ?? '');
    final activeStatus =
        ActiveJobStatusX.fromShipmentStatus(shipmentStatus);

    return ActiveJobModel(
      id: json['_id']?.toString() ?? '',
      shipmentId: json['shipmentId']?.toString() ?? '',
      status: activeStatus,
      from: json['pickupInfo']?['address']?.toString() ?? '',
      to: json['dropoffInfo']?['address']?.toString() ?? '',
      eta: '',
      earnings: (json['totalPrice'] ?? json['shippingCost']?['totalCost'] ?? 0)
          .toDouble(),
    );
  }
}

class CompletedJobModel {
  final String id;
  final String shipmentId;
  final String type;
  final String pickup;
  final String dropoff;
  final double earnings;
  final String completedAt;

  const CompletedJobModel({
    required this.id,
    required this.shipmentId,
    required this.type,
    required this.pickup,
    required this.dropoff,
    required this.earnings,
    required this.completedAt,
  });

  factory CompletedJobModel.fromJson(Map<String, dynamic> json) {
    String completedAt = '';
    try {
      final updatedAt = json['updatedAt']?.toString() ?? '';
      if (updatedAt.isNotEmpty) {
        final dt = DateTime.parse(updatedAt).toLocal();
        completedAt = DateFormat('h:mm a').format(dt);
      }
    } catch (_) {}

    return CompletedJobModel(
      id: json['_id']?.toString() ?? '',
      shipmentId: json['shipmentId']?.toString() ?? '',
      type: json['shipmentInfo']?['type']?.toString() ?? '',
      pickup: json['pickupInfo']?['address']?.toString() ?? '',
      dropoff: json['dropoffInfo']?['address']?.toString() ?? '',
      earnings: (json['totalPrice'] ?? json['shippingCost']?['totalCost'] ?? 0)
          .toDouble(),
      completedAt: completedAt,
    );
  }
}

class JobDetailFullModel {
  final String id;
  final String shipmentId;
  final String title;
  final String status;
  final String eta;
  final String shipmentSummaryId;
  final String type;
  final JobPriority priority;
  final String pickupLocation;
  final String pickupAddress;
  final String pickupContact;
  final String pickupPhone;
  final String pickupDate;
  final String pickupInstructions;
  final double pickupLat;
  final double pickupLng;
  final String dropoffLocation;
  final String dropoffAddress;
  final String dropoffFacility;
  final String dropoffContact;
  final String dropoffPhone;
  final String dropoffInstructions;
  final double dropoffLat;
  final double dropoffLng;
  final String serviceType;
  final String weight;
  final String dimensions;
  final String specialInstructions;
  final List<AttachedFile> attachedFiles;
  final double deliveryFee;
  final double yourPayout;
  final String deliveryNotes;

  const JobDetailFullModel({
    required this.id,
    required this.shipmentId,
    required this.title,
    required this.status,
    required this.eta,
    required this.shipmentSummaryId,
    required this.type,
    required this.priority,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.pickupContact,
    required this.pickupPhone,
    required this.pickupDate,
    required this.pickupInstructions,
    this.pickupLat = 0.0,
    this.pickupLng = 0.0,
    required this.dropoffLocation,
    required this.dropoffAddress,
    required this.dropoffFacility,
    required this.dropoffContact,
    required this.dropoffPhone,
    required this.dropoffInstructions,
    this.dropoffLat = 0.0,
    this.dropoffLng = 0.0,
    required this.serviceType,
    required this.weight,
    required this.dimensions,
    required this.specialInstructions,
    required this.attachedFiles,
    required this.deliveryFee,
    required this.yourPayout,
    this.deliveryNotes = '',
  });

  factory JobDetailFullModel.fromJson(Map<String, dynamic> json) {
    final priorityStr =
        (json['shipmentInfo']?['priority'] ?? 'standard').toString().toLowerCase();

    // Pickup coordinates
    final pickupCoords =
        json['pickupInfo']?['location']?['coordinates'] as List<dynamic>?;
    final pickupLng = (pickupCoords != null && pickupCoords.length >= 2)
        ? (pickupCoords[0] as num).toDouble()
        : 0.0;
    final pickupLat = (pickupCoords != null && pickupCoords.length >= 2)
        ? (pickupCoords[1] as num).toDouble()
        : 0.0;

    // Dropoff coordinates
    final dropoffCoords =
        json['dropoffInfo']?['location']?['coordinates'] as List<dynamic>?;
    final dropoffLng = (dropoffCoords != null && dropoffCoords.length >= 2)
        ? (dropoffCoords[0] as num).toDouble()
        : 0.0;
    final dropoffLat = (dropoffCoords != null && dropoffCoords.length >= 2)
        ? (dropoffCoords[1] as num).toDouble()
        : 0.0;

    // Pickup contact
    final pickupContactRaw = json['pickupInfo']?['contactPerson'];
    String pickupContact = '';
    if (pickupContactRaw is Map) {
      pickupContact = pickupContactRaw['fullName']?.toString() ?? '';
    } else if (pickupContactRaw is String) {
      pickupContact = pickupContactRaw;
    }

    // Dropoff contact
    final dropoffContactRaw = json['dropoffInfo']?['contactPerson'];
    String dropoffContact = '';
    if (dropoffContactRaw is Map) {
      dropoffContact = dropoffContactRaw['fullName']?.toString() ?? '';
    } else if (dropoffContactRaw is String) {
      dropoffContact = dropoffContactRaw;
    }

    // Dropoff facility
    final facilityRaw = json['dropoffInfo']?['facility'];
    String dropoffFacility = '';
    if (facilityRaw is Map) {
      dropoffFacility = facilityRaw['name']?.toString() ?? '';
    } else if (facilityRaw is String) {
      dropoffFacility = facilityRaw;
    }

    // Pickup date
    String pickupDate = '';
    try {
      final raw = json['pickupInfo']?['pickupDate']?.toString() ?? '';
      if (raw.isNotEmpty) {
        final dt = DateTime.parse(raw).toLocal();
        pickupDate = DateFormat('MM/dd/yyyy').format(dt);
      }
    } catch (_) {}

    // Files
    final filesList = json['files'] as List<dynamic>? ?? [];
    final attachedFiles = filesList.asMap().entries.map((e) {
      final url = e.value.toString();
      final name = url.split('/').last;
      return AttachedFile(name: name, size: '', url: url);
    }).toList();

    final totalPrice =
        (json['totalPrice'] ?? json['shippingCost']?['totalCost'] ?? 0)
            .toDouble();

    return JobDetailFullModel(
      id: json['_id']?.toString() ?? '',
      shipmentId: json['shipmentId']?.toString() ?? '',
      title: 'Job Details',
      status: _formatStatus(json['shipmentStatus']?.toString() ?? ''),
      eta: '',
      shipmentSummaryId: json['shipmentId']?.toString() ?? '',
      type: json['shipmentInfo']?['type']?.toString() ?? '',
      priority:
          priorityStr == 'urgent' ? JobPriority.urgent : JobPriority.standard,
      pickupLocation: json['pickupInfo']?['address']?.toString() ?? '',
      pickupAddress: json['pickupInfo']?['address']?.toString() ?? '',
      pickupContact: pickupContact,
      pickupPhone: json['pickupInfo']?['phoneNumber']?.toString() ?? '',
      pickupDate: pickupDate,
      pickupInstructions:
          json['pickupInfo']?['instructions']?.toString() ?? '',
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLocation: json['dropoffInfo']?['address']?.toString() ?? '',
      dropoffAddress: json['dropoffInfo']?['address']?.toString() ?? '',
      dropoffFacility: dropoffFacility,
      dropoffContact: dropoffContact,
      dropoffPhone: json['dropoffInfo']?['phoneNumber']?.toString() ?? '',
      dropoffInstructions:
          json['dropoffInfo']?['instructions']?.toString() ?? '',
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      serviceType:
          json['packageInfo']?['serviceType']?.toString() ?? '',
      weight: json['packageInfo']?['weight']?.toString() ?? '',
      dimensions: json['packageInfo']?['dimensions']?.toString() ?? '',
      specialInstructions:
          json['packageInfo']?['spacialInstructions']?.toString() ?? '',
      attachedFiles: attachedFiles,
      deliveryFee: totalPrice,
      yourPayout: totalPrice,
      deliveryNotes: json['notes']?.toString() ?? '',
    );
  }

  static String _formatStatus(String raw) {
    switch (raw) {
      case 'pending_approval':
        return 'Pending Approval';
      case 'accepted':
        return 'Accepted';
      case 'picked_up':
        return 'Picked Up';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      default:
        return raw;
    }
  }
}

class AttachedFile {
  final String name;
  final String size;
  final String url;

  const AttachedFile({
    required this.name,
    required this.size,
    this.url = '',
  });
}
