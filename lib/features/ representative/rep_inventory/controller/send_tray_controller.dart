import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nron_app/core/utils/app_colors.dart';
import 'package:nron_app/core/custom_widgets/custom_text.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class FacilityItem {
  final String id;
  final String name;
  final String code;
  final String address;

  FacilityItem({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
  });
}

class SendTrayController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  String? trayId;

  final facilityController = TextEditingController();
  final recipientNameController = TextEditingController();
  final recipientEmailController = TextEditingController();
  final additionalNotesController = TextEditingController();
  final searchController = TextEditingController();

  final systemTypeIndex = 0.obs;
  static const _systemTypeValues = ['onthopedic', 'cardiac', 'neuro', 'spine', 'other'];
  final selectedPhoto = Rxn<File>();
  final isDropdownOpen = false.obs;
  final selectedFacility = Rxn<FacilityItem>();
  final isLoadingFacilities = true.obs;
  final isSending = false.obs;

  final ImagePicker _picker = ImagePicker();

  final _facilityList = <FacilityItem>[];
  final filteredFacilities = <FacilityItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_filterFacilities);
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    try {
      isLoadingFacilities.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getFacilities(token);
      final list = _asList(res['data']);
      _facilityList.clear();
      _facilityList.addAll(list.map((e) {
        final m = e as Map<String, dynamic>;
        return FacilityItem(
          id: m['_id']?.toString() ?? '',
          name: m['facilityName']?.toString() ?? m['name']?.toString() ?? '',
          code: m['facilityCode']?.toString() ?? '',
          address: m['address']?.toString() ?? '',
        );
      }));
      filteredFacilities.assignAll(_facilityList);
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

  void _filterFacilities() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredFacilities.assignAll(_facilityList);
    } else {
      filteredFacilities.assignAll(
        _facilityList.where((f) =>
            f.name.toLowerCase().contains(query) ||
            f.code.toLowerCase().contains(query) ||
            f.address.toLowerCase().contains(query)),
      );
    }
  }

  void selectFacility(FacilityItem facility) {
    selectedFacility.value = facility;
    facilityController.text = facility.name;
    isDropdownOpen.value = false;
    searchController.clear();
  }

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
    if (isDropdownOpen.value) {
      filteredFacilities.assignAll(_facilityList);
      searchController.clear();
    }
  }

  void selectSystemType(int i) => systemTypeIndex.value = i;

  Future<void> pickPhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (image != null) {
        selectedPhoto.value = File(image.path);
        Navigator.of(Get.context!).pop();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> sendTray() async {
    final facility = selectedFacility.value;
    if (facility == null) {
      ToastMessageHelper.showErrorMessage('Please select a facility');
      return false;
    }
    if (trayId == null || trayId!.isEmpty) {
      ToastMessageHelper.showErrorMessage('Tray ID is missing');
      return false;
    }
    try {
      isSending.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.sendTray(
        token,
        trayId!,
        facilityId: facility.id,
        systemType: _systemTypeValues[systemTypeIndex.value],
        recipientName: recipientNameController.text.trim().isNotEmpty
            ? recipientNameController.text.trim()
            : null,
        recipientEmail: recipientEmailController.text.trim().isNotEmpty
            ? recipientEmailController.text.trim()
            : null,
        notes: additionalNotesController.text.trim().isNotEmpty
            ? additionalNotesController.text.trim()
            : null,
        thumbnail: selectedPhoto.value,
      );
      ToastMessageHelper.showSuccessMessage('Tray sent successfully');
      return true;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to send tray');
      return false;
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    facilityController.dispose();
    recipientNameController.dispose();
    recipientEmailController.dispose();
    additionalNotesController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
