import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
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
  final trayTitle = ''.obs;
  final vendorName = ''.obs;
  final issueType = ''.obs;
  final instrumentName = ''.obs;
  final notes = ''.obs;
  final evidenceFiles = <String>[].obs;
  final capturedAt = Rxn<DateTime>();
  final isSentToVendor = false.obs;

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
      final vendorMap = data['vendor'] is Map ? data['vendor'] as Map<String, dynamic> : <String, dynamic>{};

      trayTitle.value = trayMap['title']?.toString() ?? data['trayTitle']?.toString() ?? '';
      vendorName.value = vendorMap['name']?.toString() ?? vendorMap['companyName']?.toString() ?? '';
      issueType.value = data['issueType']?.toString() ?? '';
      instrumentName.value = data['instrumentName']?.toString() ?? '';
      notes.value = data['descriptionAndNotes']?.toString() ?? data['notes']?.toString() ?? '';
      isSentToVendor.value = data['isSentToVendor'] == true;

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
      isSentToVendor.value = true;
      ToastMessageHelper.showSuccessMessage('Vendor notified successfully');
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to notify vendor';
      ToastMessageHelper.showErrorMessage(msg);
    } finally {
      isSending.value = false;
    }
  }

  void downloadPdf(BuildContext context) {}
}
