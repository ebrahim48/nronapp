import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nron_app/core/constants/app_colors.dart';
import 'package:nron_app/core/custom_widgets/custom_text.dart';

class FacilityItem {
  final String name;
  final String code;
  final String address;

  FacilityItem({
    required this.name,
    required this.code,
    required this.address,
  });
}

class SendTrayController extends GetxController {
  final facilityController = TextEditingController();
  final recipientNameController = TextEditingController();
  final recipientEmailController = TextEditingController();
  final additionalNotesController = TextEditingController();

  final systemTypeIndex = 0.obs;
  final selectedPhoto = Rxn<File>();
  final isDropdownOpen = false.obs;
  final selectedFacility = Rxn<FacilityItem>();

  final ImagePicker _picker = ImagePicker();

  final facilityList = [
    FacilityItem(
      name: 'City Hospital',
      code: 'CH-001',
      address: '123 Main Street, Downtown',
    ),
    FacilityItem(
      name: 'Ortho Health Center',
      code: 'OHC-002',
      address: '456 Park Avenue, Midtown',
    ),
    FacilityItem(
      name: 'Advanced Care Clinic',
      code: 'ACC-003',
      address: '789 Elm Street, Uptown',
    ),
    FacilityItem(
      name: 'Joint Rehabilitation Center',
      code: 'JRC-004',
      address: '321 Oak Drive, Eastside',
    ),
    FacilityItem(
      name: 'Metro Medical Center',
      code: 'MMC-005',
      address: '555 Boulevard, Westend',
    ),
    FacilityItem(
      name: 'Premier Health Services',
      code: 'PHS-006',
      address: '888 Central Avenue, Northside',
    ),
  ];

  final searchController = TextEditingController();
  final filteredFacilities = <FacilityItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredFacilities.assignAll(facilityList);
    searchController.addListener(_filterFacilities);
  }

  void _filterFacilities() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredFacilities.assignAll(facilityList);
    } else {
      filteredFacilities.assignAll(
        facilityList.where((f) =>
            f.name.toLowerCase().contains(query) ||
            f.code.toLowerCase().contains(query) ||
            f.address.toLowerCase().contains(query)).toList(),
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
      filteredFacilities.assignAll(facilityList);
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
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void sendTray() {
    // Implement send tray logic
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