import 'package:flutter/material.dart';

import '../model/earning_model.dart';

class EarningsController extends ChangeNotifier {
  bool isLoading = false;
  String selectedFilter = 'All'; // 'All' | 'paid' | 'pending'
  final List<String> filters = ['All', 'paid', 'pending'];

  final EarningsSummaryModel summary = EarningsSummaryModel(
    totalBalance: 845,
    percentChangeFromLastWeek: 12,
    todayEarnings: 125,
    todayDeliveries: 8,
    thisWeekEarnings: 845,
    thisWeekDeliveries: 52,
    pendingEarnings: 245,
    pendingDeliveries: 15,
    totalPaid: 12450,
    totalDeliveries: 785,
    pendingPayoutAmount: 245,
    history: const [
      EarningEntryModel(shipmentId: 'SH-1843', date: 'Apr 15, 2026', amount: 30, status: 'paid'),
      EarningEntryModel(shipmentId: 'SH-1842', date: 'Apr 15, 2026', amount: 25, status: 'paid'),
      EarningEntryModel(shipmentId: 'SH-1841', date: 'Apr 15, 2026', amount: 20, status: 'paid'),
      EarningEntryModel(shipmentId: 'SH-1840', date: 'Apr 14, 2026', amount: 35, status: 'paid'),
      EarningEntryModel(shipmentId: 'SH-1839', date: 'Apr 14, 2026', amount: 28, status: 'paid'),
      EarningEntryModel(shipmentId: 'SH-1838', date: 'Apr 14, 2026', amount: 22, status: 'paid'),
      EarningEntryModel(shipmentId: 'SH-1837', date: 'Apr 13, 2026', amount: 32, status: 'paid'),
      EarningEntryModel(shipmentId: 'SH-1836', date: 'Apr 13, 2026', amount: 26, status: 'pending'),
      EarningEntryModel(shipmentId: 'SH-1835', date: 'Apr 13, 2026', amount: 29, status: 'pending'),
    ],
    weeklyBars: const [
      WeeklyBarModel(day: 'Mon', value: 0.4),
      WeeklyBarModel(day: 'Tue', value: 0.65),
      WeeklyBarModel(day: 'Wed', value: 0.5),
      WeeklyBarModel(day: 'Thu', value: 0.85),
      WeeklyBarModel(day: 'Fri', value: 0.7),
      WeeklyBarModel(day: 'Sat', value: 0.3),
      WeeklyBarModel(day: 'Sun', value: 0.55),
    ],
  );

  List<EarningEntryModel> get filteredHistory {
    if (selectedFilter == 'All') return summary.history;
    return summary.history
        .where((e) => e.status == selectedFilter)
        .toList();
  }

  // Only the 3 most recent for the dashboard preview
  List<EarningEntryModel> get recentHistory =>
      summary.history.take(3).toList();

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  Future<void> requestPayout() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
  }
}