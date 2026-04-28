import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class DocUploadBox extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;
  final double? height;

  const DocUploadBox({
    super.key,
    this.imagePath,
    required this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashPainter(),
        child: Container(
          width: double.infinity,
          height: height ?? 130.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primaryTextColor,
                      size: 30.r,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: 'Upload',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashW = 7.0;
    const dashSpace = 5.0;
    const radius = 10.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(radius),
      ));

    for (final pm in path.computeMetrics()) {
      double d = 0;
      while (d < pm.length) {
        canvas.drawPath(pm.extractPath(d, d + dashW), paint);
        d += dashW + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}