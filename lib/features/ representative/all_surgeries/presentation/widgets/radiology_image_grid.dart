import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../controller/surgery_controller.dart';

class RadiologyImageGrid extends StatelessWidget {
  const RadiologyImageGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();

    return Obx(() {
      final keys = c.radiologyPickedImages.keys.toList();

      // First 4 in 2x2, last one full width
      final gridItems = keys.take(4).toList();
      final fullWidthItem = keys.length > 4 ? keys[4] : null;

      return Column(
        children: [
          // 2x2 grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, i) => _RadioImageCell(
              label: gridItems[i],
              imagePath: c.radiologyPickedImages[gridItems[i]],
              onTap: () => c.pickRadiologyImage(gridItems[i]),
            ),
          ),

          // Full width last item
          if (fullWidthItem != null) ...[
            SizedBox(height: 10.h),
            _RadioImageCell(
              label: fullWidthItem,
              imagePath: c.radiologyPickedImages[fullWidthItem],
              onTap: () => c.pickRadiologyImage(fullWidthItem),
              fullWidth: true,
            ),
          ],
        ],
      );
    });
  }
}

class _RadioImageCell extends StatelessWidget {
  final String label;
  final String? imagePath;
  final VoidCallback onTap;
  final bool fullWidth;

  const _RadioImageCell({
    required this.label,
    required this.imagePath,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: fullWidth ? 120.h : null,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.5),
            width: 1,
            // Dashed effect via custom painter below
          ),
        ),
        child: hasImage
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
              ),
              // Label overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            : _DottedCell(label: label),
      ),
    );
  }
}

class _DottedCell extends StatelessWidget {
  final String label;
  const _DottedCell({required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined,
                color: AppColors.primaryColor, size: 24.r),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
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