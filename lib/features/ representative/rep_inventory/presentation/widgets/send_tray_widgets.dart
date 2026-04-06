import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/custom_widgets/custom_text_field.dart';

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
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: SvgPicture.asset(
        'assets/icons/plusfac.svg',
        width: 16.r,
        height: 16.r,
        colorFilter: const ColorFilter.mode(
          AppColors.secondaryTextColor,
          BlendMode.srcIn,
        ),
      ),
      suffixIcon: SvgPicture.asset(
        'assets/icons/chevron.svg',
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
                      width: 28.r,
                      height: 26.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: 'Add Photo',
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

        // Photo preview
        Container(
          width: 160.w,
          height: 160.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: const Color(0xFF1E2121),
          ),
          clipBehavior: Clip.antiAlias,
          child: selectedPhoto != null
              ? Image.file(selectedPhoto!, fit: BoxFit.cover)
              : Image.asset(
            'assets/images/tray.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(),
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