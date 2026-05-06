import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class MovementHistoryItem {
  final String title;
  final String subtitle;
  final bool isActive;

  const MovementHistoryItem({
    required this.title,
    required this.subtitle,
    required this.isActive,
  });
}

class TrayDetailsController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  String _id = '';

  final unitName = ''.obs;
  final unitLocation = ''.obs;
  final imagePath = ''.obs;
  final inventoryModel = ''.obs;
  final status = ''.obs;
  final serialNumber = ''.obs;
  final systemType = ''.obs;
  final vendor = ''.obs;
  final availabilityStatus = ''.obs;
  final currentLocation = ''.obs;
  final additionalNote = ''.obs;
  final returnDate = ''.obs;

  void loadDetail(String id) {
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }
    _id = id;
    _fetchDetail(id);
  }

  Future<void> _fetchDetail(String id) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getTrayDetail(token, id);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final facilityMap = data['facility'] is Map ? data['facility'] as Map<String, dynamic> : <String, dynamic>{};

      unitName.value = data['title']?.toString() ?? '';
      inventoryModel.value = _capitalize(data['inventory']?.toString() ?? '');
      status.value = _capitalize(data['status']?.toString() ?? '');
      serialNumber.value = data['_id']?.toString() ?? '';
      systemType.value = data['systemType']?.toString() ?? '';
      vendor.value = data['vendor']?.toString() ?? '';
      availabilityStatus.value = _capitalize(data['productStatus']?.toString() ?? 'available');
      currentLocation.value = facilityMap['address']?.toString() ?? '';
      unitLocation.value = facilityMap['address']?.toString() ?? '';
      additionalNote.value = data['notes']?.toString() ?? '';
      returnDate.value = data['returnDate']?.toString() ?? '';
      imagePath.value = data['initialPhoto']?.toString() ?? '';
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load tray details');
    } finally {
      isLoading.value = false;
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  void sendTray(BuildContext context) =>
      context.pushNamed(AppRoutes.sendTrayScreen, extra: _id);

  void receiveTray(BuildContext context) =>
      context.pushNamed(AppRoutes.receiveTrayScreen, extra: _id);

  void reportMissingInstrument(BuildContext context) =>
      context.pushNamed(AppRoutes.missingInstrumentScreen, extra: _id);
}
