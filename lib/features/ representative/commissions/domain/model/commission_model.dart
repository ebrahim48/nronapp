import 'package:intl/intl.dart';

enum CommissionStatus { pending, paid, overdue, approved }

CommissionStatus _statusFromApi(String s) {
  switch (s.toLowerCase()) {
    case 'paid':
      return CommissionStatus.paid;
    case 'overdue':
      return CommissionStatus.overdue;
    case 'approved':
      return CommissionStatus.approved;
    default:
      return CommissionStatus.pending;
  }
}

String _fmt(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw).toLocal());
  } catch (_) {
    return raw;
  }
}

class TrendPoint {
  final String month;
  final double value;

  const TrendPoint({required this.month, required this.value});

  factory TrendPoint.fromJson(Map<String, dynamic> json) => TrendPoint(
        month: json['month']?.toString() ?? '',
        value: (json['amount'] as num?)?.toDouble() ?? 0.0,
      );
}

class CommissionModel {
  final String id;
  final String saleId;
  final String facility;
  final double amount;
  final CommissionStatus status;
  final String dateLabel;
  final String rawCreatedAt;

  const CommissionModel({
    required this.id,
    required this.saleId,
    required this.facility,
    required this.amount,
    required this.status,
    required this.dateLabel,
    this.rawCreatedAt = '',
  });

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    final sale = json['sale'] as Map<String, dynamic>? ?? {};
    final billing = sale['billing'] as Map<String, dynamic>? ?? {};
    final reps = sale['representatives'] as Map<String, dynamic>? ?? {};
    final users = (reps['users'] as List<dynamic>?) ?? [];

    double myCommission = 0;
    if (users.isNotEmpty) {
      final first = users.first as Map<String, dynamic>;
      myCommission = (first['commission'] as num?)?.toDouble() ?? 0;
    }

    final rawCreatedAt = json['createdAt']?.toString() ?? '';

    return CommissionModel(
      id: json['_id']?.toString() ?? '',
      saleId: billing['purchaseOrderNumber']?.toString() ??
          sale['_id']?.toString() ??
          '',
      facility: billing['vendorName']?.toString() ?? '',
      amount: myCommission,
      status: _statusFromApi(json['status']?.toString() ?? ''),
      dateLabel: _fmt(rawCreatedAt),
      rawCreatedAt: rawCreatedAt,
    );
  }
}

class CommissionOverviewModel {
  final double totalSales;
  final double thisMonth;
  final double pendingPayment;
  final double paid;
  final List<TrendPoint> sixMonthTrend;
  final List<CommissionModel> recentCommissions;

  const CommissionOverviewModel({
    this.totalSales = 0,
    this.thisMonth = 0,
    this.pendingPayment = 0,
    this.paid = 0,
    this.sixMonthTrend = const [],
    this.recentCommissions = const [],
  });

  factory CommissionOverviewModel.fromJson(Map<String, dynamic> json) {
    return CommissionOverviewModel(
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0,
      thisMonth: (json['thisMonth'] as num?)?.toDouble() ?? 0,
      pendingPayment: (json['pendingPayment'] as num?)?.toDouble() ?? 0,
      paid: (json['paid'] as num?)?.toDouble() ?? 0,
      sixMonthTrend: (json['sixMonthTrend'] as List<dynamic>?)
              ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentCommissions: (json['recentCommissions'] as List<dynamic>?)
              ?.map((e) =>
                  CommissionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CommissionHistoryGroup {
  final String dateLabel;
  final List<CommissionModel> items;

  const CommissionHistoryGroup({
    required this.dateLabel,
    required this.items,
  });
}

class CommissionDetailModel {
  final String id;
  final String saleId;
  final CommissionStatus status;
  final String loggedDate;
  final String? imageAsset;
  final String productName;
  final String surgeon;
  final String facility;
  final String procedureDate;
  final double saleAmount;
  final double commissionRate;
  final double yourCommission;
  final String quickBooksRef;
  final String quickBooksSyncTime;

  const CommissionDetailModel({
    this.id = '',
    this.saleId = '',
    this.status = CommissionStatus.pending,
    this.loggedDate = '',
    this.imageAsset,
    this.productName = '',
    this.surgeon = '',
    this.facility = '',
    this.procedureDate = '',
    this.saleAmount = 0,
    this.commissionRate = 0,
    this.yourCommission = 0,
    this.quickBooksRef = '',
    this.quickBooksSyncTime = '',
  });

  factory CommissionDetailModel.fromJson(Map<String, dynamic> json) {
    final sale = json['sale'] as Map<String, dynamic>? ?? {};
    final billing = sale['billing'] as Map<String, dynamic>? ?? {};
    final invoice = sale['invoice'] as Map<String, dynamic>? ?? {};
    final reps = sale['representatives'] as Map<String, dynamic>? ?? {};
    final users = (reps['users'] as List<dynamic>?) ?? [];

    double commissionRate = 0;
    double yourCommission = 0;
    if (users.isNotEmpty) {
      final first = users.first as Map<String, dynamic>;
      commissionRate = (first['commissionRate'] as num?)?.toDouble() ?? 0;
      yourCommission = (first['commission'] as num?)?.toDouble() ?? 0;
    }

    return CommissionDetailModel(
      id: json['_id']?.toString() ?? '',
      saleId: billing['purchaseOrderNumber']?.toString() ?? '',
      status: _statusFromApi(json['status']?.toString() ?? ''),
      loggedDate: _fmt(json['createdAt']?.toString()),
      productName: billing['vendorName']?.toString() ?? '',
      surgeon: sale['representativeName']?.toString() ?? '',
      facility: billing['vendorName']?.toString() ?? '',
      procedureDate: _fmt(sale['procedureDate']?.toString()),
      saleAmount: (billing['totalAmount'] as num?)?.toDouble() ?? 0,
      commissionRate: commissionRate,
      yourCommission: yourCommission,
      quickBooksRef: invoice['invoiceNumber']?.toString() ?? '',
      quickBooksSyncTime: _fmt(invoice['invoiceDate']?.toString()),
    );
  }
}
