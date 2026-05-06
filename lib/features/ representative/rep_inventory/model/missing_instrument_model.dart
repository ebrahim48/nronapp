enum MissingInstrumentStatus { missing, damaged, resolved, other }

class MissingInstrumentModel {
  final String id;
  final String trayId;
  final String facility;
  final String instrumentName;
  final String reportedBy;
  final String reporterAvatarUrl;
  final DateTime date;
  final MissingInstrumentStatus status;

  const MissingInstrumentModel({
    required this.id,
    required this.trayId,
    required this.facility,
    required this.instrumentName,
    required this.reportedBy,
    required this.reporterAvatarUrl,
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
      case MissingInstrumentStatus.other:
        return 'Other';
    }
  }
}
