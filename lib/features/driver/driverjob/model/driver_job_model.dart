enum DriverJobTab { newJobs, active, completed }

enum JobPriority { urgent, standard }

enum ActiveJobStatus { pickedUp, inTransit }

enum CompletedPeriod { today, thisWeek, thisMonth }

class NewJobModel {
  final String shipmentId;
  final JobPriority priority;
  final String timeAway;
  final String pickup;
  final String dropoff;
  final double distanceKm;
  final double earnings;

  const NewJobModel({
    required this.shipmentId,
    required this.priority,
    required this.timeAway,
    required this.pickup,
    required this.dropoff,
    required this.distanceKm,
    required this.earnings,
  });
}

class ActiveJobModel {
  final String shipmentId;
  final ActiveJobStatus status;
  final String from;
  final String to;
  final String eta;
  final double earnings;

  const ActiveJobModel({
    required this.shipmentId,
    required this.status,
    required this.from,
    required this.to,
    required this.eta,
    required this.earnings,
  });
}

class CompletedJobModel {
  final String shipmentId;
  final String type;
  final String pickup;
  final String dropoff;
  final double earnings;
  final String completedAt;

  const CompletedJobModel({
    required this.shipmentId,
    required this.type,
    required this.pickup,
    required this.dropoff,
    required this.earnings,
    required this.completedAt,
  });
}

class JobDetailFullModel {
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
  final String dropoffLocation;
  final String dropoffAddress;
  final String dropoffFacility;
  final String dropoffContact;
  final String dropoffPhone;
  final String dropoffInstructions;
  final String serviceType;
  final String weight;
  final String dimensions;
  final String specialInstructions;
  final List<AttachedFile> attachedFiles;
  final double deliveryFee;
  final double yourPayout;

  const JobDetailFullModel({
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
    required this.dropoffLocation,
    required this.dropoffAddress,
    required this.dropoffFacility,
    required this.dropoffContact,
    required this.dropoffPhone,
    required this.dropoffInstructions,
    required this.serviceType,
    required this.weight,
    required this.dimensions,
    required this.specialInstructions,
    required this.attachedFiles,
    required this.deliveryFee,
    required this.yourPayout,
  });
}

class AttachedFile {
  final String name;
  final String size;

  const AttachedFile({required this.name, required this.size});
}