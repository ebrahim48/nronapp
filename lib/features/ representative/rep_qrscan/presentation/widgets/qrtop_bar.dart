import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../controller/rep_qr_scan_controller.dart';

class QrTopBar extends StatelessWidget {
  final QrScanController controller;

  const QrTopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Positioned(
      top: 47.h,
      left: 24.w,
      child: SizedBox(
        width: 345.w,
        height: 32.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Close
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.primaryTextColor,
                  size: 18.r,
                ),
              ),
            ),

            // Title
            CustomText(
              text: 'Ready to Scan',
              fontsize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),

            // Flash
            Obx(() => GestureDetector(
              onTap: c.toggleFlash,
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: c.isFlashOn.value
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  c.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                  color: c.isFlashOn.value
                      ? AppColors.primaryColor
                      : AppColors.primaryTextColor,
                  size: 18.r,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}