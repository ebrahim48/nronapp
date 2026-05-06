import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import 'add_implant_controller.dart' show FacilityOption;

class DropdownOption {
  final String id;
  final String name;
  const DropdownOption({required this.id, required this.name});
}

class NewTrayController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final selectedPhoto = Rxn<File>();
  final _picker = ImagePicker();

  final trayIdController = TextEditingController();
  final returnDateController = TextEditingController();
  final additionalNotesController = TextEditingController();

  final selectedFacilityId = ''.obs;
  final selectedFacilityName = ''.obs;
  final selectedVendorId = ''.obs;
  final selectedVendorName = ''.obs;
  final selectedSystemType = ''.obs;

  final inventoryModelIndex = 0.obs;
  final statusIndex = 0.obs;

  final isLoadingDropdowns = true.obs;
  final isSaving = false.obs;
  final facilities = <FacilityOption>[].obs;
  final vendors = <DropdownOption>[].obs;
  final systemTypeOptions = ['Type A', 'Type B', 'Type C'];

  static const _inventoryModels = ['loaner', 'consignment'];
  static const _statusOptions = ['downRack', 'wrapped', 'Warehouse'];

  // Display labels shown in the UI toggles/selectors
  static const inventoryModelLabels = ['Loaner', 'Consignment'];
  static const statusLabels = ['Down Rack', 'Wrapped', 'Warehouse'];

  @override
  void onInit() {
    super.onInit();
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    try {
      isLoadingDropdowns.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final results = await Future.wait([
        _repo.getFacilities(token),
        _repo.getVendors(token),
      ]);

      final facilityList = _asList(results[0]['data']);
      facilities.assignAll(facilityList.map((e) {
        final m = e as Map<String, dynamic>;
        return FacilityOption(
          id: m['_id']?.toString() ?? '',
          name: m['facilityName']?.toString() ?? m['name']?.toString() ?? '',
        );
      }));

      final vendorList = _asList(results[1]['data']);
      vendors.assignAll(vendorList.map((e) {
        final m = e as Map<String, dynamic>;
        return DropdownOption(
          id: m['_id']?.toString() ?? '',
          name: m['vendorName']?.toString() ?? m['name']?.toString() ?? '',
        );
      }));
    } catch (_) {
      // silently fail
    } finally {
      isLoadingDropdowns.value = false;
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

  Future<void> pickPhotoFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (image != null) selectedPhoto.value = File(image.path);
  }

  Future<void> pickPhotoFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) selectedPhoto.value = File(image.path);
  }

  void removePhoto() => selectedPhoto.value = null;

  RxString get selectedFacility => selectedFacilityName;

  List<String> get facilityOptions => facilities.map((f) => f.name).toList();

  void selectFacility(String? name) {
    if (name == null || name.isEmpty) {
      selectedFacilityId.value = '';
      selectedFacilityName.value = '';
      return;
    }
    final matches = facilities.where((f) => f.name == name);
    if (matches.isNotEmpty) {
      selectedFacilityId.value = matches.first.id;
      selectedFacilityName.value = matches.first.name;
    }
  }

  void selectFacilityById(String id, String name) {
    selectedFacilityId.value = id;
    selectedFacilityName.value = name;
  }

  List<String> get vendorOptions => vendors.map((v) => v.name).toList();

  void selectVendorByName(String? name) {
    if (name == null || name.isEmpty) {
      selectedVendorId.value = '';
      selectedVendorName.value = '';
      return;
    }
    final matches = vendors.where((v) => v.name == name);
    if (matches.isNotEmpty) {
      selectedVendorId.value = matches.first.id;
      selectedVendorName.value = matches.first.name;
    }
  }

  void selectVendor(String id, String name) {
    selectedVendorId.value = id;
    selectedVendorName.value = name;
  }

  void selectSystemType(String val) => selectedSystemType.value = val;
  void selectInventoryModel(int i) => inventoryModelIndex.value = i;
  void selectStatus(int i) => statusIndex.value = i;

  void pickReturnDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF00C5DA)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      returnDateController.text =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<bool> createTrayRecord() async {
    final trayId = trayIdController.text.trim();
    if (trayId.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter a Tray ID');
      return false;
    }
    if (selectedFacilityId.value.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select a facility');
      return false;
    }
    try {
      isSaving.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.createTray(
        token,
        title: trayId,
        facilityId: selectedFacilityId.value,
        vendorId: selectedVendorId.value.isNotEmpty ? selectedVendorId.value : null,
        systemType: selectedSystemType.value.isNotEmpty ? selectedSystemType.value : null,
        inventoryModel: _inventoryModels[inventoryModelIndex.value],
        status: _statusOptions[statusIndex.value],
        returnDate: returnDateController.text.trim().isNotEmpty ? returnDateController.text.trim() : null,
        notes: additionalNotesController.text.trim().isNotEmpty ? additionalNotesController.text.trim() : null,
        thumbnail: selectedPhoto.value,
      );
      ToastMessageHelper.showSuccessMessage('Tray created successfully');
      return true;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to create tray');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    trayIdController.dispose();
    returnDateController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}
