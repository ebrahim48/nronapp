import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class EarningsCard extends StatelessWidget {
  final double earnings;
  final double distanceKm;

  const EarningsCard({
    super.key,
    required this.earnings,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A2A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF2E6B47),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Dollar icon circle
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: const Color(0xFF2E6B47),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomText(
                text: '\$',
                fontsize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4ADE80),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Earnings
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Your Earnings',
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text:
                  '\$${earnings % 1 == 0 ? earnings.toInt() : earnings}',
                  fontsize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),

          // Distance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: 'Distance',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: '${distanceKm} km',
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}