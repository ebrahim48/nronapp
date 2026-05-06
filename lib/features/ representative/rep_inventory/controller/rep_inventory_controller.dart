import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class InventoryController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Stats ──────────────────────────────────────────────────────────────────
  final isLoadingStats = true.obs;
  final serializedImplants = 0.obs;
  final totalTrays = 0.obs;
  final bioInventory = 0.obs;
  final lowStockAlert = 0.obs;

  // ── Tabs ───────────────────────────────────────────────────────────────────
  final activeTab = 0.obs;
  final tabs = ['Implants', 'Trays', 'Bio'];

  // ── List ───────────────────────────────────────────────────────────────────
  final isLoadingList = true.obs;
  final inventoryItems = <Map<String, dynamic>>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([_fetchStats(), _fetchList()]);
  }

  Future<void> _fetchStats() async {
    try {
      isLoadingStats.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      serializedImplants.value = (data['serializedImplants'] as num?)?.toInt() ?? 0;
      totalTrays.value = (data['totalTrays'] as num?)?.toInt() ?? 0;
      bioInventory.value = (data['bioInventory'] as num?)?.toInt() ?? 0;
      lowStockAlert.value = (data['lowStockAlert'] as num?)?.toInt() ?? 0;
    } catch (_) {
      // silently fail — stats stay 0
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> _fetchList() async {
    try {
      isLoadingList.value = true;
      inventoryItems.clear();
      final token = await PrefsHelper.getString('auth_token');
      final tab = tabs[activeTab.value];
      if (tab == 'Implants') {
        final res = await _repo.getImplants(token);
        final list = _asList(res['data']);
        inventoryItems.assignAll(list.map((e) => _mapImplant(e)));
      } else if (tab == 'Trays') {
        final res = await _repo.getTrays(token);
        final list = _asList(res['data']);
        inventoryItems.assignAll(list.map((e) => _mapTray(e)));
      } else {
        final res = await _repo.getBio(token);
        final list = _asList(res['data']);
        inventoryItems.assignAll(list.map((e) => _mapBio(e)));
      }
    } catch (e) {
      ToastMessageHelper.showErrorMessage('Failed to load inventory');
    } finally {
      isLoadingList.value = false;
    }
  }

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['results', 'items', 'list', 'data', 'docs']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }

  Map<String, dynamic> _mapImplant(Map<String, dynamic> e) {
    final facilityMap = e['facility'] is Map ? e['facility'] as Map<String, dynamic> : <String, dynamic>{};
    final vendorMap = e['vendor'] is Map ? e['vendor'] as Map<String, dynamic> : <String, dynamic>{};
    return {
      'id': e['_id']?.toString() ?? '',
      'name': e['systemType']?.toString() ?? '',
      'serial': e['serialNumber']?.toString() ?? '',
      'lot': e['lotNumber']?.toString() ?? '',
      'material': e['material']?.toString() ?? '',
      'systemType': e['systemType']?.toString() ?? '',
      'vendor': vendorMap['vendorName']?.toString() ?? e['vendor']?.toString() ?? '',
      'status': _normalizeStatus(e['productStatus']?.toString() ?? e['status']?.toString()),
      'location': facilityMap['address']?.toString() ?? facilityMap['facilityName']?.toString() ?? facilityMap['name']?.toString() ?? '',
      'email': e['recipientEmail']?.toString() ?? '',
      'type': 'Implants',
    };
  }

  Map<String, dynamic> _mapTray(Map<String, dynamic> e) {
    final facilityMap = e['facility'] is Map ? e['facility'] as Map<String, dynamic> : <String, dynamic>{};
    return {
      'id': e['_id']?.toString() ?? '',
      'name': e['title']?.toString() ?? e['trayId']?.toString() ?? '',
      'serial': e['trayId']?.toString() ?? '',
      'status': _normalizeStatus(e['productStatus']?.toString() ?? e['status']?.toString()),
      'location': facilityMap['address']?.toString() ?? facilityMap['facilityName']?.toString() ?? facilityMap['name']?.toString() ?? '',
      'image': e['initialPhoto']?.toString() ?? '',
      'type': 'Trays',
    };
  }

  Map<String, dynamic> _mapBio(Map<String, dynamic> e) {
    return {
      'id': e['_id']?.toString() ?? '',
      'name': e['itemName']?.toString() ?? '',
      'serial': e['lotNumber']?.toString() ?? '',
      'expiry': e['expiryDate']?.toString() ?? '',
      'vendor': e['vendor']?.toString() ?? '',
      'quantity': e['quantity']?.toString() ?? '',
      'status': _normalizeStatus(e['productStatus']?.toString() ?? e['status']?.toString()),
      'location': e['location']?.toString() ?? '',
      'image': e['initialPhoto']?.toString() ?? '',
      'notes': e['notes']?.toString() ?? '',
      'type': 'Bio',
    };
  }

  String _normalizeStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'in_stock':
      case 'in stock':
        return 'In Stock';
      case 'shipped':
        return 'Shipped';
      default:
        return raw ?? '';
    }
  }

  bool get isEmpty => inventoryItems.isEmpty;

  void onSearch(String val) {
    searchQuery.value = val;
    _fetchList();
  }

  void selectTab(int index) {
    activeTab.value = index;
    _fetchList();
  }

  void startReceivingSession() {}

  void viewFullList() {}

  void openFilter() {}

  Future<void> refreshList() => _fetchList();

  Future<void> deleteImplant(String id) async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      await _repo.deleteImplant(token, id);
      inventoryItems.removeWhere((e) => e['id'] == id);
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to delete implant');
    }
  }
}
