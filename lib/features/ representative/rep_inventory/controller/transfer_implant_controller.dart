import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class TransferImplantController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final reasonController = TextEditingController();

  final isLoading = false.obs;

  String implantId = '';

  Future<bool> requestTransfer() async {
    if (implantId.isEmpty) {
      ToastMessageHelper.showErrorMessage('Implant ID is missing');
      return false;
    }
    if (fromController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter the sender name');
      return false;
    }
    if (toController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter the recipient name');
      return false;
    }
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.sendTransferRequest(
        token,
        implantId,
        from: fromController.text.trim(),
        to: toController.text.trim(),
        reason: reasonController.text.trim(),
      );
      ToastMessageHelper.showSuccessMessage('Transfer request submitted');
      return true;
    } catch (e) {
      final raw = e is AppException ? e.message : 'Failed to submit transfer request';
      final msg = raw
          .replaceAll(RegExp(r'\b[0-9a-f]{24}\b'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      ToastMessageHelper.showErrorMessage(msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fromController.dispose();
    toController.dispose();
    reasonController.dispose();
    super.onClose();
  }
}
