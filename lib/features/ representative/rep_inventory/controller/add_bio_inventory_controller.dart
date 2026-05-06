import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class VendorOption {
  final String id;
  final String name;
  const VendorOption({required this.id, required this.name});
}

class AddBioInventoryController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final itemNameController = TextEditingController();
  final lotNumberController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final additionalNotesController = TextEditingController();

  final selectedVendorId = Rxn<String>();
  final selectedVendorName = Rxn<String>();
  final expiryDate = Rxn<DateTime>();
  final selectedPhoto = Rxn<File>();

  final isLoadingVendors = true.obs;
  final isSaving = false.obs;
  final vendors = <VendorOption>[].obs;

  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadVendors();
  }

  Future<void> _loadVendors() async {
    try {
      isLoadingVendors.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getVendors(token);
      final list = _asList(res['data']);
      vendors.assignAll(list.map((e) {
        final m = e as Map<String, dynamic>;
        return VendorOption(
          id: m['_id']?.toString() ?? '',
          name: m['vendorName']?.toString() ?? m['name']?.toString() ?? '',
        );
      }));
    } catch (_) {
      // silently fail
    } finally {
      isLoadingVendors.value = false;
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

  Rxn<String> get selectedVendor => selectedVendorName;

  List<String> get vendorOptions => vendors.map((v) => v.name).toList();

  void selectVendor(String? name) {
    if (name == null || name.isEmpty) {
      selectedVendorId.value = null;
      selectedVendorName.value = null;
      return;
    }
    final matches = vendors.where((v) => v.name == name);
    if (matches.isNotEmpty) {
      selectedVendorId.value = matches.first.id;
      selectedVendorName.value = matches.first.name;
    }
  }

  void selectVendorById(String id, String name) {
    selectedVendorId.value = id;
    selectedVendorName.value = name;
  }

  Future<void> pickExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1AC8DB),
              onPrimary: Colors.white,
              surface: Color(0xFF1E2121),
              onSurface: Color(0xFFD4D4D4),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) expiryDate.value = picked;
  }

  String get expiryDateDisplay {
    if (expiryDate.value == null) return '';
    return DateFormat('MM/dd/yyyy').format(expiryDate.value!);
  }

  String get expiryDateApi {
    if (expiryDate.value == null) return '';
    return DateFormat('yyyy-MM-dd').format(expiryDate.value!);
  }

  Future<void> pickPhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) selectedPhoto.value = File(image.path);
  }

  void removePhoto() => selectedPhoto.value = null;

  Future<bool> saveBioInventory() async {
    final itemName = itemNameController.text.trim();
    final lotNumber = lotNumberController.text.trim();
    final quantity = quantityController.text.trim();
    final location = locationController.text.trim();
    if (itemName.isEmpty || lotNumber.isEmpty || quantity.isEmpty || location.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please fill in all required fields');
      return false;
    }
    try {
      isSaving.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.createBio(
        token,
        itemName: itemName,
        lotNumber: lotNumber,
        quantity: quantity,
        location: location,
        vendorId: selectedVendorId.value,
        expiryDate: expiryDateApi.isNotEmpty ? expiryDateApi : null,
        additionalNotes: additionalNotesController.text.trim().isNotEmpty
            ? additionalNotesController.text.trim()
            : null,
        photo: selectedPhoto.value,
      );
      ToastMessageHelper.showSuccessMessage('Bio inventory saved');
      return true;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to save bio inventory');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    itemNameController.dispose();
    lotNumberController.dispose();
    quantityController.dispose();
    locationController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}
