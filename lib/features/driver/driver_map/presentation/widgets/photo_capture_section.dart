import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/driver_map_controller.dart';

class PhotoCaptureSection extends StatelessWidget {
  const PhotoCaptureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverMapController>();

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.camera_alt_outlined,
                    color: AppColors.primaryColor, size: 18.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Take Delivery Photo',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: 'Photo proof of delivery',
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Obx(() => c.deliveryPhotoPath.value.isNotEmpty
                  ? Icon(Icons.check_circle,
                  color: const Color(0xFF1DB954), size: 20.r)
                  : Icon(Icons.check_circle_outline,
                  color: const Color(0xFF1DB954), size: 20.r)),
            ],
          ),

          SizedBox(height: 12.h),

          CustomText(
            text: 'Capture Photo',
            fontsize: 11.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 8.h),

          Obx(() => GestureDetector(
            onTap: c.pickDeliveryPhoto,
            child: c.deliveryPhotoPath.value.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.file(
                File(c.deliveryPhotoPath.value),
                width: double.infinity,
                height: 140.h,
                fit: BoxFit.cover,
              ),
            )
                : CustomPaint(
              painter: _DottedBorderPainter(),
              child: Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined,
                        color: AppColors.primaryColor,
                        size: 28.r),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: 'Take Photo',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                    CustomText(
                      text: 'Tap to capture',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final radius = const Radius.circular(10);
    final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2), radius);

    final path = Path()..addRRect(rRect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
            metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}