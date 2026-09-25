import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import 'add_bio_inventory_controller.dart' show VendorOption;

class MissingInstrumentController extends GetxController {
  String trayId = '';

  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final instrumentNameController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedVendorId = Rxn<String>();
  final selectedVendorName = Rxn<String>();
  final issueType = 'missing'.obs;
  final instrumentPhoto = Rxn<File>();
  final isSubmitting = false.obs;
  final isLoadingVendors = false.obs;
  final vendors = <VendorOption>[].obs;

  final ImagePicker _picker = ImagePicker();

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
    } catch (_) {} finally {
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

  List<String> get vendorOptions => vendors.map((v) => v.name).toList();

  void selectVendor(String? name) {
    if (name == null || name.isEmpty) {
      selectedVendorId.value = null;
      selectedVendorName.value = null;
      return;
    }
    final match = vendors.where((v) => v.name == name);
    if (match.isNotEmpty) {
      selectedVendorId.value = match.first.id;
      selectedVendorName.value = match.first.name;
    }
  }

  void setIssueType(String type) => issueType.value = type;

  Future<void> pickPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) instrumentPhoto.value = File(image.path);
    } catch (_) {}
  }

  void removePhoto() => instrumentPhoto.value = null;

  Future<String?> submitReport() async {
    final name = instrumentNameController.text.trim();
    if (name.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter instrument name');
      return null;
    }
    if (trayId.isEmpty) {
      ToastMessageHelper.showErrorMessage('Tray ID is missing');
      return null;
    }
    try {
      isSubmitting.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.createMissingInstrument(
        token,
        trayId: trayId,
        instrumentName: name,
        issueType: issueType.value,
        vendorId: selectedVendorId.value,
        descriptionAndNotes: descriptionController.text.trim().isNotEmpty
            ? descriptionController.text.trim()
            : null,
        photo: instrumentPhoto.value,
      );
      // Return the created missing instrument _id
      final data = res['data'];
      final id = (data is Map ? data['_id']?.toString() : null) ?? '';
      return id.isNotEmpty ? id : null;
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to submit report';
      ToastMessageHelper.showErrorMessage(msg);
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    instrumentNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
