import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/purchase_order_repository.dart';
import '../model/purchase_order_model.dart';

class PurchaseOrderController extends GetxController {
  final _repo = PurchaseOrderRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── List ──────────────────────────────────────────────────────────────────
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final allOrders = <PurchaseOrderModel>[].obs;
  final scrollController = ScrollController();
  int _currentPage = 1;
  int _totalPage = 1;

  // ── Filters ───────────────────────────────────────────────────────────────
  final searchQuery = ''.obs;
  final selectedFilter = POStatus.all.obs;

  // ── Detail ────────────────────────────────────────────────────────────────
  final isLoadingDetail = false.obs;
  final detailObs = Rxn<Map<String, dynamic>>();

  // ── Delete ────────────────────────────────────────────────────────────────
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  String? get _statusParam {
    switch (selectedFilter.value) {
      case POStatus.open:
        return 'open';
      case POStatus.lost:
        return 'lost';
      case POStatus.complete:
        return 'complete';
      default:
        return null;
    }
  }

  Future<void> fetchOrders({bool reset = true}) async {
    if (reset) {
      _currentPage = 1;
      allOrders.clear();
      isLoading.value = true;
    } else {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getAll(token,
          page: _currentPage, limit: 15, status: _statusParam);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final meta = data['meta'] as Map<String, dynamic>? ?? {};
        _totalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;
        final results = (data['results'] as List<dynamic>)
            .map((e) => PurchaseOrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        allOrders.addAll(results);
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _loadMore() {
    if (_currentPage >= _totalPage ||
        isLoadingMore.value ||
        isLoading.value) return;
    _currentPage++;
    fetchOrders(reset: false);
  }

  List<PurchaseOrderModel> get filteredOrders {
    if (searchQuery.value.isEmpty) return allOrders;
    final q = searchQuery.value.toLowerCase();
    return allOrders
        .where((o) =>
            o.purchaseOrderNumber.toLowerCase().contains(q) ||
            o.patientId.toLowerCase().contains(q) ||
            o.orderTypeLabel.toLowerCase().contains(q))
        .toList();
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void onFilterSelected(POStatus status) {
    if (selectedFilter.value == status) return;
    selectedFilter.value = status;
    fetchOrders();
  }

  Future<void> fetchDetail(String id) async {
    isLoadingDetail.value = true;
    detailObs.value = null;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      if (res['success'] == true) {
        detailObs.value = res['data'] as Map<String, dynamic>;
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<bool> deleteOrder(String id) async {
    isDeleting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      if (res['success'] == true) {
        allOrders.removeWhere((o) => o.id == id);
        return true;
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isDeleting.value = false;
    }
    return false;
  }
}
