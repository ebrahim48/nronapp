import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../purchaseorder/data/repositories/purchase_order_repository.dart';
import '../../purchaseorder/model/purchase_order_model.dart';

class UpdatePurchaseController extends GetxController {
  final String orderId;
  UpdatePurchaseController(this.orderId);

  final _repo = PurchaseOrderRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // Step indicator
  final currentStep = 2.obs;
  final totalSteps = 2.obs;

  // Loading state
  final isLoadingDetail = true.obs;
  final isLoadingDropdowns = false.obs;
  final isSubmitting = false.obs;
  final isPickingFile = false.obs;

  // Form fields
  final selectedStatus = 'open'.obs;
  final patientIdController = TextEditingController();
  final surgeonNameController = TextEditingController();
  final facilityController = TextEditingController();
  final facilityEmailController = TextEditingController();
  final procedureDateController = TextEditingController();
  final poNumberController = TextEditingController(text: 'PO-0000');
  final vendorNameController = TextEditingController();
  final vendorEmailController = TextEditingController();
  final additionalNotesController = TextEditingController();
  final sendVendorEmail = true.obs;

  // Attached new documents
  final attachedDocs = <File>[].obs;

  // Dropdowns
  final surgeryList = <PoDropdownItem>[].obs;
  final facilityList = <PoDropdownItem>[].obs;
  final vendorList = <PoDropdownItem>[].obs;

  String _selectedSurgeryId = '';
  String _selectedFacilityId = '';
  String _selectedVendorId = '';

  final statusOptions = ['open', 'lost', 'complete'];

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    isLoadingDetail.value = true;
    isLoadingDropdowns.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final results = await Future.wait([
        _repo.getDetail(token, orderId),
        _repo.getSurgeries(token),
        _repo.getFacilities(token),
        _repo.getVendors(token),
      ]);

      // Parse dropdowns first
      if (results[1]['success'] == true) {
        surgeryList.value = _parseList(results[1]['data'])
            .map((e) {
              final info = (e as Map<String, dynamic>)['info'];
              final name = info is Map
                  ? info['fullName']?.toString() ?? ''
                  : e['fullName']?.toString() ?? '';
              return PoDropdownItem(id: e['_id']?.toString() ?? '', name: name);
            })
            .where((d) => d.name.isNotEmpty)
            .toList();
      }
      if (results[2]['success'] == true) {
        facilityList.value = _parseList(results[2]['data'])
            .map((e) => PoDropdownItem(
                  id: (e as Map<String, dynamic>)['_id']?.toString() ?? '',
                  name: e['facilityName']?.toString() ?? e['name']?.toString() ?? '',
                ))
            .where((d) => d.name.isNotEmpty)
            .toList();
      }
      if (results[3]['success'] == true) {
        vendorList.value = _parseList(results[3]['data'])
            .map((e) => PoDropdownItem(
                  id: (e as Map<String, dynamic>)['_id']?.toString() ?? '',
                  name: e['name']?.toString() ?? '',
                ))
            .where((d) => d.name.isNotEmpty)
            .toList();
      }

