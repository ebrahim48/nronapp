import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class DottedUploadBox extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final double? height;

  const DottedUploadBox({
    super.key,
    this.label = 'Inbound Image Upload',
    this.subtitle = 'Tap to capture or select from gallery',
    required this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashBorderPainter(),
        child: Container(
          width: double.infinity,
          height: height ?? 90.h,
          decoration: BoxDecoration(
            color: const Color(0x0DFFFFFF),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt_outlined,
                    color: AppColors.secondaryTextColor, size: 18.r),
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: label,
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
              CustomText(
                text: subtitle,
                fontsize: 10.sp,
                color: AppColors.secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 8.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(radius),
      ));

    final pathMetrics = path.computeMetrics();
    for (final pm in pathMetrics) {
      double distance = 0;
      while (distance < pm.length) {
        canvas.drawPath(
          pm.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}