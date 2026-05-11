import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_inventory_repository.dart';

class ManagerInventoryController extends GetxController {
  final _repo = ManagerInventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Stats ──────────────────────────────────────────────────────────────────
  final isLoadingStats = true.obs;
  final serializedImplants = 0.obs;
  final totalTrays = 0.obs;
  final bioInventory = 0.obs;
  final lowStockAlert = 0.obs;
  final missingInstruments = 0.obs;
  final pendingTransferRequests = 0.obs;

  // ── Inventory Distribution ─────────────────────────────────────────────────
  final distributionTotal = 0.obs;
  // Each item: { 'name': String, 'percent': int, 'color': int }
  final distributionItems = <Map<String, dynamic>>[].obs;

  // ── Recent Movement ────────────────────────────────────────────────────────
  final movementTab = 'WEEKLY'.obs;
  final weeklyData = <double>[].obs;
  final weekDays = <String>[].obs;
  final monthlyData = <double>[].obs;
  final monthLabels = <String>[].obs;

  // ── Distribution dropdown (UI only) ───────────────────────────────────────
  final selectedProductLine = 'All Product Lines'.obs;
  final productLines = ['All Product Lines', 'Orthopedic', 'Cardiac', 'Neuro'];

  // ── Active data for chart (switches with tab) ──────────────────────────────
  List<double> get activeChartData =>
      movementTab.value == 'WEEKLY' ? weeklyData : monthlyData;
  List<String> get activeChartLabels =>
      movementTab.value == 'WEEKLY' ? weekDays : monthLabels;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([_fetchInventoryStats(), _fetchMissingStats()]);
  }

  Future<void> _fetchInventoryStats() async {
    try {
      isLoadingStats.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getInventoryOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};

      // ── Top-level stats ──────────────────────────────────────────────────
      serializedImplants.value =
          (data['serializedImplants'] as num?)?.toInt() ?? 0;
      totalTrays.value = (data['totalTrays'] as num?)?.toInt() ?? 0;
      bioInventory.value = (data['bioInventory'] as num?)?.toInt() ?? 0;
      lowStockAlert.value = (data['lowStockAlert'] as num?)?.toInt() ?? 0;
      missingInstruments.value =
          (data['missingInstruments'] as num?)?.toInt() ?? 0;
      pendingTransferRequests.value =
          (data['pendingTransferRequests'] as num?)?.toInt() ?? 0;

      // ── Inventory Distribution ───────────────────────────────────────────
      final distMap =
          data['inventoryDistribution'] as Map<String, dynamic>? ?? {};
      distributionTotal.value = (distMap['total'] as num?)?.toInt() ?? 0;
      final distItems = distMap['items'] as List? ?? [];
      final colors = [0xFF00C5DA, 0xFF4722FF, 0xFF08AF40, 0xFFEC0101, 0xFFFFB516];
      distributionItems.assignAll(
        distItems.asMap().entries.map((e) {
          final item = e.value as Map<String, dynamic>;
          return {
            'name': item['facility']?.toString() ?? '',
            'percent': (item['percentage'] as num?)?.toInt() ?? 0,
            'color': colors[e.key % colors.length],
          };
        }).toList(),
      );

      // ── Recent Movement ──────────────────────────────────────────────────
      final movMap = data['recentMovement'] as Map<String, dynamic>? ?? {};

      // Weekly
      final weekly = movMap['weekly'] as List? ?? [];
      final maxWeekly = weekly
          .map((e) => (e['count'] as num?)?.toDouble() ?? 0.0)
          .fold<double>(0, (a, b) => a > b ? a : b);
      weeklyData.assignAll(weekly.map((e) {
        final count = (e['count'] as num?)?.toDouble() ?? 0.0;
        return maxWeekly > 0 ? count / maxWeekly : 0.0;
      }).toList());
      weekDays.assignAll(
          weekly.map((e) => e['day']?.toString() ?? '').toList());

      // Monthly
      final monthly = movMap['monthly'] as List? ?? [];
      final maxMonthly = monthly
          .map((e) => (e['count'] as num?)?.toDouble() ?? 0.0)
          .fold<double>(0, (a, b) => a > b ? a : b);
      monthlyData.assignAll(monthly.map((e) {
        final count = (e['count'] as num?)?.toDouble() ?? 0.0;
        return maxMonthly > 0 ? count / maxMonthly : 0.0;
      }).toList());
      monthLabels.assignAll(
          monthly.map((e) => e['month']?.toString() ?? '').toList());
    } catch (_) {
      // silently fail
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> _fetchMissingStats() async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getMissingInstrumentOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      missingInstruments.value = (data['total'] as num?)?.toInt() ?? 0;
    } catch (_) {
      // silently fail
    }
  }

  void selectProductLine(String v) => selectedProductLine.value = v;

  void selectMovementTab(String v) => movementTab.value = v;

  Future<void> refresh() => _loadAll();
}
