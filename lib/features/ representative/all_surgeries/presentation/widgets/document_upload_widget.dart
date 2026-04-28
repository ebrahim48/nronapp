import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/surgery_controller.dart';

class DocumentUploadWidget extends StatelessWidget {
  const DocumentUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Uploaded files list
        ...c.uploadedDocs.asMap().entries.map(
              (e) => Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(
                horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Row(
              children: [
                Icon(Icons.insert_drive_file_outlined,
                    color: AppColors.primaryColor, size: 16.r),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomText(
                    text: e.value,
                    fontsize: 12.sp,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                GestureDetector(
                  onTap: () => c.uploadedDocs.removeAt(e.key),
                  child: Icon(Icons.close,
                      color: AppColors.secondaryTextColor,
                      size: 16.r),
                ),
              ],
            ),
          ),
        ),

        // Dotted upload button
        GestureDetector(
          onTap: c.pickDocument,
          child: CustomPaint(
            painter: _DottedBorderPainter(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined,
                      color: AppColors.secondaryTextColor, size: 22.r),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: 'Upload Your Files',
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5A5A5A)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final radius = Radius.circular(10);
    final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2), radius);

    final path = Path()..addRRect(rRect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final extractPath =
        metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}