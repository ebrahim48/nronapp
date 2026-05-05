import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../purchaseorder/data/repositories/purchase_order_repository.dart';
import '../../purchaseorder/model/purchase_order_model.dart';

class BulkProductItem {
  final String iconPath;
  final String productId;
  final String productName;
  final String detail;
  final String price;
  final List<String> listOfItems;

  const BulkProductItem({
    required this.iconPath,
    required this.productId,
    required this.productName,
    required this.detail,
    required this.price,
    this.listOfItems = const [],
  });
}

class BulkPurchaseController extends GetxController {
  final _repo = PurchaseOrderRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // Step indicator
  final currentStep = 2.obs;
  final totalSteps = 2.obs;

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

  // Send vendor email toggle
  final sendVendorEmail = true.obs;

  // Dropdowns
  final surgeryList = <PoDropdownItem>[].obs;
  final facilityList = <PoDropdownItem>[].obs;
  final vendorList = <PoDropdownItem>[].obs;
  final isLoadingDropdowns = false.obs;

  String _selectedSurgeryId = '';
  String _selectedFacilityId = '';
  String _selectedVendorId = '';

  // Bulk products list
  final bulkProducts = <BulkProductItem>[].obs;

  // Attached documents
  final attachedDocs = <File>[].obs;

  final isSubmitting = false.obs;
  final statusOptions = ['open', 'lost', 'complete'];

  @override
  void onInit() {
    super.onInit();
    _fetchDropdowns();
  }

  Future<void> _fetchDropdowns() async {
    isLoadingDropdowns.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final results = await Future.wait([
        _repo.getSurgeries(token),
        _repo.getFacilities(token),
        _repo.getVendors(token),
      ]);

      if (results[0]['success'] == true) {
        surgeryList.value = _parseList(results[0]['data'])
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

      if (results[1]['success'] == true) {
        facilityList.value = _parseList(results[1]['data'])
            .map((e) => PoDropdownItem(
                  id: (e as Map<String, dynamic>)['_id']?.toString() ?? '',
                  name: e['facilityName']?.toString() ??
                      e['name']?.toString() ??
                      '',
                ))
            .where((d) => d.name.isNotEmpty)
            .toList();
      }

      if (results[2]['success'] == true) {
        vendorList.value = _parseList(results[2]['data'])
            .map((e) => PoDropdownItem(
                  id: (e as Map<String, dynamic>)['_id']?.toString() ?? '',
                  name: e['name']?.toString() ?? '',
                ))
            .where((d) => d.name.isNotEmpty)
            .toList();
      }
    } catch (_) {
    } finally {
      isLoadingDropdowns.value = false;
    }
  }

  List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      return (data['results'] ?? data['data'] ?? []) as List<dynamic>;
    }
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

  void removeProduct(int index) => bulkProducts.removeAt(index);

  void addProduct(BuildContext context) {
    context.pushNamed(AppRoutes.addProductScreen);
  }

  void deleteDoc(int index) => attachedDocs.removeAt(index);

  final _picker = ImagePicker();

  Future<void> uploadPDF() async {
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
    } catch (_) {
      Get.snackbar('Error', 'Could not pick file.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E2121),
          colorText: Colors.white);
    }
  }

  Future<void> takePhoto() async {
    try {
      final photo = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 85);
      if (photo != null) attachedDocs.add(File(photo.path));
    } catch (_) {
      Get.snackbar('Error', 'Could not open camera.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E2121),
          colorText: Colors.white);
    }
  }

  Future<void> saveOrder(BuildContext context) => _submit(context, navigate: false);

  Future<void> continueOrder(BuildContext context) => _submit(context, navigate: true);

  Future<void> _submit(BuildContext context, {required bool navigate}) async {
    if (!_validate()) return;
    isSubmitting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final products = bulkProducts
          .map((p) => {
                'productId': p.productId,
                'productName': p.productName,
                'listOfItems': p.listOfItems.map((s) => {'slName': s}).toList(),
              })
          .toList();
      final res = await _repo.create(
        token,
        orderType: 'bulkBioOrder',
        status: selectedStatus.value,
        patientId: patientIdController.text.trim(),
        surgeryId: _selectedSurgeryId,
        facilityId: _selectedFacilityId,
        procedureDate: procedureDateController.text.trim(),
        purchaseOrderNumber: poNumberController.text.trim(),
        totalAmount: 0,
        vendorId: _selectedVendorId.isNotEmpty ? _selectedVendorId : null,
        notes: additionalNotesController.text.trim(),
        products: products.isNotEmpty ? products : null,
        docs: attachedDocs.isNotEmpty ? attachedDocs : null,
      );
      if (res['success'] == true) {
        if (navigate && context.mounted) {
          context.pushNamed(AppRoutes.reviewSendPoScreen);
        } else {
          ToastMessageHelper.showToastMessage('Order saved successfully.',
              title: 'Success');
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
      ToastMessageHelper.showToastMessage('Patient ID is required.',
          title: 'Validation');
      return false;
    }
    if (_selectedSurgeryId.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a surgeon.',
          title: 'Validation');
      return false;
    }
    if (_selectedFacilityId.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a facility.',
          title: 'Validation');
      return false;
    }
    if (procedureDateController.text.trim().isEmpty) {
      ToastMessageHelper.showToastMessage('Procedure date is required.',
          title: 'Validation');
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
