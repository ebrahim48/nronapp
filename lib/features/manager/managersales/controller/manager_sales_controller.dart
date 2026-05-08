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

  // ── Detail state ──────────────────────────────────────────────────────────
  final isLoadingDetail = false.obs;
  final saleDetailObs = ManagerSaleDetailModel.empty.obs;
  ManagerSaleDetailModel get saleDetail => saleDetailObs.value;

  // ── Misc ──────────────────────────────────────────────────────────────────
  final billVerification = true.obs;
  final feedbackController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  // ── Fetch list ────────────────────────────────────────────────────────────

  Future<void> fetchSales() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final statusParam = selectedFilter.value == ManagerSaleStatus.allSales
          ? null
          : selectedFilter.value.name;
      final res = await _repo.getAllSales(token, status: statusParam);
      final results = _asList(res['data']);
      allSales.assignAll(
        results.map((e) =>
            ManagerSaleModel.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load sales');
    } finally {
      isLoading.value = false;
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
    var result = allSales.toList();
    if (selectedFilter.value != ManagerSaleStatus.allSales) {
      result = result
          .where((s) => s.status == selectedFilter.value)
          .toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
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
    selectedFilter.value = status;
    fetchSales();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  void toggleBillVerification() => billVerification.toggle();

  void sendFeedback() {
    if (feedbackController.text.trim().isEmpty) return;
    ToastMessageHelper.showSuccessMessage('Feedback sent to rep');
    feedbackController.clear();
  }

  void saveNote(String text) {
    if (text.isEmpty) return;
    ToastMessageHelper.showSuccessMessage('Note saved successfully');
  }

  void approveCommission() {
    ToastMessageHelper.showSuccessMessage('Commission approved successfully');
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
    feedbackController.dispose();
    super.onClose();
  }
}
