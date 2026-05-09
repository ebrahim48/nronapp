import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_home_repository.dart';
import '../model/manager_home_model.dart';

class ManagerHomeController extends GetxController {
  final _repo = ManagerHomeRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Loading ───────────────────────────────────────────────────────────────
  final isLoading = true.obs;

  // ── Stats ─────────────────────────────────────────────────────────────────
  final teamRevenue = 0.0.obs;
  final activeRepsOnline = 0.obs;
  final activeRepsTotal = 0.obs;
  final inventoryAssigned = 0.obs;
  final expenses = 0.0.obs;

  List<ManagerStatModel> get stats => [
        ManagerStatModel(
          iconPath: 'assets/icons/treamrevenue.svg',
          label: "Team's Revenue",
          value: '\$${teamRevenue.value.toStringAsFixed(0)}',
        ),
        ManagerStatModel(
          iconPath: 'assets/icons/activereps.svg',
          label: 'Active Reps',
          value: '${activeRepsOnline.value}/${activeRepsTotal.value} Online',
        ),
        ManagerStatModel(
          iconPath: 'assets/icons/inventoryassigned.svg',
          label: 'Inventory Assigned',
          value: '${inventoryAssigned.value} Items',
        ),
        ManagerStatModel(
          iconPath: 'assets/icons/expenses.svg',
          label: 'Expenses',
          value: '\$${expenses.value.toStringAsFixed(0)}',
        ),
      ];

  // ── Chart data ────────────────────────────────────────────────────────────
  final trendPoints = <MonthlyTrendPoint>[].obs;

  /// Converts trend points to the map format used by OrgPerformanceChart
  Map<String, List<double>> get chartData {
    final map = <String, List<double>>{};
    for (final p in trendPoints) {
      // Normalize to 0-100 scale for chart display
      final maxVal = [p.sales, p.expenses, p.commission]
          .reduce((a, b) => a > b ? a : b);
      final scale = maxVal > 0 ? 100.0 / maxVal : 1.0;
      map[p.month] = [
        (p.sales * scale).clamp(0, 100),
        (p.expenses * scale).clamp(0, 100),
        (p.commission * scale).clamp(0, 100),
      ];
    }
    return map;
  }

  // ── Team activity ─────────────────────────────────────────────────────────
  final teamActivity = <TeamActivityModel>[].obs;

  // ── Pending counts ────────────────────────────────────────────────────────
  final pendingPOs = 0.obs;
  final pendingExpenses = 0.obs;
  final lowStockCount = 0.obs;

  // ── UI state ──────────────────────────────────────────────────────────────
  final userName = ''.obs;
  final selectedPeriod = 'Weekly'.obs;
  final periods = ['Weekly', 'Monthly', 'Yearly'];
  final selectedYear = '2025'.obs;
  final years = ['2023', '2024', '2025'];

  @override
  void onInit() {
    super.onInit();
    fetchOverview();
  }

  Future<void> fetchOverview() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};

      // Stats
      final statsMap = data['stats'] as Map<String, dynamic>? ?? {};
      teamRevenue.value =
          (statsMap['teamRevenue'] as num?)?.toDouble() ?? 0;
      final activeRepsMap =
          statsMap['activeReps'] is Map
              ? statsMap['activeReps'] as Map<String, dynamic>
              : <String, dynamic>{};
      activeRepsOnline.value =
          (activeRepsMap['online'] as num?)?.toInt() ?? 0;
      activeRepsTotal.value =
          (activeRepsMap['total'] as num?)?.toInt() ?? 0;
      inventoryAssigned.value =
          (statsMap['inventoryAssigned'] as num?)?.toInt() ?? 0;
      expenses.value =
          (statsMap['expenses'] as num?)?.toDouble() ?? 0;

      // Monthly trend
      final trend = data['monthlyTrend'];
      if (trend is List) {
        trendPoints.assignAll(
          trend.map((e) =>
              MonthlyTrendPoint.fromJson(e as Map<String, dynamic>)),
        );
      }

      // Recent activity
      final activity = data['recentActivity'];
      if (activity is List) {
        teamActivity.assignAll(
          activity.map((e) =>
              TeamActivityModel.fromJson(e as Map<String, dynamic>)),
        );
      }
    } catch (_) {
      // silently fail — keep zeros
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(String period) => selectedPeriod.value = period;
  void changeYear(String year) => selectedYear.value = year;
}
