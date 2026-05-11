import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_commission_repository.dart';
import '../model/manager_commission_model.dart';

class ManagerCommissionController extends GetxController {
  final _repo = ManagerCommissionRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Dashboard stats ───────────────────────────────────────────────────────
  final isLoadingStats = true.obs;
  final totalSales = 0.0.obs;
  final totalCommission = 0.0.obs;
  final pendingPayment = 0.0.obs;
  final paidCommission = 0.0.obs;
  final trendPoints = <TrendDataPoint>[].obs;

  List<ManagerCommissionStat> get stats => [
        ManagerCommissionStat(label: 'Total Sales', value: '\$${totalSales.value.toStringAsFixed(0)}', valueColor: Colors.white),
        ManagerCommissionStat(label: 'Total Commission', value: '\$${totalCommission.value.toStringAsFixed(0)}', valueColor: Colors.white),
        ManagerCommissionStat(label: 'Pending Payment', value: '\$${pendingPayment.value.toStringAsFixed(0)}', valueColor: const Color(0xFFFFB516)),
        ManagerCommissionStat(label: 'Paid Commission', value: '\$${paidCommission.value.toStringAsFixed(0)}', valueColor: Colors.white),
      ];

  // ── Commission list ───────────────────────────────────────────────────────
  final isLoadingList = true.obs;
  final allListItems = <CommissionListItem>[].obs;
  final listSearchQuery = ''.obs;
  final selectedBillStatus = CommissionBillStatus.all.obs;
  final selectedPaymentStatus = CommissionPaymentStatus.all.obs;
  final selectedTerritory = ''.obs;
  final repSearchQuery = ''.obs;
  final selectedReps = <String>[].obs;

  // ── Mark paid loading ─────────────────────────────────────────────────────
  final isMarkingPaid = false.obs;

  final territories = ['Northeast', 'Southeast', 'West', 'Midwest', 'Southwest', 'Pacific'];

