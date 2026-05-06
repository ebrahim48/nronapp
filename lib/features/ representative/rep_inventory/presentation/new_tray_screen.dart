import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/new_tray_widgets.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/new_tray_controller.dart';


class NewTrayScreen extends StatefulWidget {
  const NewTrayScreen({super.key});

  @override
  State<NewTrayScreen> createState() => _NewTrayScreenState();
}

class _NewTrayScreenState extends State<NewTrayScreen> {
  late final NewTrayController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(NewTrayController());
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
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
                text: 'Select Photo',
                fontsize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20.h),
              _PhotoOptionTile(
                icon: Icons.camera_alt_outlined,
                label: 'Take Photo',
                onTap: () {
                  Navigator.pop(context);
                  c.pickPhotoFromCamera();
                },
              ),
              SizedBox(height: 12.h),
              _PhotoOptionTile(
                icon: Icons.photo_library_outlined,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(context);
                  c.pickPhotoFromGallery();
                },
              ),
              if (c.selectedPhoto.value != null) ...[

                SizedBox(height: 12.h),
                _PhotoOptionTile(
                  icon: Icons.delete_outline,
                  label: 'Remove Photo',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    c.removePhoto();
                  },
                ),
              ],
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
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
              // AppBar row
              SizedBox(height: 12.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryTextColor,
                      size: 18.r,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'New Tray Entry',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              const TrayFieldLabel(text: 'Initial Tray Photo'),
              Obx(() => TrayPhotoSection(
                selectedPhoto: c.selectedPhoto.value,
                onAddPhoto: () => _showPhotoOptions(context),
              )),

              SizedBox(height: 20.h),

              const TrayFieldLabel(text: 'Tray ID'),
              TrayIconTextField(
                controller: c.trayIdController,
                hintText: 'e.g. TR-90210-ORTHO',
              ),

              SizedBox(height: 4.h),

              const TrayFieldLabel(text: 'Facility / Location'),
              Obx(() => TrayFacilityDropdown(
                value: c.selectedFacility.value,
                options: c.facilityOptions,
                onChanged: (val) {
                  if (val != null) c.selectFacility(val);
                },
              )),

              SizedBox(height: 4.h),

              const TrayFieldLabel(text: 'Vendor'),
              TrayIconTextField(
                controller: c.vendorController,
                hintText: 'Select Vendor',
                iconPath: 'assets/icons/selectvendor.svg',
              ),

              SizedBox(height: 4.h),

              const TrayFieldLabel(text: 'System Type'),
              Obx(() => TraySystemTypeDropdown(
                value: c.selectedSystemType.value,
                options: c.systemTypeOptions,
                onChanged: (val) {
                  if (val != null) c.selectSystemType(val);
                },
              )),

              SizedBox(height: 20.h),

              const TrayFieldLabel(text: 'Inventory Model', isTeal: true),
              Obx(() => InventoryModelToggle(
                activeIndex: c.inventoryModelIndex.value,
                onSelect: c.selectInventoryModel,
              )),

              SizedBox(height: 16.h),

              const TrayFieldLabel(text: 'Return By Date'),
              TrayReturnDateField(
                controller: c.returnDateController,
                onTap: () => c.pickReturnDate(context),
              ),

              SizedBox(height: 12.h),

              const TrayReturnWarningBanner(),

              SizedBox(height: 16.h),

              const TrayFieldLabel(text: 'Status'),
              Obx(() => TrayStatusSelector(
                activeIndex: c.statusIndex.value,
                onSelect: c.selectStatus,
              )),

              SizedBox(height: 16.h),

              const TrayFieldLabel(text: 'Additional Notes'),
              TrayIconTextField(
                controller: c.additionalNotesController,
                hintText: 'Add any specific case details or instructions...',
                maxLines: 5,
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

              CustomButton(
                title: 'Create Tray Record',
                onpress: c.createTrayRecord,
                prefixIcon: SvgPicture.asset(
                  'assets/icons/add.svg',
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _PhotoOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFFD9499)
        : AppColors.primaryTextColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF25292A),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22.r),
            SizedBox(width: 14.w),
            CustomText(
              text: label,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              color: color,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
