import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class SecurePaymentsBanner extends StatelessWidget {
  const SecurePaymentsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E2A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.primaryColor,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Secure Payments',
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: 'Your data is encrypted & safe',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}