import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../purchaseorder/data/repositories/purchase_order_repository.dart';
import '../../purchaseorder/model/purchase_order_model.dart';
import 'review_send_po_controller.dart';

class CreatePurchaseController extends GetxController {
  final _repo = PurchaseOrderRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // Step indicator
  final currentStep = 2.obs;
  final totalSteps = 2.obs;

  // Scanned item (from scan flow)
  final itemName = 'Knee Prosthesis'.obs;
  final itemSN = 'SN: XYZ14324'.obs;
  final itemPrice = '\$4,200'.obs;

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

  // Attached documents
  final attachedDocs = <File>[].obs;
  final isPickingFile = false.obs;
  final isSubmitting = false.obs;

  // Dropdowns
  final surgeryList = <PoDropdownItem>[].obs;
  final facilityList = <PoDropdownItem>[].obs;
  final vendorList = <PoDropdownItem>[].obs;
  final isLoadingDropdowns = false.obs;

  String _selectedSurgeryId = '';
  String _selectedFacilityId = '';
  String _selectedVendorId = '';

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

  void deleteDoc(int index) => attachedDocs.removeAt(index);

  void showAttachOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (_) => _AttachOptionsSheet(
        onPickPdf: _pickPdf,
        onPickCamera: _pickFromCamera,
        onPickGallery: _pickFromGallery,
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
      final picked = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 85);
      if (picked != null) attachedDocs.add(File(picked.path));
    } finally {
      isPickingFile.value = false;
    }
  }

  Future<void> _pickFromGallery() async {
    isPickingFile.value = true;
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null) {
        for (final f in result.files) {
          if (f.path != null) attachedDocs.add(File(f.path!));
        }
      }
    } finally {
      isPickingFile.value = false;
    }
  }

  Future<void> submitOrder(BuildContext context) async {
    if (!_validate()) return;
    isSubmitting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.create(
        token,
        orderType: 'standardPO',
        status: selectedStatus.value,
        patientId: patientIdController.text.trim(),
        surgeryId: _selectedSurgeryId,
        facilityId: _selectedFacilityId,
        procedureDate: procedureDateController.text.trim(),
        purchaseOrderNumber: poNumberController.text.trim(),
        totalAmount: 0,
        vendorId: _selectedVendorId.isNotEmpty ? _selectedVendorId : null,
        notes: additionalNotesController.text.trim(),
        docs: attachedDocs.isNotEmpty ? attachedDocs : null,
      );
      if (res['success'] == true && context.mounted) {
        // Pre-populate ReviewSendPoController with real data from the API response
        final data = res['data'] as Map<String, dynamic>? ?? {};
        final reviewCtrl = Get.put(ReviewSendPoController());

        // PO meta
        reviewCtrl.poNumber.value =
            data['purchaseOrderNumber']?.toString() ?? '';
        reviewCtrl.poStatus.value = data['status']?.toString() ?? '';
        reviewCtrl.poType.value = data['orderType']?.toString() ?? '';

        // Documents — API returns a list of S3 URLs under "documents"
        final rawDocs = data['documents'];
        if (rawDocs is List && rawDocs.isNotEmpty) {
          final urls = rawDocs.map((e) => e.toString()).toList();
          reviewCtrl.setDocumentsFromUrls(urls);
          // Also update the list with proper names/sizes derived from URLs
          final updatedDocs = List<Map<String, dynamic>>.generate(
            urls.length,
            (i) {
              final url = urls[i];
              final fileName = url.split('/').last;
              final ext = fileName.contains('.')
                  ? fileName.split('.').last.toLowerCase()
                  : 'file';
              return {
                'id': '${i + 1}',
                'name': fileName,
                'size': '',
                'date': '',
                'type': ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)
                    ? 'image'
                    : ext,
                'url': url,
              };
            },
          );
          reviewCtrl.documents.value = updatedDocs;
        }

        context.pushNamed(AppRoutes.reviewSendPoScreen);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
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

// ── Attach Options Bottom Sheet ───────────────────────────────────────────────
class _AttachOptionsSheet extends StatelessWidget {
  final VoidCallback onPickPdf;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;

  const _AttachOptionsSheet({
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
          _OptionTile(
            iconPath: 'assets/icons/document.svg',
            title: 'Browse Files',
            subtitle: 'Upload PDF or Word document',
            onTap: () {
              Navigator.pop(context);
              onPickPdf();
            },
          ),
          SizedBox(height: 12.h),
          _OptionTile(
            iconPath: 'assets/icons/camera.svg',
            title: 'Camera',
            subtitle: 'Take a photo of your document',
            onTap: () {
              Navigator.pop(context);
              onPickCamera();
            },
          ),
          SizedBox(height: 12.h),
          _OptionTile(
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

class _OptionTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
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
