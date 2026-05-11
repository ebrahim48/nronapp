// ── Stat card ─────────────────────────────────────────────────────────────────

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

// ── Job request (new job / active / completed) ────────────────────────────────

class JobRequestModel {
  final String id;
  final String shipmentId;
  final bool isUrgent;
  final String timeAway;
  final String pickup;
  final String dropoff;
  final double distanceKm;
  final double earnings;
  final String shipmentStatus;
  final String serviceType;
  final String weight;
  final String dimensions;
  final String specialInstructions;
  final String pickupAddress;
  final String pickupPhone;
  final String dropoffAddress;
  final String dropoffPhone;

  const JobRequestModel({
    required this.id,
    required this.shipmentId,
    required this.isUrgent,
    required this.timeAway,
    required this.pickup,
    required this.dropoff,
    required this.distanceKm,
    required this.earnings,
    this.shipmentStatus = 'pending',
    this.serviceType = '',
    this.weight = '',
    this.dimensions = '',
    this.specialInstructions = '',
    this.pickupAddress = '',
    this.pickupPhone = '',
    this.dropoffAddress = '',
    this.dropoffPhone = '',
  });

  factory JobRequestModel.fromJson(Map<String, dynamic> e) {
    final pickupMap = e['pickupInfo'] is Map
        ? e['pickupInfo'] as Map<String, dynamic>
        : <String, dynamic>{};
    final dropoffMap = e['dropoffInfo'] is Map
        ? e['dropoffInfo'] as Map<String, dynamic>
        : <String, dynamic>{};
    final packageMap = e['packageInfo'] is Map
        ? e['packageInfo'] as Map<String, dynamic>
        : <String, dynamic>{};
    final costMap = e['shippingCost'] is Map
        ? e['shippingCost'] as Map<String, dynamic>
        : <String, dynamic>{};
    final shipInfoMap = e['shipmentInfo'] is Map
        ? e['shipmentInfo'] as Map<String, dynamic>
        : <String, dynamic>{};

    final priority = shipInfoMap['priority']?.toString() ??
        costMap['priority']?.toString() ?? '';
    final isUrgent = priority.toLowerCase() == 'urgent';
    final distance = e['totalDistance']?.toString() ??
        costMap['distance']?.toString() ?? '';
    final distanceKm = double.tryParse(
            distance.replaceAll(RegExp(r'[^0-9.]'), '')) ??
        0.0;

    return JobRequestModel(
      id: e['_id']?.toString() ?? '',
      shipmentId: e['shipmentId']?.toString() ?? '',
      isUrgent: isUrgent,
      timeAway: distance.isNotEmpty ? distance : '—',
      pickup: pickupMap['address']?.toString() ?? '—',
      dropoff: dropoffMap['address']?.toString() ?? '—',
      distanceKm: distanceKm,
      earnings: (e['totalPrice'] as num?)?.toDouble() ??
          (costMap['totalCost'] as num?)?.toDouble() ?? 0.0,
      shipmentStatus: e['shipmentStatus']?.toString() ?? e['status']?.toString() ?? '',
      serviceType: packageMap['serviceType']?.toString() ??
          costMap['type']?.toString() ?? '',
      weight: packageMap['weight']?.toString() ?? '',
      dimensions: packageMap['dimensions']?.toString() ?? '',
      specialInstructions: packageMap['spacialInstructions']?.toString() ?? '',
      pickupAddress: pickupMap['address']?.toString() ?? '',
      pickupPhone: pickupMap['phoneNumber']?.toString() ?? '',
      dropoffAddress: dropoffMap['address']?.toString() ?? '',
      dropoffPhone: dropoffMap['phoneNumber']?.toString() ?? '',
    );
  }
}

// ── Driver home data ──────────────────────────────────────────────────────────

class DriverHomeData {
  final int newJobs;
  final int active;
  final int completed;
  final double todayEarnings;
  final List<JobRequestModel> newJobRequests;
  final List<JobRequestModel> activeJobs;
  final List<JobRequestModel> completedToday;

  const DriverHomeData({
    required this.newJobs,
    required this.active,
    required this.completed,
    required this.todayEarnings,
    required this.newJobRequests,
    required this.activeJobs,
    required this.completedToday,
  });

  static const DriverHomeData empty = DriverHomeData(
    newJobs: 0,
    active: 0,
    completed: 0,
    todayEarnings: 0,
    newJobRequests: [],
    activeJobs: [],
    completedToday: [],
  );

  factory DriverHomeData.fromJson(Map<String, dynamic> data) {
    final statsMap = data['stats'] is Map
        ? data['stats'] as Map<String, dynamic>
        : <String, dynamic>{};

    List<JobRequestModel> _parseList(dynamic raw) {
      if (raw is! List) return [];
      return raw
          .map((e) => JobRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return DriverHomeData(
      newJobs: (statsMap['newJobs'] as num?)?.toInt() ?? 0,
      active: (statsMap['active'] as num?)?.toInt() ?? 0,
      completed: (statsMap['completed'] as num?)?.toInt() ?? 0,
      todayEarnings: (statsMap['todayEarnings'] as num?)?.toDouble() ?? 0.0,
      newJobRequests: _parseList(data['newJobRequests']),
      activeJobs: _parseList(data['activeJobs']),
      completedToday: _parseList(data['completedToday']),
    );
  }
}

// ── Job detail (for detail screen) ───────────────────────────────────────────

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

  factory JobDetailModel.fromJobRequest(JobRequestModel job) {
    return JobDetailModel(
      shipmentId: job.shipmentId,
      isUrgent: job.isUrgent,
      earnings: job.earnings,
      distanceKm: job.distanceKm,
      pickupName: job.pickup,
      pickupAddress: job.pickupAddress,
      pickupContact: '',
      pickupPhone: job.pickupPhone,
      dropoffName: job.dropoff,
      dropoffAddress: job.dropoffAddress,
      dropoffContact: '',
      dropoffPhone: job.dropoffPhone,
      serviceType: job.serviceType,
      weight: job.weight,
      dimensions: job.dimensions,
      specialInstructions: job.specialInstructions,
    );
  }
}
