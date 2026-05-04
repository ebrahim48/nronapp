import 'package:intl/intl.dart';

enum POStatus { all, open, lost, complete }

class PurchaseOrderModel {
  final String id;
  final String status;
  final String orderType;
  final String thumbnail;
  final String patientId;
  final String surgeryId;
  final String facilityId;
  final String procedureDate;
  final String purchaseOrderNumber;
  final double totalAmount;
  final String notes;
  final List<String> documents;
  final String createdAt;

  const PurchaseOrderModel({
    required this.id,
    required this.status,
    required this.orderType,
    this.thumbnail = '',
    this.patientId = '',
    this.surgeryId = '',
    this.facilityId = '',
    this.procedureDate = '',
    this.purchaseOrderNumber = '',
    this.totalAmount = 0,
    this.notes = '',
    this.documents = const [],
    this.createdAt = '',
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    final surgery = json['surgery'];
    final facility = json['facility'];

    return PurchaseOrderModel(
      id: json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      orderType: json['orderType']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      surgeryId: surgery is Map ? surgery['_id']?.toString() ?? '' : surgery?.toString() ?? '',
      facilityId: facility is Map ? facility['_id']?.toString() ?? '' : facility?.toString() ?? '',
      procedureDate: json['procedureDate']?.toString() ?? '',
      purchaseOrderNumber: json['purchaseOrderNumber']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      notes: json['notes']?.toString() ?? '',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  POStatus get poStatus {
    switch (status.toLowerCase()) {
      case 'open':
        return POStatus.open;
      case 'lost':
        return POStatus.lost;
      case 'complete':
        return POStatus.complete;
      default:
        return POStatus.open;
    }
  }

  String get formattedDate {
    if (procedureDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(procedureDate).toLocal();
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return procedureDate;
    }
  }

  String get orderTypeLabel =>
      orderType == 'bulkBioOrder' ? 'Bulk BIO' : 'Standard PO';
}

// ── Dropdown helpers (used by create/edit forms) ──────────────────────────────

class PoDropdownItem {
  final String id;
  final String name;
  const PoDropdownItem({required this.id, required this.name});
}
