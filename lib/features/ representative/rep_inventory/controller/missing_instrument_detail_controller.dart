import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class MissingInstrumentDetailController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final isSending = false.obs;

  String _id = '';
  final trayId = ''.obs;
  final facility = ''.obs;
  final location = ''.obs;
  final instrumentName = ''.obs;
  final notes = ''.obs;
  final evidenceFiles = <String>[].obs;
  final capturedAt = Rxn<DateTime>();
  final vendorNotified = false.obs;
  final status = ''.obs;

  void loadDetail(String id) {
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }
    _id = id;
    _fetchDetail(id);
  }

  Future<void> _fetchDetail(String instrumentId) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getMissingDetail(token, instrumentId);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final trayMap = data['tray'] is Map ? data['tray'] as Map<String, dynamic> : <String, dynamic>{};
      final facilityMap = data['facility'] is Map ? data['facility'] as Map<String, dynamic> : <String, dynamic>{};
      trayId.value = trayMap['trayId']?.toString() ?? data['trayId']?.toString() ?? '';
      facility.value = facilityMap['facilityName']?.toString() ?? facilityMap['address']?.toString() ?? '';
      location.value = data['location']?.toString() ?? '';
      instrumentName.value = data['instrumentName']?.toString() ?? data['itemName']?.toString() ?? '';
      notes.value = data['notes']?.toString() ?? data['description']?.toString() ?? '';
      status.value = data['status']?.toString() ?? '';
      vendorNotified.value = data['vendorNotified'] == true;
      final files = data['files'];
      if (files is List) {
        evidenceFiles.assignAll(files.map((e) => e.toString()));
      }
      try {
        capturedAt.value = DateTime.parse(data['createdAt']?.toString() ?? '');
      } catch (_) {}
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load report details');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendToVendorEmail(BuildContext context) async {
    if (_id.isEmpty) return;
    try {
      isSending.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.sendVendorMail(token, _id);
      vendorNotified.value = true;
      ToastMessageHelper.showSuccessMessage('Vendor notified successfully');
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to notify vendor');
    } finally {
      isSending.value = false;
    }
  }

  void downloadPdf(BuildContext context) {
    // TODO: implement PDF download
  }
}
