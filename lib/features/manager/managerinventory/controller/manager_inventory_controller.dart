import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
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
  final totalInventory = 0.obs;
  final totalAvailable = 0.obs;
  final lowStockAlert = 0.obs;
  final isLowStock = false.obs;
  final thisMonthInventory = 0.obs;

  // ── Missing instrument summary ─────────────────────────────────────────────
  final missingTotal = 0.obs;
  final missingCount = 0.obs;

  // ── UI aliases used by the screen ─────────────────────────────────────────
  int get serializedImplants => totalInventory.value;
  int get totalTrays => totalAvailable.value;
  int get bioInventory => thisMonthInventory.value;
  int get pendingTransferCount => missingCount.value;

  // ── Chart / distribution (static UI, kept as-is) ──────────────────────────
  final selectedProductLine = 'All Product Lines'.obs;
  final productLines = ['All Product Lines', 'Orthopedic', 'Cardiac', 'Neuro'];

  final distributionItems = [
    {'name': 'City Hospital',   'percent': 45, 'color': 0xFF00C5DA},
    {'name': 'Mercy Medical',   'percent': 32, 'color': 0xFF00C5DA},
    {'name': 'St. Jude Center', 'percent': 23, 'color': 0xFF3A3A3A},
  ].obs;

  final movementTab = 'WEEKLY'.obs;
  final weeklyData = [0.4, 0.6, 0.5, 1.0, 0.7, 0.9, 0.8].obs;
  final weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

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
      totalInventory.value = (data['totalInventory'] as num?)?.toInt() ?? 0;
      totalAvailable.value = (data['totalAvailableInventory'] as num?)?.toInt() ?? 0;
      thisMonthInventory.value = (data['totalThisMonthInventory'] as num?)?.toInt() ?? 0;
      final lowStock = data['lowStockAlert'] as Map<String, dynamic>? ?? {};
      lowStockAlert.value = (lowStock['productCount'] as num?)?.toInt() ?? 0;
      isLowStock.value = lowStock['isLowStock'] as bool? ?? false;
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
      missingTotal.value = (data['total'] as num?)?.toInt() ?? 0;
      missingCount.value = (data['missing'] as num?)?.toInt() ?? 0;
    } catch (_) {
      // silently fail
    }
  }

  void selectProductLine(String v) => selectedProductLine.value = v;
  void selectMovementTab(String v) => movementTab.value = v;

  Future<void> refresh() => _loadAll();
}
