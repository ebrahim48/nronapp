import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import '../model/implant_model.dart';
import 'add_implant_controller.dart'; // reuse FacilityOption & VendorOption

class UpdateImplantController extends GetxController {
  final ImplantModel implant;

  UpdateImplantController({required this.implant});

  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController recipientEmailController;
  late final TextEditingController serialNumberController;
  late final TextEditingController inboundNotesController;
  late final TextEditingController brokenNotesController;

  final selectedFacilityId = Rxn<String>();
  final selectedFacilityName = Rxn<String>();
  final selectedVendorId = Rxn<String>();
  final selectedVendorName = Rxn<String>();
  final selectedSystemType = Rxn<String>();

  final isLoadingFacilities = true.obs;
  final isLoadingVendors = true.obs;
  final isSaving = false.obs;

  final facilities = <FacilityOption>[].obs;
  final vendors = <VendorOption>[].obs;

  final newInboundImages = <File>[].obs;
  final newBrokenImages = <File>[].obs;
  final _picker = ImagePicker();

  final systemTypes = <String>[
    'Orthopedic System',
    'Hip System',
    'Spine System',
    'Knee System',
  ];

  @override
  void onInit() {
    super.onInit();
    // Pre-fill from existing implant
    recipientEmailController = TextEditingController(text: implant.recipientEmail);
    serialNumberController = TextEditingController(text: implant.serialNumber);
    inboundNotesController = TextEditingController(text: implant.inboundNotes ?? '');
    brokenNotesController = TextEditingController(text: implant.brokenNotes ?? '');

    selectedFacilityId.value = implant.facilityId;
    selectedFacilityName.value = implant.facility.isNotEmpty ? implant.facility : null;
    selectedVendorId.value = implant.vendorId;
    selectedVendorName.value = implant.vendor.isNotEmpty ? implant.vendor : null;
    selectedSystemType.value = implant.systemType.isNotEmpty ? implant.systemType : null;

    _loadFacilities();
    _loadVendors();
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
      // Restore selected facility from list
      if (selectedFacilityId.value != null) {
        final match = facilities.where((f) => f.id == selectedFacilityId.value);
        if (match.isNotEmpty) selectedFacilityName.value = match.first.name;
      }
    } catch (_) {
    } finally {
      isLoadingFacilities.value = false;
    }
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
      // Restore selected vendor from list
      if (selectedVendorId.value != null) {
        final match = vendors.where((v) => v.id == selectedVendorId.value);
        if (match.isNotEmpty) selectedVendorName.value = match.first.name;
      }
    } catch (_) {
    } finally {
      isLoadingVendors.value = false;
    }
  }

  void selectFacility(String id, String name) {
    selectedFacilityId.value = id;
    selectedFacilityName.value = name;
  }

  void selectVendor(String id, String name) {
    selectedVendorId.value = id;
    selectedVendorName.value = name;
  }

  void setSystemType(String? v) => selectedSystemType.value = v;

  Future<void> pickInboundImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) newInboundImages.add(File(picked.path));
  }

  Future<void> pickBrokenImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) newBrokenImages.add(File(picked.path));
  }

  Future<ImageSource?> _showSourceDialog(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1E2427),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              title: const Text('Camera',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
              title: const Text('Gallery',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void removeNewInboundImage(int index) => newInboundImages.removeAt(index);
  void removeNewBrokenImage(int index) => newBrokenImages.removeAt(index);

  Future<bool> saveUpdate() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    final facilityId = selectedFacilityId.value;
    if (facilityId == null || facilityId.isEmpty) return false;
    final systemType = selectedSystemType.value;
    if (systemType == null || systemType.isEmpty) return false;

    try {
      isSaving.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.updateImplant(
        token,
        implant.id,
        facilityId: facilityId,
        serialNumber: serialNumberController.text.trim(),
        systemType: systemType,
        vendor: selectedVendorName.value ?? '',
        recipientEmail: recipientEmailController.text.trim(),
        additionalNotes: inboundNotesController.text.trim(),
        brokenNotes: brokenNotesController.text.trim(),
        inboundImages: newInboundImages.isEmpty ? null : newInboundImages.toList(),
        brokenImages: newBrokenImages.isEmpty ? null : newBrokenImages.toList(),
      );
      ToastMessageHelper.showSuccessMessage('Implant updated successfully');
      return true;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to update implant');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    recipientEmailController.dispose();
    serialNumberController.dispose();
    inboundNotesController.dispose();
    brokenNotesController.dispose();
    super.onClose();
  }
}
