import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../purchaseorder/data/repositories/purchase_order_repository.dart';
import '../../purchaseorder/model/purchase_order_model.dart';
import 'scan_session_controller.dart';

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
    final session = Get.put(ScanSessionController());
    ever(session.items, _onScannedItemsChanged);
    _fetchDropdowns();
  }

  void _onScannedItemsChanged(List<ScannedItem> items) {
    bulkProducts.assignAll(
      items.map((i) => BulkProductItem(
        iconPath: 'assets/icons/medicalimplants.svg',
        productId: i.productId.isNotEmpty ? i.productId : i.serial,
        productName: i.name,
        detail: i.serial.length > 18
            ? 'S/N: ${i.serial.substring(0, 18)}...'
            : 'S/N: ${i.serial}',
        price: i.price,
        listOfItems: [i.serial],
      )),
    );
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

  void showAttachOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (_) => _BulkAttachOptionsSheet(
        onPickPdf: uploadPDF,
        onPickCamera: _pickFromCamera,
        onPickGallery: _pickFromGallery,
      ),
    );
  }

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

  Future<void> _pickFromCamera() async {
    try {
      final photo = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 85);
      if (photo != null) attachedDocs.add(File(photo.path));
    } catch (_) {
      // Camera not available — fall back to gallery silently
      await _pickFromGallery();
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null) {
        for (final f in result.files) {
          if (f.path != null) attachedDocs.add(File(f.path!));
        }
      }
    } catch (_) {
      Get.snackbar('Error', 'Could not open gallery.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E2121),
          colorText: Colors.white);
    }
  }

  /// Kept for backward compatibility — now opens the full attach sheet.
  void takePhoto(BuildContext context) => showAttachOptions(context);

  Future<void> saveOrder(BuildContext context) => _submit(context);

  Future<void> continueOrder(BuildContext context) => _submit(context);

  Future<void> _submit(BuildContext context) async {
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
        _clearForm();
        if (context.mounted) {
          ToastMessageHelper.showSuccessMessage('Purchase order created successfully.');
          context.go(AppRoutes.purchaseOrderScreen);
        }
      } else {
        final msg = res['message']?.toString() ?? 'Failed to create order';
        ToastMessageHelper.showErrorMessage(msg);
      }
    } on NoInternetException {
      ToastMessageHelper.showErrorMessage('No internet connection.');
    } on ServerException catch (e) {
      ToastMessageHelper.showErrorMessage(e.message);
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSubmitting.value = false;
    }
  }

  void _clearForm() {
    patientIdController.clear();
    surgeonNameController.clear();
    facilityController.clear();
    facilityEmailController.clear();
    procedureDateController.clear();
    poNumberController.text = 'PO-0000';
    vendorNameController.clear();
    vendorEmailController.clear();
    additionalNotesController.clear();
    selectedStatus.value = 'open';
    sendVendorEmail.value = true;
    _selectedSurgeryId = '';
    _selectedFacilityId = '';
    _selectedVendorId = '';
    attachedDocs.clear();
    bulkProducts.clear();
    if (Get.isRegistered<ScanSessionController>()) {
      Get.find<ScanSessionController>().clear();
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
    // Clean up scan session when leaving purchase order creation
    if (Get.isRegistered<ScanSessionController>()) {
      Get.delete<ScanSessionController>();
    }
    super.onClose();
  }
}

// ── Bulk Attach Options Bottom Sheet ─────────────────────────────────────────
class _BulkAttachOptionsSheet extends StatelessWidget {
  final VoidCallback onPickPdf;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;

  const _BulkAttachOptionsSheet({
    required this.onPickPdf,
    required this.onPickCamera,
    required this.onPickGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: 'Attach Document',
            fontsize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: 'Choose how you want to attach your PO document',
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 24.h),
          _BulkOptionTile(
            iconPath: 'assets/icons/document.svg',
            title: 'Browse Files',
            subtitle: 'Upload PDF or Word document',
            onTap: () {
              Navigator.pop(context);
              onPickPdf();
            },
          ),
          SizedBox(height: 12.h),
          _BulkOptionTile(
            iconPath: 'assets/icons/camera.svg',
            title: 'Camera',
            subtitle: 'Take a photo of your document',
            onTap: () {
              Navigator.pop(context);
              onPickCamera();
            },
          ),
          SizedBox(height: 12.h),
          _BulkOptionTile(
            iconPath: 'assets/icons/scanitem.svg',
            title: 'Gallery',
            subtitle: 'Choose from your photo gallery',
            onTap: () {
              Navigator.pop(context);
              onPickGallery();
            },
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _BulkOptionTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BulkOptionTile({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0x1A4A4A4A),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: const Color(0xFF332F2F),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: subtitle,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/next.svg',
              width: 14.r,
              height: 14.r,
              colorFilter: const ColorFilter.mode(
                AppColors.secondaryTextColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
