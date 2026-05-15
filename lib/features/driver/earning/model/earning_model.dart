// ── Entry (history row) ───────────────────────────────────────────────────────

class EarningEntryModel {
  final String id;
  final String shipmentId;
  final String date;
  final double amount;
  final String status; // 'paid' | 'pending'

  const EarningEntryModel({
    required this.id,
    required this.shipmentId,
    required this.date,
    required this.amount,
    required this.status,
  });

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  /// From summary.history array
  factory EarningEntryModel.fromSummaryJson(Map<String, dynamic> e) {
    return EarningEntryModel(
      id: e['id']?.toString() ?? '',
      shipmentId: e['shipmentId']?.toString() ?? e['id']?.toString() ?? '',
      date: _formatDate(e['date']?.toString()),
      amount: (e['amount'] as num?)?.toDouble() ?? 0.0,
      status: e['status']?.toString() ?? 'pending',
    );
  }

  /// From history endpoint results array
  factory EarningEntryModel.fromHistoryJson(Map<String, dynamic> e) {
    final shipmentMap = e['shipment'] is Map
        ? e['shipment'] as Map<String, dynamic>
        : <String, dynamic>{};
    final shipmentId = shipmentMap['shipmentId']?.toString() ??
        e['_id']?.toString() ?? '';

    return EarningEntryModel(
      id: e['_id']?.toString() ?? '',
      shipmentId: shipmentId,
      date: _formatDate(e['createdAt']?.toString()),
      amount: (e['amount'] as num?)?.toDouble() ?? 0.0,
      status: e['status']?.toString() ?? 'pending',
    );
  }
}

// ── Weekly bar ────────────────────────────────────────────────────────────────

class WeeklyBarModel {
  final String day;
  final double value; // normalized 0.0–1.0

  const WeeklyBarModel({required this.day, required this.value});
}

// ── Summary ───────────────────────────────────────────────────────────────────

class EarningsSummaryModel {
  final double totalBalance;
  final int totalBalanceDeliveries;
  final double todayEarnings;
  final int todayDeliveries;
  final double thisWeekEarnings;
  final int thisWeekDeliveries;
  final double pendingEarnings;
  final int pendingDeliveries;
  final double totalPaid;
  final int totalPaidDeliveries;
  final List<EarningEntryModel> history;
  final List<WeeklyBarModel> weeklyBars;

  const EarningsSummaryModel({
    required this.totalBalance,
    required this.totalBalanceDeliveries,
    required this.todayEarnings,
    required this.todayDeliveries,
    required this.thisWeekEarnings,
    required this.thisWeekDeliveries,
    required this.pendingEarnings,
    required this.pendingDeliveries,
    required this.totalPaid,
    required this.totalPaidDeliveries,
    required this.history,
    required this.weeklyBars,
  });

  double get pendingPayoutAmount => pendingEarnings;

  static const EarningsSummaryModel empty = EarningsSummaryModel(
    totalBalance: 0,
    totalBalanceDeliveries: 0,
    todayEarnings: 0,
    todayDeliveries: 0,
    thisWeekEarnings: 0,
    thisWeekDeliveries: 0,
    pendingEarnings: 0,
    pendingDeliveries: 0,
    totalPaid: 0,
    totalPaidDeliveries: 0,
    history: [],
    weeklyBars: [],
  );

  factory EarningsSummaryModel.fromJson(Map<String, dynamic> data) {
    final totalMap = data['totalBalance'] is Map
        ? data['totalBalance'] as Map<String, dynamic>
        : <String, dynamic>{};
    final todayMap = data['today'] is Map
        ? data['today'] as Map<String, dynamic>
        : <String, dynamic>{};
    final weekMap = data['thisWeek'] is Map
        ? data['thisWeek'] as Map<String, dynamic>
        : <String, dynamic>{};
    final pendingMap = data['pending'] is Map
        ? data['pending'] as Map<String, dynamic>
        : <String, dynamic>{};
    final paidMap = data['totalPaid'] is Map
        ? data['totalPaid'] as Map<String, dynamic>
        : <String, dynamic>{};

    // Weekly bars — normalize against max amount
    final rawBars = data['weeklyOverview'] is List
        ? data['weeklyOverview'] as List
        : <dynamic>[];
    double maxAmount = 0;
    for (final b in rawBars) {
      final amt = (b is Map ? (b['amount'] as num?)?.toDouble() : null) ?? 0.0;
      if (amt > maxAmount) maxAmount = amt;
    }
    final weeklyBars = rawBars.map((b) {
      final bMap = b is Map ? b as Map<String, dynamic> : <String, dynamic>{};
      final amt = (bMap['amount'] as num?)?.toDouble() ?? 0.0;
      return WeeklyBarModel(
        day: bMap['day']?.toString() ?? '',
        value: maxAmount > 0 ? (amt / maxAmount).clamp(0.05, 1.0) : 0.05,
      );
    }).toList();

    // History from summary
    final rawHistory = data['history'] is List
        ? data['history'] as List
        : <dynamic>[];
    final history = rawHistory
        .map((e) => EarningEntryModel.fromSummaryJson(
            e as Map<String, dynamic>))
        .toList();

    return EarningsSummaryModel(
      totalBalance: (totalMap['amount'] as num?)?.toDouble() ?? 0.0,
      totalBalanceDeliveries: (totalMap['deliveries'] as num?)?.toInt() ?? 0,
      todayEarnings: (todayMap['amount'] as num?)?.toDouble() ?? 0.0,
      todayDeliveries: (todayMap['deliveries'] as num?)?.toInt() ?? 0,
      thisWeekEarnings: (weekMap['amount'] as num?)?.toDouble() ?? 0.0,
      thisWeekDeliveries: (weekMap['deliveries'] as num?)?.toInt() ?? 0,
      pendingEarnings: (pendingMap['amount'] as num?)?.toDouble() ?? 0.0,
      pendingDeliveries: (pendingMap['deliveries'] as num?)?.toInt() ?? 0,
      totalPaid: (paidMap['amount'] as num?)?.toDouble() ?? 0.0,
      totalPaidDeliveries: (paidMap['deliveries'] as num?)?.toInt() ?? 0,
      history: history,
      weeklyBars: weeklyBars,
    );
  }
}
