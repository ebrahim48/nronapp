import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/commission_repository.dart';
import '../domain/model/commission_model.dart';

class CommissionController extends GetxController {
  final _repo = CommissionRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Overview stats ──────────────────────────────────────────────────────────
  final totalSales = 0.0.obs;
  final thisMonth = 0.0.obs;
  final pendingPayment = 0.0.obs;
  final paid = 0.0.obs;
  final trendPoints = <TrendPoint>[].obs;
  final recentCommissions = <CommissionModel>[].obs;
  final isLoadingOverview = false.obs;

  // ── History (paginated) ─────────────────────────────────────────────────────
  final allHistoryGroups = <CommissionHistoryGroup>[].obs;
  final isLoadingHistory = false.obs;
  final isLoadingMoreHistory = false.obs;
  final historyFilter = Rx<CommissionStatus?>(null);
  final historyScrollController = ScrollController();

  int _historyPage = 1;
  int _historyTotalPage = 1;

  // ── Detail ──────────────────────────────────────────────────────────────────
  final _detail = Rxn<CommissionDetailModel>();
  final isLoadingDetail = false.obs;

  CommissionDetailModel get commissionDetail =>
      _detail.value ?? const CommissionDetailModel();

  @override
  void onInit() {
    super.onInit();
    fetchOverview();
    fetchHistory();
    historyScrollController.addListener(_onHistoryScroll);
  }

  @override
  void onClose() {
    historyScrollController.removeListener(_onHistoryScroll);
    historyScrollController.dispose();
    super.onClose();
  }

  void _onHistoryScroll() {
    if (historyScrollController.position.pixels >=
        historyScrollController.position.maxScrollExtent - 200) {
      _loadMoreHistory();
    }
  }

  // ── Overview ────────────────────────────────────────────────────────────────
  Future<void> fetchOverview() async {
    isLoadingOverview.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getOverview(token);
      if (res['success'] == true) {
        final overview = CommissionOverviewModel.fromJson(
            res['data'] as Map<String, dynamic>);
        totalSales.value = overview.totalSales;
        thisMonth.value = overview.thisMonth;
        pendingPayment.value = overview.pendingPayment;
        paid.value = overview.paid;
        trendPoints.assignAll(overview.sixMonthTrend);
        recentCommissions.assignAll(overview.recentCommissions);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isLoadingOverview.value = false;
    }
  }

  // ── History ─────────────────────────────────────────────────────────────────
  Future<void> fetchHistory({bool reset = true}) async {
    if (reset) {
      _historyPage = 1;
      isLoadingHistory.value = true;
    } else {
      if (isLoadingMoreHistory.value) return;
      isLoadingMoreHistory.value = true;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getHistory(token,
          page: _historyPage, limit: 10);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final meta = data['meta'] as Map<String, dynamic>;
        _historyTotalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;

        final items = (data['results'] as List<dynamic>)
            .map((e) =>
                CommissionModel.fromJson(e as Map<String, dynamic>))
            .toList();

        final grouped = _groupByDate(items);

        if (reset) {
          allHistoryGroups.assignAll(grouped);
        } else {
          final existing = {
            for (final g in allHistoryGroups)
              g.dateLabel: List<CommissionModel>.from(g.items)
          };
          for (final g in grouped) {
            existing.putIfAbsent(g.dateLabel, () => []).addAll(g.items);
          }
          allHistoryGroups.assignAll(existing.entries
              .map((e) => CommissionHistoryGroup(
                  dateLabel: e.key, items: e.value))
              .toList());
        }
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isLoadingHistory.value = false;
      isLoadingMoreHistory.value = false;
    }
  }

  bool get _canLoadMoreHistory =>
      _historyPage < _historyTotalPage &&
      !isLoadingMoreHistory.value &&
      !isLoadingHistory.value;

  void _loadMoreHistory() {
    if (!_canLoadMoreHistory) return;
    _historyPage++;
    fetchHistory(reset: false);
  }

  List<CommissionHistoryGroup> _groupByDate(List<CommissionModel> items) {
    final map = <String, List<CommissionModel>>{};
    for (final item in items) {
      final label = _groupLabel(item.rawCreatedAt);
      map.putIfAbsent(label, () => []).add(item);
    }
    return map.entries
        .map((e) =>
            CommissionHistoryGroup(dateLabel: e.key, items: e.value))
        .toList();
  }

  String _groupLabel(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      final now = DateTime.now();
      if (dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day) return 'Today';
      return DateFormat('dd MMMM yyyy').format(dt);
    } catch (_) {
      return rawDate;
    }
  }

  List<CommissionHistoryGroup> get filteredGroups {
    if (historyFilter.value == null) return allHistoryGroups;
    return allHistoryGroups
        .map((g) => CommissionHistoryGroup(
              dateLabel: g.dateLabel,
              items: g.items
                  .where((i) => i.status == historyFilter.value)
                  .toList(),
            ))
        .where((g) => g.items.isNotEmpty)
        .toList();
  }

  void setHistoryFilter(CommissionStatus? status) =>
      historyFilter.value = status;

  // ── Detail ──────────────────────────────────────────────────────────────────
  Future<void> fetchDetail(String id) async {
    isLoadingDetail.value = true;
    _detail.value = null;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      if (res['success'] == true) {
        _detail.value = CommissionDetailModel.fromJson(
            res['data'] as Map<String, dynamic>);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isLoadingDetail.value = false;
    }
  }
}
