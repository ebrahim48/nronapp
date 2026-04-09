import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class ScanItemButton extends StatelessWidget {
  final VoidCallback onTap;

  const ScanItemButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 64.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner,
                    color: AppColors.primaryTextColor, size: 24.r),
                SizedBox(height: 4.h),
                CustomText(
                  text: 'Scan Item',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {},
          child: CustomText(
            text: 'Connect USB Scanner',
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTextColor,
            textDecoration: TextDecoration.underline,
          ),
        ),
        SizedBox(height: 2.h),
        CustomText(
          text: 'Or Enter serial Number Manually',
          fontsize: 11.sp,
          color: AppColors.secondaryTextColor,
        ),
      ],
    );
  }
}