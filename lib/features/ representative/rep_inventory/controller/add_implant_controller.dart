import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import '../model/implant_model.dart';

class FacilityOption {
  final String id;
  final String name;
  const FacilityOption({required this.id, required this.name});
}

class VendorOption {
  final String id;
  final String name;
  const VendorOption({required this.id, required this.name});
}

class AddImplantController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  /// When non-null, the controller is in edit mode.
  final ImplantModel? editImplant;

  AddImplantController({this.editImplant});

  bool get isEditMode => editImplant != null;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final recipientEmailController = TextEditingController();
  final serial1Controller = TextEditingController();
  final serial2Controller = TextEditingController();
  final additionalNotesController = TextEditingController();
  final brokenNotesController = TextEditingController();

  final selectedFacilityId = Rxn<String>();
  final selectedFacilityName = Rxn<String>();
  final selectedVendorId = Rxn<String>();
  final selectedVendorName = Rxn<String>();
  final selectedSystemType = Rxn<String>();
  final selectedSystemSubType = Rxn<String>();

  final isLoadingFacilities = true.obs;
  final isLoadingVendors = true.obs;
  final isSaving = false.obs;
  final facilities = <FacilityOption>[].obs;
  final vendors = <VendorOption>[].obs;

  final inboundImages = <File>[].obs;
  final brokenImages = <File>[].obs;
  final _picker = ImagePicker();

  final systemTypes = <String>[
    'Orthopedic System',
    'Hip System',
    'Spine System',
    'Knee System',
  ];

  final systemSubTypes = <String>[
    'Primary',
    'Revision',
    'Trauma',
    'Total',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadFacilities();
    _loadVendors();
  }

  void _prefillFromImplant() {
    final imp = editImplant;
    if (imp == null) return;
    recipientEmailController.text = imp.recipientEmail;
    serial1Controller.text = imp.serialNumber;
    additionalNotesController.text = imp.inboundNotes ?? '';
    brokenNotesController.text = imp.brokenNotes ?? '';
    selectedSystemType.value = imp.systemType.isNotEmpty ? imp.systemType : null;
    selectedFacilityId.value = imp.facilityId;
    selectedFacilityName.value = imp.facility.isNotEmpty ? imp.facility : null;
    selectedVendorId.value = imp.vendorId;
    selectedVendorName.value = imp.vendor.isNotEmpty ? imp.vendor : null;
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
      // Restore selection after list loads
      if (isEditMode && selectedFacilityId.value != null) {
        final match = facilities.where((f) => f.id == selectedFacilityId.value);
        if (match.isNotEmpty) selectedFacilityName.value = match.first.name;
      }
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
      // Restore selection after list loads
      if (isEditMode && selectedVendorId.value != null) {
        final match = vendors.where((v) => v.id == selectedVendorId.value);
        if (match.isNotEmpty) selectedVendorName.value = match.first.name;
      }
      // Pre-fill text fields once vendors are loaded (needs to happen after init)
      if (isEditMode) _prefillFromImplant();
    } catch (_) {
      // silently fail
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
  void setSystemSubType(String? v) => selectedSystemSubType.value = v;

  Future<void> pickInboundImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) inboundImages.add(File(picked.path));
  }

  Future<void> pickBrokenImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) brokenImages.add(File(picked.path));
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
              title: const Text('Camera', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
              title: const Text('Gallery', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void removeInboundImage(int index) => inboundImages.removeAt(index);
  void removeBrokenImage(int index) => brokenImages.removeAt(index);

  Future<bool> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    final facilityId = selectedFacilityId.value;
    if (facilityId == null || facilityId.isEmpty) return false;
    final systemType = selectedSystemType.value;
    if (systemType == null || systemType.isEmpty) return false;
    try {
      isSaving.value = true;
      final token = await PrefsHelper.getString('auth_token');
      if (isEditMode) {
        await _repo.updateImplant(
          token,
          editImplant!.id,
          facilityId: facilityId,
          serialNumber: serial1Controller.text.trim(),
          systemType: systemType,
          vendor: selectedVendorName.value ?? '',
          recipientEmail: recipientEmailController.text.trim(),
          additionalNotes: additionalNotesController.text.trim(),
          brokenNotes: brokenNotesController.text.trim(),
          inboundImages: inboundImages.isEmpty ? null : inboundImages.toList(),
          brokenImages: brokenImages.isEmpty ? null : brokenImages.toList(),
        );
      } else {
        await _repo.createImplant(
          token,
          facilityId: facilityId,
          serialNumber: serial1Controller.text.trim(),
          systemType: systemType,
          material: selectedSystemSubType.value,
          vendor: selectedVendorName.value ?? '',
          recipientEmail: recipientEmailController.text.trim(),
          additionalNotes: additionalNotesController.text.trim(),
          brokenNotes: brokenNotesController.text.trim(),
          inboundImages: inboundImages.isEmpty ? null : inboundImages.toList(),
          brokenImages: brokenImages.isEmpty ? null : brokenImages.toList(),
        );
      }
      _clear();
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void _clear() {
    recipientEmailController.clear();
    serial1Controller.clear();
    serial2Controller.clear();
    additionalNotesController.clear();
    brokenNotesController.clear();
    selectedFacilityId.value = null;
    selectedFacilityName.value = null;
    selectedVendorId.value = null;
    selectedVendorName.value = null;
    selectedSystemType.value = null;
    selectedSystemSubType.value = null;
    inboundImages.clear();
    brokenImages.clear();
  }

  @override
  void onClose() {
    recipientEmailController.dispose();
    serial1Controller.dispose();
    serial2Controller.dispose();
    additionalNotesController.dispose();
    brokenNotesController.dispose();
    super.onClose();
  }
}