  List<CommissionListItem> get filteredItems {
    var list = allListItems.toList();
    final q = listSearchQuery.value.toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((i) =>
          i.saleId.toLowerCase().contains(q) ||
          i.repName.toLowerCase().contains(q)).toList();
    }
    if (selectedBillStatus.value != CommissionBillStatus.all) {
      list = list.where((i) => i.billStatus == selectedBillStatus.value).toList();
    }
    if (selectedPaymentStatus.value != CommissionPaymentStatus.all) {
      final wantPaid = selectedPaymentStatus.value == CommissionPaymentStatus.paid;
      list = list.where((i) => (i.status == 'paid') == wantPaid).toList();
    }
    return list;
  }

  int get totalEntries => allListItems.length;

  // ── Commission detail ─────────────────────────────────────────────────────
  final isLoadingDetail = false.obs;
  final commissionDetail = CommissionDetailModel.empty.obs;

  // ── Transaction detail (static for now) ──────────────────────────────────
  final transactionDetail = const TransactionDetailModel(
    amount: 0, isPaid: false, date: '', transactionId: '',
    invoiceLink: '', expenseLink: '', paymentMethod: '',
    payoutSchedule: '', relatedSaleId: '', surgeon: '', facility: '',
  );

  // ── Commission management ─────────────────────────────────────────────────
  final isLoadingManage = true.obs;
  final avgCommission = 0.0.obs;
  final totalReps = 0.obs;
  final repRates = <CommissionRepRate>[].obs;
  final newRateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fetchOverview();
    fetchList();
    _fetchManageOverview();
    fetchManageList();
  }

  // ── Fetch overview ────────────────────────────────────────────────────────

  Future<void> _fetchOverview() async {
    try {
      isLoadingStats.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      totalSales.value = (data['totalSales'] as num?)?.toDouble() ?? 0;
      totalCommission.value = (data['totalCommission'] as num?)?.toDouble() ?? 0;
      pendingPayment.value = (data['pendingPayment'] as num?)?.toDouble() ?? 0;
      paidCommission.value = (data['paidCommission'] as num?)?.toDouble() ?? 0;
      final trend = data['monthlyCommissionTrend'];
      if (trend is List) {
        trendPoints.assignAll(
          trend.map((e) => TrendDataPoint.fromJson(e as Map<String, dynamic>)),
        );
      }
    } catch (_) {
    } finally {
      isLoadingStats.value = false;
    }
  }

  // ── Fetch list ────────────────────────────────────────────────────────────

  Future<void> fetchList() async {
    try {
      isLoadingList.value = true;
      final token = await PrefsHelper.getString('auth_token');
      // Pass payment status filter to API when not 'all'
      final statusParam = selectedPaymentStatus.value == CommissionPaymentStatus.all
          ? null
          : selectedPaymentStatus.value == CommissionPaymentStatus.paid
              ? 'paid'
              : 'unpaid';
      final res = await _repo.getAll(token, status: statusParam);
      final results = _asList(res['data']);
      allListItems.assignAll(
        results.map((e) => CommissionListItem.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load commissions');
    } finally {
      isLoadingList.value = false;
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
        commissionDetail.value = CommissionDetailModel.fromJson(data);
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load commission details');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // ── Approve commission ────────────────────────────────────────────────────

  Future<void> approveCommission(BuildContext context) async {
    try {
      final id = commissionDetail.value.id;
      if (id.isEmpty) return;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.approveCommission(token, id);
      Navigator.pop(context);
      ToastMessageHelper.showSuccessMessage('Commission approved successfully');
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to approve commission');
    }
  }

  // ── Manage overview ───────────────────────────────────────────────────────

  Future<void> _fetchManageOverview() async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getManageOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      avgCommission.value = (data['avgCommission'] as num?)?.toDouble() ?? 0;
      totalReps.value = (data['total'] as num?)?.toInt() ?? 0;
    } catch (_) {}
  }

  // ── Manage list ───────────────────────────────────────────────────────────

  Future<void> fetchManageList() async {
    try {
      isLoadingManage.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getManageAll(token);
      final results = _asList(res['data']);
      repRates.assignAll(
        results.map((e) => CommissionRepRate.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
    } finally {
      isLoadingManage.value = false;
    }
  }

  // ── Update rate ───────────────────────────────────────────────────────────

  Future<void> updateRate(int index, {double? newRate}) async {
    final rate = newRate ?? double.tryParse(newRateController.text.trim());
    if (rate == null) {
      ToastMessageHelper.showErrorMessage('Enter a valid rate');
      return;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final rep = repRates[index];
      await _repo.updateCommissionRate(
        token,
        rep.id,
        representativeId: rep.representativeId,
        rate: rate,
      );
      ToastMessageHelper.showSuccessMessage('Commission rate updated');
      newRateController.clear();
      fetchManageList();
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to update rate');
    }
  }


  Future<void> markPaid(BuildContext context) async {
    final id = commissionDetail.value.id;
    if (id.isEmpty) return;
    try {
      isMarkingPaid.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.markPaid(token, id);
      // Reflect locally
      commissionDetail.value = CommissionDetailModel(
        id: commissionDetail.value.id,
        repName: commissionDetail.value.repName,
        repRole: commissionDetail.value.repRole,
        repAvatarUrl: commissionDetail.value.repAvatarUrl,
        paymentStatus: CommissionPaymentStatus.paid,
        totalCommissionDue: commissionDetail.value.totalCommissionDue,
        saleAmount: commissionDetail.value.saleAmount,
        rate: commissionDetail.value.rate,
        date: commissionDetail.value.date,
        saleId: commissionDetail.value.saleId,
        facility: commissionDetail.value.facility,
        territory: commissionDetail.value.territory,
        bills: commissionDetail.value.bills,
        splits: commissionDetail.value.splits,
        totalCommissionPool: commissionDetail.value.totalCommissionPool,
      );
      fetchList();
      _showViewTransactionPopup(context);
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to mark commission as paid');
    } finally {
      isMarkingPaid.value = false;
    }
  }

  void _showViewTransactionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1E2427),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                      color: const Color(0xFF34D399).withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF34D399), size: 16),
                    SizedBox(width: 8),
                    Text('Paid',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF34D399))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Commission marked as paid successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              // View Transaction button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to transaction detail screen
                  final router = GoRouter.of(context);
                  router.push(AppRoutes.transactionDetailScreen);
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC5B13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text('View Transaction',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              // Done button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Done',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.white54)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filter helpers ────────────────────────────────────────────────────────

  void applyFilters() {
    fetchList();
  }

  void resetFilters() {
    selectedBillStatus.value = CommissionBillStatus.all;
    selectedPaymentStatus.value = CommissionPaymentStatus.all;
    selectedTerritory.value = '';
    repSearchQuery.value = '';
    selectedReps.clear();
    fetchList();
  }

  void toggleTerritory(String t) {
    selectedTerritory.value = selectedTerritory.value == t ? '' : t;
  }

  void downloadCSV() {
    ToastMessageHelper.showSuccessMessage('CSV downloaded successfully');
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
    newRateController.dispose();
    super.onClose();
  }
}
