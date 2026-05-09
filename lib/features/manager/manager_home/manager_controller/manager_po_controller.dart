import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_po_repository.dart';
import '../model/manager_po_model.dart';

class ManagerPOController extends GetxController {
  final _repo = ManagerPORepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );


  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final selectedFilter = ManagerPOStatus.all.obs;
  final allOrders = <ManagerPOModel>[].obs;


  final isLoadingDetail = false.obs;
  final isSendingMail = false.obs;
  final poDetailObs = ManagerPODetailModel.empty.obs;
  ManagerPODetailModel get poDetail => poDetailObs.value;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // ── Fetch list ────────────────────────────────────────────────────────────

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final statusParam = selectedFilter.value == ManagerPOStatus.all
          ? null
          : selectedFilter.value.name;
      final res = await _repo.getAll(token, status: statusParam);
      final results = _asList(res['data']);
      allOrders.assignAll(
        results.map((e) =>
            ManagerPOModel.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load purchase orders');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch detail ──────────────────────────────────────────────────────────

  Future<void> fetchDetail(String id) async {
    try {
      isLoadingDetail.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        poDetailObs.value = ManagerPODetailModel.fromJson(data);
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load PO details');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // ── Send vendor mail ──────────────────────────────────────────────────────

  Future<void> sendVendorMail(String id) async {
    try {
      isSendingMail.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.sendVendorMail(token, id);
      ToastMessageHelper.showSuccessMessage('Email sent to vendor successfully');
      // Refresh detail to update isSentToVendor
      await fetchDetail(id);
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to send vendor mail');
    } finally {
      isSendingMail.value = false;
    }
  }

  // ── Filtered list ─────────────────────────────────────────────────────────

  List<ManagerPOModel> get filteredOrders {
    var result = allOrders.toList();
    if (selectedFilter.value != ManagerPOStatus.all) {
      result = result
          .where((o) => o.status == selectedFilter.value)
          .toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where((o) =>
              o.serialNumber.toLowerCase().contains(q) ||
              o.doctor.toLowerCase().contains(q) ||
              o.facility.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  void onFilterSelected(ManagerPOStatus s) {
    selectedFilter.value = s;
    fetchOrders();
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
}
