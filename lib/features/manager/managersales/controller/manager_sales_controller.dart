import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_sales_repository.dart';
import '../model/manager_sales_model.dart';

class ManagerSaleController extends GetxController {
  final _repo = ManagerSalesRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── List state ────────────────────────────────────────────────────────────
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final selectedFilter = ManagerSaleStatus.allSales.obs;
  final allSales = <ManagerSaleModel>[].obs;
  final isLoadingMore = false.obs;
  final scrollController = ScrollController();
  int _page = 1;
  int _totalPage = 1;
  int _requestId = 0; // drops stale responses on fast chip switches

  // ── Detail state ──────────────────────────────────────────────────────────
  final isLoadingDetail = false.obs;
  final saleDetailObs = ManagerSaleDetailModel.empty.obs;
  ManagerSaleDetailModel get saleDetail => saleDetailObs.value;

  // ── Misc ──────────────────────────────────────────────────────────────────
  final billVerification = true.obs;
  final feedbackController = TextEditingController();
  final isApprovingCommission = false.obs;
  final isSendingFeedback = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchSales();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        _page < _totalPage &&
        !isLoadingMore.value &&
        !isLoading.value) {
      _page++;
      fetchSales(reset: false);
    }
  }

  /// API status for the selected chip. "Paid" = backend "approved".
  String? get _statusParam {
    switch (selectedFilter.value) {
      case ManagerSaleStatus.allSales:
        return null;
      case ManagerSaleStatus.paid:
        return 'approved';
      default:
        return selectedFilter.value.name;
    }
  }

  bool _matchesFilter(ManagerSaleModel s) {
    switch (selectedFilter.value) {
      case ManagerSaleStatus.allSales:
        return true;
      case ManagerSaleStatus.paid:
        return s.status == ManagerSaleStatus.paid ||
            s.status == ManagerSaleStatus.approved;
      default:
        return s.status == selectedFilter.value;
    }
  }

  // ── Fetch list ────────────────────────────────────────────────────────────

  Future<void> fetchSales({bool reset = true}) async {
    final requestId = reset ? ++_requestId : _requestId;
    if (reset) {
      _page = 1;
      allSales.clear();
      isLoading.value = true;
    } else {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getAllSales(token,
          status: _statusParam, page: _page, limit: 15);
      if (requestId != _requestId) return; // a newer chip took over
      final data = res['data'];
      final meta = data is Map && data['meta'] is Map
          ? data['meta'] as Map
          : const {};
      _totalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;
      allSales.addAll(_asList(data)
          .map((e) => ManagerSaleModel.fromJson(e as Map<String, dynamic>))
          // Enforce the chip client-side too, in case the API ignores status.
          .where(_matchesFilter));
    } catch (_) {
      if (requestId == _requestId) {
        ToastMessageHelper.showErrorMessage('Failed to load sales');
      }
    } finally {
      if (requestId == _requestId) {
        isLoading.value = false;
        isLoadingMore.value = false;
      }
    }
    // Too few matches on this page to scroll → pull the next page.
    if (requestId == _requestId &&
        allSales.length < 10 &&
        _page < _totalPage) {
      _page++;
      await fetchSales(reset: false);
    }
  }

  // ── Fetch detail ──────────────────────────────────────────────────────────

  Future<void> fetchSaleDetail(String id) async {
    try {
      isLoadingDetail.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getSaleDetail(token, id);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        saleDetailObs.value = ManagerSaleDetailModel.fromJson(data);
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load sale details');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // ── Filtered list ─────────────────────────────────────────────────────────

  List<ManagerSaleModel> get filteredSales {
    var result = allSales.where(_matchesFilter).toList();
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where((s) =>
              s.facility.toLowerCase().contains(q) ||
              s.surgeon.toLowerCase().contains(q) ||
              s.saleTypeLabel.toLowerCase().contains(q) ||
              s.saleId.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void onFilterSelected(ManagerSaleStatus status) {
    if (selectedFilter.value == status) return;
    selectedFilter.value = status;
    fetchSales();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  void toggleBillVerification() => billVerification.toggle();

  Future<void> sendFeedback() async {
    final note = feedbackController.text.trim();
    if (note.isEmpty) return;
    final id = saleDetailObs.value.id;
    if (id.isEmpty) return;
    try {
      isSendingFeedback.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.updateSalesNotes(token, id, note);
      feedbackController.clear();
      ToastMessageHelper.showSuccessMessage('Feedback sent successfully');
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to send feedback');
    } finally {
      isSendingFeedback.value = false;
    }
  }

  Future<void> saveNote(String text) async {
    if (text.isEmpty) return;
    final id = saleDetailObs.value.id;
    if (id.isEmpty) return;
    try {
      final token = await PrefsHelper.getString('auth_token');
      await _repo.updateSalesNotes(token, id, text);
      ToastMessageHelper.showSuccessMessage('Note saved successfully');
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to save note');
    }
  }

  Future<void> approveCommission() async {
    final id = saleDetailObs.value.id;
    if (id.isEmpty) return;
    try {
      isApprovingCommission.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.approveCommission(token, id);
      // Refresh detail to reflect new status
      await fetchSaleDetail(id);
      ToastMessageHelper.showSuccessMessage('Commission approved successfully');
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to approve commission');
    } finally {
      isApprovingCommission.value = false;
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

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    feedbackController.dispose();
    super.onClose();
  }
}
