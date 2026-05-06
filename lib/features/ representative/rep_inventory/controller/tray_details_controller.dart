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

      final results = await Future.wait([
        _repo.getTrayDetail(token, id),
        _repo.getVendors(token),
      ]);

      final data = results[0]['data'] as Map<String, dynamic>? ?? {};
      final facilityMap = data['facility'] is Map ? data['facility'] as Map<String, dynamic> : <String, dynamic>{};

      // Build vendor lookup map: id -> name
      final vendorList = _asList(results[1]['data']);
      final vendorById = <String, String>{};
      for (final v in vendorList) {
        if (v is Map<String, dynamic>) {
          final vid = v['_id']?.toString() ?? '';
          final vname = v['vendorName']?.toString() ?? v['name']?.toString() ?? '';
          if (vid.isNotEmpty) vendorById[vid] = vname;
        }
      }

      // Resolve vendor: populated object → name, raw ID → lookup, fallback to raw
      final vendorRaw = data['vendor'];
      String resolvedVendor = '';
      if (vendorRaw is Map) {
        resolvedVendor = (vendorRaw as Map<String, dynamic>)['vendorName']?.toString() ??
            (vendorRaw)['name']?.toString() ?? '';
      } else {
        final vid = vendorRaw?.toString() ?? '';
        resolvedVendor = vendorById[vid] ?? vid;
      }

      unitName.value = data['title']?.toString() ?? '';
      inventoryModel.value = _capitalize(data['inventory']?.toString() ?? '');
      status.value = _capitalize(data['status']?.toString() ?? '');
      serialNumber.value = data['title']?.toString() ?? data['trayId']?.toString() ?? '';
      systemType.value = data['systemType']?.toString() ?? '';
      vendor.value = resolvedVendor;
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

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['items', 'list', 'data', 'docs']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
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
