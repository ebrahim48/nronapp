import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/activity_log_repository.dart';
import '../model/activity_log_model.dart';

class ActivityLogController extends GetxController {
  final _repo = ActivityLogRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoadingModules = true.obs;
  final isLoading = true.obs;

  final modules = <String>['All'].obs;
  final selectedModule = 'All'.obs;

  final logs = <ActivityLogModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadModules();
    fetchLogs();
  }

  Future<void> _loadModules() async {
    try {
      isLoadingModules.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final raw = await _repo.getModels(token);
      final seen = <String>{};
      final result = <String>['All'];
      for (final item in raw) {
        if (item is Map) {
          final m = item['module']?.toString() ?? '';
          if (m.isNotEmpty && seen.add(m)) {
            result.add(_capitalize(m));
          }
        }
      }
      modules.assignAll(result);
    } catch (_) {
      // keep default ['All'] on error
    } finally {
      isLoadingModules.value = false;
    }
  }

  Future<void> fetchLogs({String? module}) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final filter = module ?? selectedModule.value;
      final res = await _repo.getAll(
        token,
        module: filter == 'All' ? null : filter.toLowerCase(),
      );
      final data = res['data'];
      List<dynamic> raw = [];
      if (data is Map && data['results'] is List) {
        raw = data['results'] as List;
      } else if (data is List) {
        raw = data;
      }
      logs.assignAll(
        raw.map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load activity log');
    } finally {
      isLoading.value = false;
    }
  }

  void selectModule(String m) {
    selectedModule.value = m;
    fetchLogs(module: m);
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
