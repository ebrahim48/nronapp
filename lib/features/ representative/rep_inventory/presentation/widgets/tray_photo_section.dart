import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class TrayPhotoSection extends StatelessWidget {
  final File? selectedPhoto;
  final VoidCallback onAddPhoto;

  const TrayPhotoSection({
    super.key,
    required this.selectedPhoto,
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
                          child: Icon(
                            Icons.edit_outlined,
                            size: 14.r,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 32.r,
                        color: const Color(0xFF3A3A3A),
                      ),
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
