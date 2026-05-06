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
import 'new_tray_controller.dart' show DropdownOption;

class EditTrayController extends GetxController {
  final String trayId;
  EditTrayController({required this.trayId});

  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final trayTitleController = TextEditingController();
  final systemTypeController = TextEditingController();
  final returnDateController = TextEditingController();
  final additionalNotesController = TextEditingController();

  final selectedFacilityId = ''.obs;
  final selectedFacilityName = ''.obs;
  final selectedVendorId = ''.obs;
  final selectedVendorName = ''.obs;

  final inventoryModelIndex = 0.obs;
  final statusIndex = 0.obs;

  final isLoadingDropdowns = true.obs;
  final isLoadingDetail = true.obs;
  final isSaving = false.obs;

  final facilities = <FacilityOption>[].obs;
  final vendors = <DropdownOption>[].obs;

  final selectedPhoto = Rxn<File>();
  final existingImageUrl = ''.obs;
  final _picker = ImagePicker();

  static const _inventoryModels = ['loaner', 'consignment'];
  static const _statusOptions = ['downRack', 'wrapped', 'Warehouse'];
  static const inventoryModelLabels = ['Loaner', 'Consignment'];
  static const statusLabels = ['Down Rack', 'Wrapped', 'Warehouse'];

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      isLoadingDropdowns.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final results = await Future.wait([
        _repo.getFacilities(token),
        _repo.getVendors(token),
        _repo.getTrayDetail(token, trayId),
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

      _prefill(results[2]['data'] as Map<String, dynamic>? ?? {});
    } catch (_) {
    } finally {
      isLoadingDropdowns.value = false;
      isLoadingDetail.value = false;
    }
  }

  void _prefill(Map<String, dynamic> data) {
    trayTitleController.text = data['title']?.toString() ?? '';
    systemTypeController.text = data['systemType']?.toString() ?? '';
    additionalNotesController.text = data['notes']?.toString() ?? '';
    existingImageUrl.value = data['initialPhoto']?.toString() ?? '';

    final raw = data['returnDate']?.toString() ?? '';
    if (raw.isNotEmpty) {
      try {
        final dt = DateTime.parse(raw).toLocal();
        returnDateController.text =
            '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
      } catch (_) {
        returnDateController.text = raw;
      }
    }

    final facilityMap = data['facility'] is Map ? data['facility'] as Map<String, dynamic> : <String, dynamic>{};
    final facilityId = facilityMap['_id']?.toString() ?? '';
    final facilityName = facilityMap['facilityName']?.toString() ?? facilityMap['name']?.toString() ?? '';
    if (facilityId.isNotEmpty) {
      selectedFacilityId.value = facilityId;
      selectedFacilityName.value = facilityName;
    }

    final vendorRaw = data['vendor'];
    String vendorName = '';
    String vendorId = '';
    if (vendorRaw is Map) {
      vendorId = vendorRaw['_id']?.toString() ?? '';
      vendorName = vendorRaw['vendorName']?.toString() ?? vendorRaw['name']?.toString() ?? '';
    } else {
      vendorName = vendorRaw?.toString() ?? '';
    }
    final vendorMatch = vendors.where((v) => v.id == vendorId || v.name == vendorName);
    if (vendorMatch.isNotEmpty) {
      selectedVendorId.value = vendorMatch.first.id;
      selectedVendorName.value = vendorMatch.first.name;
    }

    final inv = data['inventory']?.toString().toLowerCase() ?? '';
    final invIdx = _inventoryModels.indexWhere((m) => m.toLowerCase() == inv);
    inventoryModelIndex.value = invIdx >= 0 ? invIdx : 0;

    final st = data['status']?.toString() ?? '';
    final stIdx = _statusOptions.indexWhere((s) => s.toLowerCase() == st.toLowerCase());
    statusIndex.value = stIdx >= 0 ? stIdx : 0;
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

  List<String> get facilityOptions => facilities.map((f) => f.name).toList();
  List<String> get vendorOptions => vendors.map((v) => v.name).toList();

  void selectFacilityByName(String? name) {
    if (name == null) return;
    final match = facilities.where((f) => f.name == name);
    if (match.isNotEmpty) {
      selectedFacilityId.value = match.first.id;
      selectedFacilityName.value = match.first.name;
    }
  }

  void selectVendorByName(String? name) {
    if (name == null) return;
    final match = vendors.where((v) => v.name == name);
    if (match.isNotEmpty) {
      selectedVendorId.value = match.first.id;
      selectedVendorName.value = match.first.name;
    }
  }

  void selectInventoryModel(int i) => inventoryModelIndex.value = i;
  void selectStatus(int i) => statusIndex.value = i;

  Future<void> pickPhoto(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1E2427),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
        ]),
      ),
    );
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) selectedPhoto.value = File(picked.path);
  }

  void pickReturnDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: Color(0xFF00C5DA))),
        child: child!,
      ),
    );
    if (picked != null) {
      returnDateController.text =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<bool> saveUpdate() async {
    if (trayTitleController.text.trim().isEmpty) return false;
    if (selectedFacilityId.value.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select a facility');
      return false;
    }
    try {
      isSaving.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.updateTray(
        token,
        trayId,
        title: trayTitleController.text.trim(),
        facilityId: selectedFacilityId.value,
        vendorId: selectedVendorId.value.isNotEmpty ? selectedVendorId.value : null,
        systemType: systemTypeController.text.trim().isNotEmpty ? systemTypeController.text.trim() : null,
        inventoryModel: _inventoryModels[inventoryModelIndex.value],
        status: _statusOptions[statusIndex.value],
        returnDate: returnDateController.text.trim().isNotEmpty ? returnDateController.text.trim() : null,
        notes: additionalNotesController.text.trim().isNotEmpty ? additionalNotesController.text.trim() : null,
        thumbnail: selectedPhoto.value,
      );
      return true;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to update tray');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteTray() async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      await _repo.deleteTray(token, trayId);
      return true;
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to delete tray');
      return false;
    }
  }

  @override
  void onClose() {
    trayTitleController.dispose();
    systemTypeController.dispose();
    returnDateController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}
