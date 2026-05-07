import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/shipment_repository.dart';
import '../model/shipment_model.dart';

class ShipmentsListController extends GetxController {
  final _repo = ShipmentRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final shipments = <ShipmentModel>[].obs;
  final selectedTabIndex = 0.obs;
  final searchQuery = ''.obs;

  int _currentPage = 1;
  bool _hasMore = true;

  static const _statusFilters = ['', 'pending', 'approved', 'rejected'];

  @override
  void onInit() {
    super.onInit();
    fetchShipments();
    debounce(searchQuery, (_) => refresh(), time: const Duration(milliseconds: 400));
  }

  void setTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
    refresh();
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void refresh() {
    _currentPage = 1;
    _hasMore = true;
    shipments.clear();
    fetchShipments();
  }

  Future<void> fetchShipments() async {
    if (!_hasMore) return;
    try {
      if (_currentPage == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final token = await PrefsHelper.getString('auth_token');
      final status = _statusFilters[selectedTabIndex.value];
      final res = await _repo.getList(
        token,
        page: _currentPage,
        limit: 20,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        status: status.isNotEmpty ? status : null,
      );

      final data = res['data'] as Map<String, dynamic>? ?? {};
      final docs = data['results'] as List? ?? data['docs'] as List? ?? data['shipments'] as List? ?? [];

      final list = docs.whereType<Map<String, dynamic>>()
          .map(ShipmentModel.fromJson)
          .toList();

      if (list.length < 20) _hasMore = false;
      if (_currentPage == 1) {
        shipments.assignAll(list);
      } else {
        shipments.addAll(list);
      }
      _currentPage++;
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to load shipments';
      ToastMessageHelper.showErrorMessage(msg);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
