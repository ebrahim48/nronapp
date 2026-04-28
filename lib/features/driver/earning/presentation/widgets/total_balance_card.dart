import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class TotalBalanceCard extends StatelessWidget {
  final double balance;
  final double percentChange;

  const TotalBalanceCard({
    super.key,
    required this.balance,
    required this.percentChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + label
          Row(
            children: [
              Icon(Icons.wallet_outlined,
                  color: AppColors.secondaryTextColor, size: 16.r),
              SizedBox(width: 6.w),
              CustomText(
                text: 'Total Balance',
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Amount
          CustomText(
            text: '\$${balance.toInt()}',
            fontsize: 32.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 6.h),

          // % Change
          Row(
            children: [
              Icon(Icons.trending_up,
                  color: const Color(0xFF4ADE80), size: 14.r),
              SizedBox(width: 4.w),
              CustomText(
                text:
                '+${percentChange.toStringAsFixed(0)}% from last week',
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4ADE80),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}