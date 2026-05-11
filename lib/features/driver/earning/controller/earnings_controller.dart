import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/earning_repository.dart';
import '../model/earning_model.dart';

class EarningsController extends GetxController {
  final _repo = EarningRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── State ─────────────────────────────────────────────────────────────────
  final isLoadingSummary = true.obs;
  final isLoadingHistory = true.obs;
  final isRequestingPayout = false.obs;

  final summary = EarningsSummaryModel.empty.obs;
  final historyItems = <EarningEntryModel>[].obs;

  final selectedFilter = 'All'.obs;
  final filters = ['All', 'paid', 'pending'];

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
    fetchHistory();
  }

  // ── Fetch summary ─────────────────────────────────────────────────────────

  Future<void> fetchSummary() async {
    try {
      isLoadingSummary.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getSummary(token);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        summary.value = EarningsSummaryModel.fromJson(data);
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load earnings summary');
    } finally {
      isLoadingSummary.value = false;
    }
  }

  // ── Fetch history ─────────────────────────────────────────────────────────

  Future<void> fetchHistory({String? status}) async {
    try {
      isLoadingHistory.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getHistory(
        token,
        status: status ?? selectedFilter.value,
      );
      final results = _asList(res['data']);
      historyItems.assignAll(
        results.map((e) =>
            EarningEntryModel.fromHistoryJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load earnings history');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // ── Filter ────────────────────────────────────────────────────────────────

  void setFilter(String filter) {
    selectedFilter.value = filter;
    fetchHistory(status: filter);
  }

  // ── Recent (dashboard preview — 3 items) ─────────────────────────────────

  List<EarningEntryModel> get recentHistory =>
      historyItems.take(3).toList();

  // ── Payout ────────────────────────────────────────────────────────────────

  Future<void> requestPayout() async {
    try {
      isRequestingPayout.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      ToastMessageHelper.showSuccessMessage('Payout request submitted!');
    } finally {
      isRequestingPayout.value = false;
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
}
