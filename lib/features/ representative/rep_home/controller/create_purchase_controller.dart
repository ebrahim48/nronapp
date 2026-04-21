import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';

class CreatePurchaseController extends GetxController {
  // Scanned item
  final itemName = 'Knee Prosthesis'.obs;
  final itemSN = 'SN: XYZ14324'.obs;
  final itemPrice = '\$4,200'.obs;

  // Form fields
  final selectedStatus = 'Op'.obs;
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

  final statusOptions = ['Op', 'Lost', 'Complete'];

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
      if (result != null && result.files.isNotEmpty) {
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
      final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) attachedDocs.add(File(picked.path));
    } finally {
      isPickingFile.value = false;
    }
  }

  Future<void> _pickFromGallery() async {
    isPickingFile.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        for (final f in result.files) {
          if (f.path != null) attachedDocs.add(File(f.path!));
        }
      }
    } finally {
      isPickingFile.value = false;
    }
  }

  void submitOrder() {
    // Submit logic here
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
            onTap: () { Navigator.pop(context); onPickPdf(); },
          ),
          SizedBox(height: 12.h),
          _OptionTile(
            iconPath: 'assets/icons/camera.svg',
            title: 'Camera',
            subtitle: 'Take a photo of your document',
            onTap: () { Navigator.pop(context); onPickCamera(); },
          ),
          SizedBox(height: 12.h),
          _OptionTile(
            iconPath: 'assets/icons/scanitem.svg',
            title: 'Gallery',
            subtitle: 'Choose from your photo gallery',
            onTap: () { Navigator.pop(context); onPickGallery(); },
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
