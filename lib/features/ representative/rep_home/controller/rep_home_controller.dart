import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/model/rep_home_model.dart';
import '../data/repositories/rep_home_repository.dart';

class RepHomeController extends GetxController {
  final _repo = RepHomeRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;

  // Stats
  final totalSales = 0.obs;
  final activePOs = 0.obs;
  final totalInventory = 0.obs;
  final expenses = 0.obs;

  // Chart
  final chartData = <String, List<double>>{}.obs;

  // Recent Activity
  final activities = <RecentActivity>[].obs;

  // Year dropdown (UI only — API doesn't filter by year yet)
  final selectedYear = '2025'.obs;
  final List<String> years = ['2023', '2024', '2025'];

  @override
  void onInit() {
    super.onInit();
    fetchOverview();
  }

  Future<void> fetchOverview() async {
    isLoading.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getOverview(token);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;

        final stats = RepHomeStats.fromJson(
            data['stats'] as Map<String, dynamic>? ?? {});
        totalSales.value = stats.totalSales;
        activePOs.value = stats.activePOs;
        totalInventory.value = stats.totalInventory;
        expenses.value = stats.expenses;

        final trendsRaw = data['monthlyTrend'] as List<dynamic>? ?? [];
        final trends = trendsRaw
            .map((e) => MonthlyTrend.fromJson(e as Map<String, dynamic>))
            .toList();
        final newChart = <String, List<double>>{};
        for (final t in trends) {
          newChart[t.month] = [t.sales, t.expenses, t.commission];
        }
        chartData.assignAll(newChart);

        final activityRaw = data['recentActivity'] as List<dynamic>? ?? [];
        activities.assignAll(activityRaw
            .map((e) => RecentActivity.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void changeYear(String year) {
    selectedYear.value = year;
  }
}
