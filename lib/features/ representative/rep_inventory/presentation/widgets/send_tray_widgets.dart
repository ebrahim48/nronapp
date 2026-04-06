import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nron_app/core/constants/app_colors.dart';
import 'package:nron_app/core/custom_widgets/custom_text.dart';
import 'package:nron_app/core/custom_widgets/custom_text_field.dart';

import '../../controller/send_tray_controller.dart';

class SendTrayLabel extends StatelessWidget {
  final String text;
  const SendTrayLabel({super.key, required this.text});

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


class SendTrayFacilityField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const SendTrayFacilityField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SendTrayController>();

    return GestureDetector(
      onTap: () => _showFacilityModal(context, c),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/plusfac.svg',
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                AppColors.secondaryTextColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Obx(
                () => CustomText(
                  text: c.selectedFacility.value?.name ?? 
                      (controller.text.isEmpty ? hintText : controller.text),
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: c.selectedFacility.value != null
                      ? AppColors.primaryTextColor
                      : AppColors.secondaryTextColor,
                ),
              ),
            ),
            Obx(
              () => AnimatedRotation(
                turns: c.isDropdownOpen.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  'assets/icons/chevron.svg',
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.secondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFacilityModal(BuildContext context, SendTrayController c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D1D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
              child: Row(
                children: [
                  CustomText(
                    text: 'Select Facility',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      size: 24.r,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D2D),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF3A3A3A),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: c.searchController,
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search facility...',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryTextColor,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20.r,
                      color: AppColors.secondaryTextColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Facility list
            Expanded(
              child: Obx(
                () => c.filteredFacilities.isEmpty
                    ? Center(
                        child: CustomText(
                          text: 'No facilities found',
                          fontsize: 14.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: c.filteredFacilities.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1.h,
                          color: const Color(0xFF2A2D2D),
                        ),
                        itemBuilder: (context, index) {
                          final facility = c.filteredFacilities[index];
                          return _buildFacilityTile(context, c, facility);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityTile(
    BuildContext context,
    SendTrayController c,
    FacilityItem facility,
  ) {
    return GestureDetector(
      onTap: () {
        c.selectFacility(facility);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D2D),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.location_city_outlined,
                size: 22.r,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: facility.name,
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: CustomText(
                          text: facility.code,
                          fontsize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomText(
                          text: facility.address,
                          fontsize: 12.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.r,
              color: AppColors.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

class SendTraySystemType extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const SendTraySystemType({
    super.key,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Orthopedic', 'Cardiac'];

    return Row(
      children: labels.asMap().entries.map((e) {
        final isActive = e.key == activeIndex;
        return Padding(
          padding: EdgeInsets.only(right: e.key == 0 ? 10.w : 0),
          child: GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 38.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryColor
                      : const Color(0xFF3A3A3A),
                  width: isActive ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Radio circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 16.r,
                    height: 16.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isActive
                            ? AppColors.primaryColor
                            : const Color(0xFF3A3A3A),
                        width: 1.5,
                      ),
                    ),
                    child: isActive
                        ? Center(
                      child: Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : null,
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: e.value,
                    fontsize: 13.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? AppColors.primaryColor
                        : AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SendTrayIconField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String iconPath;
  final TextInputType keyboardType;
  final int maxLines;

  const SendTrayIconField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconPath,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLine: maxLines,
      prefixIcon: SvgPicture.asset(
        iconPath,
        width: 16.r,
        height: 16.r,
        colorFilter: const ColorFilter.mode(
          AppColors.secondaryTextColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class SendTrayPhotoSection extends StatelessWidget {
  final File? selectedPhoto;
  final VoidCallback onAddPhoto;

  const SendTrayPhotoSection({
    super.key,
    required this.selectedPhoto,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Add Photo — dashed teal border
        GestureDetector(
          onTap: () => _showPhotoOptions(context),
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
                    Icon(
                      Icons.add_photo_alternate_rounded,
                      size: 32.r,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: 'Add Photo',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: 'Camera or Gallery',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 9.w),

        // Photo preview
        Container(
          width: 160.w,
          height: 160.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: const Color(0xFF1E2121),
            border: Border.all(
              color: const Color(0xFF3A3A3A),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: selectedPhoto != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(selectedPhoto!, fit: BoxFit.cover),
                    Positioned(
                      top: 8.w,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 18.r,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 36.r,
                      color: AppColors.secondaryTextColor,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: 'Preview',
                      fontsize: 12.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void _showPhotoOptions(BuildContext context) {
    final c = Get.find<SendTrayController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D1D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            CustomText(
              text: 'Select Photo Source',
              fontsize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _buildPhotoSourceOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () => c.pickPhoto(ImageSource.camera),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPhotoSourceOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () => c.pickPhoto(ImageSource.gallery),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D2D),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.r, color: AppColors.primaryColor),
            SizedBox(height: 8.h),
            CustomText(
              text: label,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
            ),
          ],
        ),
      ),
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
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => false;
}