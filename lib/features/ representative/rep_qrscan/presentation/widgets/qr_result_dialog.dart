import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../controller/rep_qr_scan_controller.dart';

class QrResultDialog extends StatelessWidget {
  final String value;

  const QrResultDialog({super.key, required this.value});

  static void show(String value) {
    Get.dialog(
      QrResultDialog(value: value),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QrScanController>();

    return AlertDialog(
      backgroundColor: const Color(0xFF1E2121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      title: CustomText(
        text: 'Scan Result',
        fontsize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
      ),
      content: CustomText(
        text: value,
        fontsize: 13.sp,
        color: AppColors.secondaryTextColor,
        textAlign: TextAlign.start,
        maxline: 5,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            c.resetScan();
          },
          child: CustomText(
            text: 'Scan Again',
            fontsize: 13.sp,
            color: AppColors.primaryColor,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: CustomText(
            text: 'Done',
            fontsize: 13.sp,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}