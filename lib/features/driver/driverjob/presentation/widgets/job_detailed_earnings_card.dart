import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class JobDetailEarningsCard extends StatelessWidget {
  final double deliveryFee;
  final double yourPayout;

  const JobDetailEarningsCard({
    super.key,
    required this.deliveryFee,
    required this.yourPayout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2A1A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: const Color(0xFF1DB954).withValues(alpha: 0.3),
            width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/earning.svg',
                width: 16.r,
                height: 16.r,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1DB954),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 6.w),
              CustomText(
                text: 'Earnings',
                fontsize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Delivery Fee',
                fontsize: 13.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: '\$${deliveryFee.toStringAsFixed(2)}',
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Your Payout',
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: '\$${yourPayout.toStringAsFixed(2)}',
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1DB954),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}