import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class PerformanceBanner extends StatelessWidget {
  final double progressValue; // 0.0 to 1.0

  const PerformanceBanner({
    super.key,
    this.progressValue = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A1A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF2E6B47),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: const Color(0xFF1A5C36),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.trending_up,
                color: const Color(0xFF4ADE80), size: 20.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Great Performance!',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text:
                  "You're in the top 10% of drivers this month. Keep up the excellent work!",
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  textHeight: 1.5,
                ),
                SizedBox(height: 10.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: const Color(0xFF2E6B47),
                    color: AppColors.primaryColor,
                    minHeight: 5.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}