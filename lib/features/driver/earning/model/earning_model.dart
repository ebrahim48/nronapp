class EarningEntryModel {
  final String shipmentId;
  final String date;
  final double amount;
  final String status; // 'paid' | 'pending'

  const EarningEntryModel({
    required this.shipmentId,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class WeeklyBarModel {
  final String day;
  final double value;

  const WeeklyBarModel({required this.day, required this.value});
}

class EarningsSummaryModel {
  final double totalBalance;
  final double percentChangeFromLastWeek;
  final double todayEarnings;
  final int todayDeliveries;
  final double thisWeekEarnings;
  final int thisWeekDeliveries;
  final double pendingEarnings;
  final int pendingDeliveries;
  final double totalPaid;
  final int totalDeliveries;
  final double pendingPayoutAmount;
  final List<EarningEntryModel> history;
  final List<WeeklyBarModel> weeklyBars;

  const EarningsSummaryModel({
    required this.totalBalance,
    required this.percentChangeFromLastWeek,
    required this.todayEarnings,
    required this.todayDeliveries,
    required this.thisWeekEarnings,
    required this.thisWeekDeliveries,
    required this.pendingEarnings,
    required this.pendingDeliveries,
    required this.totalPaid,
    required this.totalDeliveries,
    required this.pendingPayoutAmount,
    required this.history,
    required this.weeklyBars,
  });
}