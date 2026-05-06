import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import 'add_bio_inventory_controller.dart' show VendorOption;

class EditBioInventoryController extends GetxController {
  final String bioId;
  EditBioInventoryController({required this.bioId});

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
  final existingImageUrl = ''.obs;

  final isLoadingDetail = true.obs;
  final isLoadingVendors = true.obs;
  final isSaving = false.obs;
  final vendors = <VendorOption>[].obs;

  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      final results = await Future.wait([
        _repo.getVendors(token),
        _repo.getBioDetail(token, bioId),
      ]);

      final vendorList = _asList(results[0]['data']);
      vendors.assignAll(vendorList.map((e) {
        final m = e as Map<String, dynamic>;
        return VendorOption(
          id: m['_id']?.toString() ?? '',
          name: m['vendorName']?.toString() ?? m['name']?.toString() ?? '',
        );
      }));

      _prefill(results[1]['data'] as Map<String, dynamic>? ?? {});
    } catch (_) {
    } finally {
      isLoadingVendors.value = false;
      isLoadingDetail.value = false;
    }
  }

  void _prefill(Map<String, dynamic> data) {
    itemNameController.text = data['itemName']?.toString() ?? '';
    lotNumberController.text = data['lotNumber']?.toString() ?? '';
    quantityController.text = data['quantity']?.toString() ?? '';
    locationController.text = data['location']?.toString() ?? '';
    additionalNotesController.text = data['notes']?.toString() ?? '';
    existingImageUrl.value = data['initialPhoto']?.toString() ?? '';

    final raw = data['expiryDate']?.toString() ?? '';
    if (raw.isNotEmpty) {
      try {
        expiryDate.value = DateTime.parse(raw).toLocal();
      } catch (_) {}
    }

    // Resolve vendor - could be a name string or populated object
    final vendorRaw = data['vendor'];
    String vendorName = '';
    String vendorId = '';
    if (vendorRaw is Map) {
      vendorId = vendorRaw['_id']?.toString() ?? '';
      vendorName = vendorRaw['vendorName']?.toString() ?? vendorRaw['name']?.toString() ?? '';
    } else {
      vendorName = vendorRaw?.toString() ?? '';
    }
    final match = vendors.where((v) => v.id == vendorId || v.name == vendorName);
    if (match.isNotEmpty) {
      selectedVendorId.value = match.first.id;
      selectedVendorName.value = match.first.name;
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

  Future<void> pickExpiryDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: expiryDate.value ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1AC8DB),
            onPrimary: Colors.white,
            surface: Color(0xFF1E2121),
            onSurface: Color(0xFFD4D4D4),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) expiryDate.value = picked;
  }

  String get expiryDateDisplay =>
      expiryDate.value != null ? DateFormat('MM/dd/yyyy').format(expiryDate.value!) : '';

  String get expiryDateApi =>
      expiryDate.value != null ? DateFormat('yyyy-MM-dd').format(expiryDate.value!) : '';

  Future<void> pickPhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) selectedPhoto.value = File(image.path);
  }

  Future<bool> saveUpdate() async {
    final itemName = itemNameController.text.trim();
    if (itemName.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter item name');
      return false;
    }
    try {
      isSaving.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.updateBio(
        token,
        bioId,
        itemName: itemName,
        lotNumber: lotNumberController.text.trim().isNotEmpty ? lotNumberController.text.trim() : null,
        quantity: quantityController.text.trim().isNotEmpty ? quantityController.text.trim() : null,
        location: locationController.text.trim().isNotEmpty ? locationController.text.trim() : null,
        vendorId: selectedVendorId.value,
        expiryDate: expiryDateApi.isNotEmpty ? expiryDateApi : null,
        additionalNotes: additionalNotesController.text.trim().isNotEmpty
            ? additionalNotesController.text.trim()
            : null,
        photo: selectedPhoto.value,
      );
      return true;
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to update bio inventory';
      ToastMessageHelper.showErrorMessage(msg);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteBio() async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      await _repo.deleteBio(token, bioId);
      return true;
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to delete bio inventory';
      ToastMessageHelper.showErrorMessage(msg);
      return false;
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