      // Pre-populate form from detail
      final detailData = results[0];
      if (detailData['success'] == true) {
        final detail = PurchaseOrderDetailModel.fromJson(
          (detailData['data'] is Map ? detailData['data'] : detailData['data']?[0]) as Map<String, dynamic>? ?? {},
        );
        _prefill(detail);
      }
    } catch (_) {
    } finally {
      isLoadingDetail.value = false;
      isLoadingDropdowns.value = false;
    }
  }

  void _prefill(PurchaseOrderDetailModel d) {
    selectedStatus.value =
        statusOptions.contains(d.status) ? d.status : 'open';
    patientIdController.text = d.patientId;
    poNumberController.text = d.purchaseOrderNumber;
    procedureDateController.text = d.procedureDate;
    additionalNotesController.text = d.notes;
    facilityEmailController.text = d.facilityEmail;
    vendorEmailController.text = d.vendorEmail;

    if (d.surgeryId.isNotEmpty) {
      _selectedSurgeryId = d.surgeryId;
      surgeonNameController.text = d.surgeonName;
    }
    if (d.facilityId.isNotEmpty) {
      _selectedFacilityId = d.facilityId;
      facilityController.text = d.facilityName;
    }
    if (d.vendorId.isNotEmpty) {
      _selectedVendorId = d.vendorId;
      vendorNameController.text = d.vendorName;
    }
  }

  List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map) return (data['results'] ?? data['data'] ?? []) as List<dynamic>;
    return [];
  }

  void onSurgerySelected(int index, String value) {
    if (index < surgeryList.length) _selectedSurgeryId = surgeryList[index].id;
  }

  void onFacilitySelected(int index, String value) {
    if (index < facilityList.length) _selectedFacilityId = facilityList[index].id;
  }

  void onVendorSelected(int index, String value) {
    if (index < vendorList.length) _selectedVendorId = vendorList[index].id;
  }

  void toggleVendorEmail(bool val) => sendVendorEmail.value = val;
  void deleteDoc(int index) => attachedDocs.removeAt(index);

  void showAttachOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => _buildAttachSheet(context),
    );
  }

  Widget _buildAttachSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Attach Document',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 20),
          _attachOption(context, 'Browse Files', Icons.insert_drive_file_outlined, _pickPdf),
          const SizedBox(height: 10),
          _attachOption(context, 'Camera', Icons.camera_alt_outlined, _pickFromCamera),
          const SizedBox(height: 10),
          _attachOption(context, 'Gallery', Icons.photo_library_outlined, _pickFromGallery),
        ],
      ),
    );
  }

  Widget _attachOption(BuildContext ctx, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0x1A4A4A4A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00C2CB), size: 20),
            const SizedBox(width: 14),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPdf() async {
    isPickingFile.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: true,
      );
      if (result != null) {
        for (final f in result.files) {
          if (f.path != null) attachedDocs.add(File(f.path!));
        }
      }
    } finally {
      isPickingFile.value = false;
    }
  }

  Future<void> _pickFromCamera() async {
    isPickingFile.value = true;
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85);
      if (picked != null) attachedDocs.add(File(picked.path));
    } finally {
      isPickingFile.value = false;
    }
  }

  Future<void> _pickFromGallery() async {
    isPickingFile.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null) {
        for (final f in result.files) {
          if (f.path != null) attachedDocs.add(File(f.path!));
        }
      }
    } finally {
      isPickingFile.value = false;
    }
  }

  Future<void> saveOrder(BuildContext context) => _submit(context, navigate: false);
  Future<void> continueOrder(BuildContext context) => _submit(context, navigate: true);

  Future<void> _submit(BuildContext context, {required bool navigate}) async {
    if (!_validate()) return;
    isSubmitting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.update(
        token,
        orderId,
        status: selectedStatus.value,
        patientId: patientIdController.text.trim(),
        surgeryId: _selectedSurgeryId,
        facilityId: _selectedFacilityId,
        procedureDate: procedureDateController.text.trim(),
        purchaseOrderNumber: poNumberController.text.trim(),
        vendorId: _selectedVendorId.isNotEmpty ? _selectedVendorId : null,
        notes: additionalNotesController.text.trim(),
        docs: attachedDocs.isNotEmpty ? attachedDocs : null,
      );
      if (res['success'] == true) {
        if (navigate && context.mounted) {
          context.pushNamed(AppRoutes.reviewSendPoScreen);
        } else {
          ToastMessageHelper.showToastMessage('Order updated successfully.', title: 'Success');
          if (context.mounted) context.goNamed(AppRoutes.purchaseOrderScreen);
        }
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _validate() {
    if (patientIdController.text.trim().isEmpty) {
      ToastMessageHelper.showToastMessage('Patient ID is required.', title: 'Validation');
      return false;
    }
    if (_selectedSurgeryId.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a surgeon.', title: 'Validation');
      return false;
    }
    if (_selectedFacilityId.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a facility.', title: 'Validation');
      return false;
    }
    if (procedureDateController.text.trim().isEmpty) {
      ToastMessageHelper.showToastMessage('Procedure date is required.', title: 'Validation');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    patientIdController.dispose();
    surgeonNameController.dispose();
    facilityController.dispose();
    facilityEmailController.dispose();
    procedureDateController.dispose();
    poNumberController.dispose();
    vendorNameController.dispose();
    vendorEmailController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}
