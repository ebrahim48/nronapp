import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/edit_bio_inventory_controller.dart';

class EditBioInventoryScreen extends StatefulWidget {
  final String bioId;
  const EditBioInventoryScreen({super.key, required this.bioId});

  @override
  State<EditBioInventoryScreen> createState() => _EditBioInventoryScreenState();
}

class _EditBioInventoryScreenState extends State<EditBioInventoryScreen> {
  late final EditBioInventoryController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(EditBioInventoryController(bioId: widget.bioId));
  }

  @override
  void dispose() {
    // Children unmount before their parent, so the fields holding this
    // controller's TextEditingControllers are already gone by now. Deleting
    // it from a button handler instead threw "A TextEditingController was
    // used after being disposed".
    Get.delete<EditBioInventoryController>(force: true);
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252525),
        title: const Text('Delete Bio Item',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to delete this item? This cannot be undone.',
            style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54, fontFamily: 'Poppins'))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFFF4B4B), fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final ok = await c.deleteBio();
      if (ok && mounted) {
        Navigator.pop(context); // pop edit screen
        Navigator.pop(context); // pop details screen
      }
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2427),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              title: const Text('Camera', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () { Navigator.pop(context); c.pickPhoto(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
              title: const Text('Gallery', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () { Navigator.pop(context); c.pickPhoto(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (c.isLoadingDetail.value) {
            return ListView(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
              children: List.generate(5, (_) => Container(
                margin: EdgeInsets.only(bottom: 14.h),
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              )),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios, color: AppColors.primaryTextColor, size: 18.r),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: 'Edit Bio Inventory',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    GestureDetector(
                      onTap: _confirmDelete,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A1A1A),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFFF4B4B).withValues(alpha: 0.5)),
                        ),
                        child: Row(children: [
                          Icon(Icons.delete_outline, color: const Color(0xFFFF4B4B), size: 14.r),
                          SizedBox(width: 4.w),
                          Text('Delete', style: TextStyle(
                              color: const Color(0xFFFF4B4B), fontSize: 12.sp,
                              fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                        ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Photo
                _FieldLabel(text: 'Initial Bio Photo'),
                Obx(() => _BioPhotoSection(
                  selectedPhoto: c.selectedPhoto.value,
                  existingImageUrl: c.existingImageUrl.value,
                  onAddPhoto: _showPhotoOptions,
                )),

                SizedBox(height: 16.h),

                // Item Name
                _FieldLabel(text: 'Item Name'),
                CustomTextField(controller: c.itemNameController, hintText: 'e.g. Reagent A'),

                SizedBox(height: 16.h),

                // Vendor
                _FieldLabel(text: 'Vendor'),
                Obx(() => _VendorDropdown(
                  value: c.selectedVendorName.value,
                  options: c.vendorOptions,
                  onChanged: c.selectVendor,
                )),

                SizedBox(height: 16.h),

                // Lot Number
                _FieldLabel(text: 'Lot Number'),
                CustomTextField(controller: c.lotNumberController, hintText: 'e.g. LOT-12345'),

                SizedBox(height: 16.h),

                // Quantity
                _FieldLabel(text: 'Quantity'),
                CustomTextField(controller: c.quantityController, hintText: 'e.g. 500 ml'),

                SizedBox(height: 16.h),

                // Expiry Date
                _FieldLabel(text: 'Expiry Date'),
                Obx(() => _ExpiryDateField(
                  selectedDate: c.expiryDate.value,
                  onTap: () => c.pickExpiryDate(context),
                )),

                SizedBox(height: 16.h),

                // Location
                _FieldLabel(text: 'Location'),
                CustomTextField(controller: c.locationController, hintText: 'Enter location'),

                SizedBox(height: 16.h),

                // Additional Notes
                _FieldLabel(text: 'Additional Notes'),
                CustomTextField(
                  controller: c.additionalNotesController,
                  hintText: 'Add any specific case details or instructions...',
                  maxLine: 5,
                ),

                SizedBox(height: 24.h),

                Obx(() => CustomButton(
                  title: 'Update Bio Inventory',
                  loading: c.isSaving.value,
                  onpress: () async {
                    final ok = await c.saveUpdate();
                    if (ok && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  color: AppColors.primaryColor,
                  titlecolor: Colors.black,
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/add.svg',
                    width: 18.r,
                    height: 18.r,
                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                )),

                SizedBox(height: 16.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _BioPhotoSection extends StatelessWidget {
  final File? selectedPhoto;
  final String existingImageUrl;
  final VoidCallback onAddPhoto;

  const _BioPhotoSection({
    required this.selectedPhoto,
    required this.existingImageUrl,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAddPhoto,
          child: SizedBox(
            width: 160.w,
            height: 160.h,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: const Color(0x331AC8DB),
                borderRadius: 24,
                dashWidth: 6,
                dashSpace: 4,
                strokeWidth: 2,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x0D1AC8DB),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/camera.svg',
                      width: 27.5.r,
                      height: 25.r,
                      colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: selectedPhoto != null ? 'Change Photo' : 'Change Photo',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 9.w),
        Container(
          width: 160.w,
          height: 160.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: const Color(0xFF1E2121),
            border: Border.all(color: const Color(0xFF2A2D2D)),
          ),
          clipBehavior: Clip.antiAlias,
          child: selectedPhoto != null
              ? Stack(fit: StackFit.expand, children: [
                  Image.file(selectedPhoto!, fit: BoxFit.cover),
                  Positioned(
                    top: 8.r, right: 8.r,
                    child: GestureDetector(
                      onTap: onAddPhoto,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6.r)),
                        child: Icon(Icons.edit_outlined, size: 14.r, color: Colors.white),
                      ),
                    ),
                  ),
                ])
              : (existingImageUrl.startsWith('http'))
                  ? Stack(fit: StackFit.expand, children: [
                      Image.network(existingImageUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                      Positioned(
                        top: 8.r, right: 8.r,
                        child: GestureDetector(
                          onTap: onAddPhoto,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6.r)),
                            child: Icon(Icons.edit_outlined, size: 14.r, color: Colors.white),
                          ),
                        ),
                      ),
                    ])
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 32.r, color: const Color(0xFF3A3A3A)),
                          SizedBox(height: 6.h),
                          CustomText(text: 'Preview', fontsize: 11.sp, fontWeight: FontWeight.w400,
                              color: const Color(0xFF3A3A3A), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const _DashedBorderPainter({
    required this.color, required this.borderRadius,
    required this.dashWidth, required this.dashSpace, this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(borderRadius)));
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dashWidth), paint);
        d += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => false;
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(text: text, fontsize: 13.sp, fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor, textAlign: TextAlign.start),
    );
  }
}

class _VendorDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _VendorDropdown({required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final safeValue = (value != null && options.contains(value)) ? value : null;
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/implantsinventory.svg', width: 18.r, height: 18.r,
              colorFilter: const ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn)),
          SizedBox(width: 10.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: safeValue,
                hint: CustomText(text: 'Select Vendor', fontsize: 13.sp, color: AppColors.secondaryTextColor),
                isExpanded: true,
                dropdownColor: const Color(0xFF1E2121),
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextColor, size: 20.r),
                items: options.map((o) => DropdownMenuItem(
                  value: o,
                  child: CustomText(text: o, fontsize: 13.sp, color: AppColors.primaryTextColor),
                )).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryDateField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _ExpiryDateField({required this.selectedDate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: AppColors.secondaryTextColor, size: 18.r),
            SizedBox(width: 10.w),
            CustomText(
              text: selectedDate != null ? DateFormat('MM/dd/yyyy').format(selectedDate!) : 'mm/dd/yyyy',
              fontsize: 13.sp,
              color: selectedDate != null ? AppColors.primaryTextColor : AppColors.secondaryTextColor,
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextColor, size: 20.r),
          ],
        ),
      ),
    );
  }
}
