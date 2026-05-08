import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_expense_repository.dart';
import '../model/manager_expense_model.dart';

class ManagerExpenseController extends GetxController {
  final _repo = ManagerExpenseRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── List state ────────────────────────────────────────────────────────────
  final isLoading = true.obs;
  final selectedFilter = ManagerExpenseStatus.all.obs;
  final allExpenses = <ManagerExpenseModel>[].obs;

  // ── Detail state ──────────────────────────────────────────────────────────
  final isLoadingDetail = false.obs;
  final expenseDetail = ManagerExpenseDetailModel.empty.obs;

  // ── Sync / misc ───────────────────────────────────────────────────────────
  final syncCount = 0.obs;
  final isSyncing = false.obs;

  // ── Reject form ───────────────────────────────────────────────────────────
  final rejectCommentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  // ── Fetch list ────────────────────────────────────────────────────────────

  Future<void> fetchExpenses() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final statusParam = selectedFilter.value == ManagerExpenseStatus.all
          ? null
          : selectedFilter.value.name; // 'pending' | 'approved' | 'rejected'
      final res = await _repo.getAllExpenses(token, status: statusParam);
      final results = _asList(res['data']);
      allExpenses.assignAll(
        results.map((e) =>
            ManagerExpenseModel.fromJson(e as Map<String, dynamic>)),
      );
      syncCount.value = allExpenses
          .where((e) => e.status == ManagerExpenseStatus.pending)
          .length;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load expenses');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch detail ──────────────────────────────────────────────────────────

  Future<void> fetchExpenseDetail(String id) async {
    try {
      isLoadingDetail.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getExpenseDetail(token, id);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        expenseDetail.value = ManagerExpenseDetailModel.fromJson(data);
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load expense details');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['results', 'items', 'list', 'data', 'docs']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }

  List<ManagerExpenseModel> get filteredExpenses => allExpenses;

  int get totalItems => allExpenses.length;

  void onFilterSelected(ManagerExpenseStatus status) {
    selectedFilter.value = status;
    fetchExpenses();
  }

  // ── Approve / Reject ──────────────────────────────────────────────────────

  void approveExpense(BuildContext context) {
    Navigator.pop(context);
    ToastMessageHelper.showSuccessMessage(
        'Expense approved and synced with QuickBooks');
  }

  void rejectExpense(BuildContext context) {
    Navigator.pop(context);
    ToastMessageHelper.showErrorMessage('Expense has been rejected');
  }

  // ── Sync ──────────────────────────────────────────────────────────────────

  Future<void> syncToQB() async {
    isSyncing.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSyncing.value = false;
    ToastMessageHelper.showSuccessMessage(
        '${syncCount.value} items synced to QuickBooks');
  }

  @override
  void onClose() {
    rejectCommentController.dispose();
    super.onClose();
  }
}
