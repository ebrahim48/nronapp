import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/add_bio_inventory_controller.dart';

class AddBioInventoryScreen extends StatefulWidget {
  const AddBioInventoryScreen({super.key});

  @override
  State<AddBioInventoryScreen> createState() => _AddBioInventoryScreenState();
}

class _AddBioInventoryScreenState extends State<AddBioInventoryScreen> {
  late final AddBioInventoryController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(AddBioInventoryController());
  }

  @override
  void dispose() {
    // Children unmount before their parent, so by the time this runs the
    // fields holding these TextEditingControllers are already gone. Deleting
    // the controller while the route was still mounted was what threw
    // "A TextEditingController was used after being disposed".
    Get.delete<AddBioInventoryController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              SizedBox(height: 12.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios,
                        color: AppColors.primaryTextColor, size: 18.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'Add Bio Inventory Item',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Initial Bio Photo
              _FieldLabel(text: 'Initial Bio Photo'),
              Obx(() => _BioPhotoSection(
                selectedPhoto: c.selectedPhoto.value,
                onAddPhoto: () => _showPhotoOptions(context, c),
              )),

              SizedBox(height: 16.h),

              // Item Name
              _FieldLabel(text: 'Item Name'),
              CustomTextField(
                controller: c.itemNameController,
                hintText: 'e.g. Reagent A',
              ),

              SizedBox(height: 16.h),

              // Vendor
              _FieldLabel(text: 'Vendor'),
              Obx(() => _VendorDropdown(
                value: c.selectedVendor.value,
                options: c.vendorOptions,
                onChanged: c.selectVendor,
              )),

              SizedBox(height: 16.h),

              // Lot Number
              _FieldLabel(text: 'Lot Number'),
              CustomTextField(
                controller: c.lotNumberController,
                hintText: 'e.g. LOT-12345',
              ),

              SizedBox(height: 16.h),

              // Quantity
              _FieldLabel(text: 'Quantity'),
              CustomTextField(
                controller: c.quantityController,
                hintText: 'e.g. 500 ml',
              ),

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
              CustomTextField(
                controller: c.locationController,
                hintText: 'Enter location',
              ),

              SizedBox(height: 16.h),

              // Additional Notes
              _FieldLabel(text: 'Additional Notes'),
              CustomTextField(
                controller: c.additionalNotesController,
                hintText:
                    'Add any specific case details or instructions...',
                maxLine: 5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: 'Write at least 80 characters.',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.end,
                ),
              ),

              SizedBox(height: 24.h),

              // Save Button
              Obx(() => CustomButton(
                title: 'Save Bio Inventory',
                loading: c.isSaving.value,
                onpress: () async {
                  final ok = await c.saveBioInventory();
                  if (ok && context.mounted) {
                    Navigator.pop(context);
                  }
                },
                color: AppColors.primaryColor,
                titlecolor: Colors.black,
              )),

              SizedBox(height: 12.h),

              // Disclaimer
              CustomText(
                text: 'Ensure all biohazard labels are up to date...',
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPhotoOptions(BuildContext context, AddBioInventoryController c) {
  showModalBottomSheet(
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
            onTap: () {
              Navigator.pop(context);
              c.pickPhoto(ImageSource.camera);
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.photo_library_outlined, color: Colors.white),
            title: const Text('Gallery',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            onTap: () {
              Navigator.pop(context);
              c.pickPhoto(ImageSource.gallery);
            },
          ),
        ],
      ),
    ),
  );
}

class _BioPhotoSection extends StatelessWidget {
  final File? selectedPhoto;
  final VoidCallback onAddPhoto;

  const _BioPhotoSection({
    required this.selectedPhoto,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dashed picker
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
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: selectedPhoto != null ? 'Change Photo' : 'Add Photo',
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

        // Preview box
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
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(selectedPhoto!, fit: BoxFit.cover),
                    Positioned(
                      top: 8.r,
                      right: 8.r,
                      child: GestureDetector(
                        onTap: onAddPhoto,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(Icons.edit_outlined,
                              size: 14.r, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined,
                          size: 32.r, color: const Color(0xFF3A3A3A)),
                      SizedBox(height: 6.h),
                      CustomText(
                        text: 'Preview',
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3A3A3A),
                        textAlign: TextAlign.center,
                      ),
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
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
            metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
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
      child: CustomText(
        text: text,
        fontsize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _VendorDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _VendorDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          SvgPicture.asset(
            'assets/icons/implantsinventory.svg',
            width: 18.r,
            height: 18.r,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryTextColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: CustomText(
                  text: 'Select Vendor',
                  fontsize: 13.sp,
                  color: AppColors.secondaryTextColor,
                ),
                isExpanded: true,
                dropdownColor: const Color(0xFF1E2121),
                icon: Icon(Icons.keyboard_arrow_down,
                    color: AppColors.secondaryTextColor, size: 20.r),
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: CustomText(
                      text: option,
                      fontsize: 13.sp,
                      color: AppColors.primaryTextColor,
                    ),
                  );
                }).toList(),
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

  const _ExpiryDateField({
    required this.selectedDate,
    required this.onTap,
  });

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
            Icon(Icons.calendar_today_outlined,
                color: AppColors.secondaryTextColor, size: 18.r),
            SizedBox(width: 10.w),
            CustomText(
              text: selectedDate != null
                  ? DateFormat('MM/dd/yyyy').format(selectedDate!)
                  : 'mm/dd/yyyy',
              fontsize: 13.sp,
              color: selectedDate != null
                  ? AppColors.primaryTextColor
                  : AppColors.secondaryTextColor,
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down,
                color: AppColors.secondaryTextColor, size: 20.r),
          ],
        ),
      ),
    );
  }
}
