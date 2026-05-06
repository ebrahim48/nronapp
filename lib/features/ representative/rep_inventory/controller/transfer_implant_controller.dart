import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import 'add_implant_controller.dart' show FacilityOption;

class TransferImplantController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final reasonController = TextEditingController();

  final isLoading = false.obs;
  final isLoadingFacilities = true.obs;
  final facilities = <FacilityOption>[].obs;
  final selectedToFacilityId = Rxn<String>();
  final selectedToFacilityName = Rxn<String>();

  String? implantId;

  @override
  void onInit() {
    super.onInit();
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    try {
      isLoadingFacilities.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getFacilities(token);
      final list = _asList(res['data']);
      facilities.assignAll(list.map((e) {
        final m = e as Map<String, dynamic>;
        return FacilityOption(
          id: m['_id']?.toString() ?? '',
          name: m['facilityName']?.toString() ?? m['name']?.toString() ?? '',
        );
      }));
    } catch (_) {
      // silently fail
    } finally {
      isLoadingFacilities.value = false;
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

  void selectToFacility(String id, String name) {
    selectedToFacilityId.value = id;
    selectedToFacilityName.value = name;
    toController.text = name;
  }

  Future<bool> requestTransfer() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (implantId == null || implantId!.isEmpty) {
      ToastMessageHelper.showErrorMessage('Implant ID is missing');
      return false;
    }
    if (fromController.text.trim().isEmpty || toController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please fill From and To fields');
      return false;
    }
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.sendTransferRequest(
        token,
        implantId!,
        from: fromController.text.trim(),
        to: toController.text.trim(),
        reason: reasonController.text.trim(),
      );
      ToastMessageHelper.showSuccessMessage('Transfer request submitted');
      return true;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to submit transfer request');
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
