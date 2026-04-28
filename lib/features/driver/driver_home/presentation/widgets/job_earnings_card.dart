import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class JobEarningsCard extends StatelessWidget {
  final double earnings;
  final double distanceKm;

  const JobEarningsCard({
    super.key,
    required this.earnings,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2A1A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: const Color(0xFF1DB954).withValues(alpha: 0.3),
            width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.attach_money,
                color: const Color(0xFF1DB954), size: 22.r),
          ),
          SizedBox(width: 12.w),
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
                CustomText(
                  text: '\$${earnings.toStringAsFixed(0)}',
                  fontsize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: 'Distance',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: '${distanceKm} km',
                fontsize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}