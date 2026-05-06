import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import '../model/missing_instrument_model.dart';

class MissingInstrumentHistoryController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final totalCount = 0.obs;
  final missingCount = 0.obs;
  final searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final _allItems = <MissingInstrumentModel>[].obs;

  List<MissingInstrumentModel> get filteredItems {
    if (searchQuery.value.isEmpty) return _allItems;
    final q = searchQuery.value.toLowerCase();
    return _allItems
        .where((e) =>
            e.trayId.toLowerCase().contains(q) ||
            e.facility.toLowerCase().contains(q) ||
            e.instrumentName.toLowerCase().contains(q))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() => searchQuery.value = searchController.text);
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([_fetchOverview(), _fetchHistory()]);
  }

  Future<void> _fetchOverview() async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getMissingOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      totalCount.value = (data['total'] as num?)?.toInt() ?? 0;
      missingCount.value = (data['missing'] as num?)?.toInt() ?? 0;
    } catch (_) {}
  }

  Future<void> _fetchHistory() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getMissingHistory(token);
      final list = _asList(res['data']);
      _allItems.assignAll(list.map((e) => _fromJson(e as Map<String, dynamic>)));
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load missing instrument history');
    } finally {
      isLoading.value = false;
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

  MissingInstrumentModel _fromJson(Map<String, dynamic> e) {
    MissingInstrumentStatus status;
    switch (e['issueType']?.toString().toLowerCase()) {
      case 'damage':
        status = MissingInstrumentStatus.damaged;
        break;
      case 'missing':
        status = MissingInstrumentStatus.missing;
        break;
      case 'resolved':
        status = MissingInstrumentStatus.resolved;
        break;
      default:
        status = MissingInstrumentStatus.other;
    }

    DateTime date;
    try {
      date = DateTime.parse(e['date']?.toString() ?? '');
    } catch (_) {
      date = DateTime.now();
    }

    return MissingInstrumentModel(
      id: e['_id']?.toString() ?? '',
      trayId: e['trayTitle']?.toString() ?? '',
      facility: e['facilityName']?.toString() ?? '',
      instrumentName: e['instrumentName']?.toString() ?? '',
      reportedBy: e['userName']?.toString() ?? '',
      reporterAvatarUrl: e['profileUrl']?.toString() ?? '',
      date: date,
      status: status,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void openDetail(BuildContext context, MissingInstrumentModel item) {
    context.pushNamed(
      AppRoutes.missingInstrumentDetailScreen,
      extra: item.id,
    );
  }

  void openFilter(BuildContext context) {}
}
