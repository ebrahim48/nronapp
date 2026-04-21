import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class TotalEarningsCard extends StatelessWidget {
  final double totalEarnings;
  final VoidCallback onViewDetails;

  const TotalEarningsCard({
    super.key,
    required this.totalEarnings,
    required this.onViewDetails,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wallet_outlined,
                  color: AppColors.primaryColor, size: 16.r),
              SizedBox(width: 6.w),
              CustomText(
                text: 'Total Earnings',
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                    '\$${totalEarnings.toInt()}',
                    fontsize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: 'Lifetime earnings',
                    fontsize: 11.sp,
                    color: const Color(0xFF4ADE80),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              GestureDetector(
                onTap: onViewDetails,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A5C36),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: 'View Details',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}