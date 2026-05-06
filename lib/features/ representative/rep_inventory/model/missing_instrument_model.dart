enum MissingInstrumentStatus { missing, damaged, resolved }

class MissingInstrumentModel {
  final String id;
  final String trayId;
  final String facility;
  final String reportedBy;
  final String reporterAvatar; // asset path
  final DateTime date;
  final MissingInstrumentStatus status;

  const MissingInstrumentModel({
    required this.id,
    required this.trayId,
    required this.facility,
    required this.reportedBy,
    required this.reporterAvatar,
    required this.date,
    required this.status,
  });

  String get statusLabel {
    switch (status) {
      case MissingInstrumentStatus.missing:
        return 'Missing';
      case MissingInstrumentStatus.damaged:
        return 'Damaged';
      case MissingInstrumentStatus.resolved:
        return 'Resolved';
    }
  }
}

class MissingInstrumentDetailModel {
  final String trayId;
  final String facility;
  final String location;
  final String instrumentName;
  final String notes;
  final String evidenceImagePath;
  final DateTime capturedAt;
  final bool vendorNotified;
  final String vendorNotifiedMessage;

  const MissingInstrumentDetailModel({
    required this.trayId,
    required this.facility,
    required this.location,
    required this.instrumentName,
    required this.notes,
    required this.evidenceImagePath,
    required this.capturedAt,
    required this.vendorNotified,
    required this.vendorNotifiedMessage,
  });
}