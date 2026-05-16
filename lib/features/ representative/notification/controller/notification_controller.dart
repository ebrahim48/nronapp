import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/socket_service.dart';
import '../data/notification_repository.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  final _repo = NotificationRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final notifications = <NotificationModel>[].obs;

  int _page = 1;
  int _totalPages = 1;
  static const _limit = 10;

  bool get hasMore => _page < _totalPages;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    if (Get.isRegistered<SocketService>()) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => SocketService.instance.clearBadge(),
      );
    }
  }

  Future<void> fetchNotifications() async {
    try {
      _page = 1;
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getAll(token, page: _page, limit: _limit);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final pagination = data['pagination'] as Map<String, dynamic>? ?? {};
      _totalPages = (pagination['totalPage'] as num?)?.toInt() ?? 1;
      final raw = data['results'] as List? ?? [];
      notifications.assignAll(
        raw.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;
    try {
      isLoadingMore.value = true;
      _page++;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getAll(token, page: _page, limit: _limit);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final raw = data['results'] as List? ?? [];
      notifications.addAll(
        raw.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      _page--;
      ToastMessageHelper.showErrorMessage('Failed to load more notifications');
    } finally {
      isLoadingMore.value = false;
    }
  }
}
