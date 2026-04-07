import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/expense_controller.dart';

class AttachmentSection extends StatelessWidget {
  const AttachmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receipts & Documents',
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 12.h),

        // Uploaded files list
        Obx(() => Column(
          children: List.generate(
            controller.uploadedFiles.length,
                (index) => _UploadedFileItem(
                  file: controller.uploadedFiles[index],
                  onRemove: () => controller.removeFile(index),
                ),
          ),
        )),

        // Attach file box with dotted border
        Obx(() => GestureDetector(
          onTap: controller.isPickingFile.value
              ? null
              : controller.attachFile,
          child: SizedBox(
            width: double.infinity,
            height: 80.h,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: const Color(0xFF3A3A3A),
                borderRadius: 12,
                dashWidth: 6,
                dashSpace: 4,
                strokeWidth: 1.5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x0D1AC8DB),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: controller.isPickingFile.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attach_file_rounded,
                            color: AppColors.primaryColor,
                            size: 22.r,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attach File',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                'PDF, JPG, PNG (max 10MB)',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'Poppins',
                                  color: AppColors.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        )),

        SizedBox(height: 24.h),
      ],
    );
  }
}

class _UploadedFileItem extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _UploadedFileItem({
    required this.file,
    required this.onRemove,
  });

  String _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (ext == 'pdf') return 'assets/icons/pdf.svg';
    if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) return 'assets/icons/image.svg';
    return 'assets/icons/file.svg';
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split('/').last;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                _getFileIcon(fileName),
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondaryTextColor,
                  BlendMode.srcIn,
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.insert_drive_file_outlined,
                    color: AppColors.secondaryTextColor,
                    size: 18.r,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              color: AppColors.redColorFF1D1D,
              size: 20.r,
            ),
          ),
        ],
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
    required this.strokeWidth,
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