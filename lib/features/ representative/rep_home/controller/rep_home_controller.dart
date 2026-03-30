import 'package:get/get.dart';

class RepHomeController extends GetxController {
  // Selected year for chart
  final selectedYear = '2025'.obs;

  final List<String> years = ['2023', '2024', '2025'];

  // Stat cards data
  final totalSales = '\$12,450'.obs;
  final activePOs = '18'.obs;
  final achievement = '85%'.obs;
  final expenses = '\$1,450'.obs;

  // Chart data — Sales, Expenses, Commission per month
  final chartData = <String, List<double>>{
    'Jan': [45, 20, 10],
    'Feb': [80, 35, 25],
    'Mar': [60, 25, 18],
    'Apr': [75, 30, 85],
    'May': [50, 60, 40],
    'Jun': [70, 55, 95],
  }.obs;

  // Recent activities
  final activities = <Map<String, dynamic>>[
    {
      'title': 'PO #40234 Approved',
      'subtitle': 'Approved by Regional Manager',
      'time': '2h ago',
      'status': 'Success',
      'iconType': 'check',
    },
    {
      'title': 'PO #40234 Approved',
      'subtitle': 'Approved by Regional Manager',
      'time': '2h ago',
      'status': 'Pending',
      'iconType': 'chat',
    },
  ].obs;

  void changeYear(String year) {
    selectedYear.value = year;
  }
}