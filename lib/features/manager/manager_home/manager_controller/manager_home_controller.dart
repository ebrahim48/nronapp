import 'package:get/get.dart';

import '../model/manager_home_model.dart';

class ManagerHomeController extends GetxController {
  final userName = 'Al Jamil'.obs;
  final selectedPeriod = 'Weekly'.obs;

  final periods = ['Weekly', 'Monthly', 'Yearly'];

  final stats = <ManagerStatModel>[
    ManagerStatModel(
      iconPath: 'assets/icons/treamrevenue.svg',
      label: "Team's Revenue",
      value: '\$12,450',
    ),
    ManagerStatModel(
      iconPath: 'assets/icons/activereps.svg',
      label: 'Active Reps',
      value: '12/15 Online',
    ),
    ManagerStatModel(
      iconPath: 'assets/icons/inventoryassigned.svg',
      label: 'Inventory Assigned',
      value: '240 Items',
    ),
    ManagerStatModel(
      iconPath: 'assets/icons/expenses.svg',
      label: 'Expenses',
      value: '\$1,450',
    ),
  ];


  final selectedYear = '2025'.obs;
  final years = ['2023', '2024', '2025'];

  final chartData = <String, List<double>>{
    'Jan': [40, 20, 10],
    'Feb': [70, 30, 15],
    'Mar': [55, 45, 25],
    'Apr': [60, 25, 40],
    'May': [85, 50, 30],
    'Jun': [65, 40, 100],
  }.obs;

  void changeYear(String year) {
    selectedYear.value = year;
    // Update chart data based on year if needed
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
  }


  final teamActivity = <TeamActivityModel>[
    TeamActivityModel(
      memberName: 'Mike Ross',
      action: 'added inventory',
      timeAgo: '12 minutes ago',
      location: 'Main Warehouse',
      avatarAsset: 'assets/images/profile.jpg',
    ),
    TeamActivityModel(
      memberName: 'Mike Ross',
      action: 'added inventory',
      timeAgo: '12 minutes ago',
      location: 'Main Warehouse',
      avatarAsset: 'assets/images/profile.jpg',
    ),
    TeamActivityModel(
      memberName: 'Mike Ross',
      action: 'added inventory',
      timeAgo: '12 minutes ago',
      location: 'Main Warehouse',
      avatarAsset: 'assets/images/profile.jpg',
    ),
  ].obs;


  final pendingPOs = 8.obs;
  final pendingExpenses = 5.obs;


  final lowStockCount = 3.obs;
}