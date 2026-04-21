import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class ProfileStatCards extends StatelessWidget {
  final int completedDeliveries;
  final double successRate;

  const ProfileStatCards({
    super.key,
    required this.completedDeliveries,
    required this.successRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            iconAsset: 'assets/icons/completed.svg',
            label: 'Completed',
            value: completedDeliveries.toString(),
            sub: 'Total deliveries',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            iconAsset: 'assets/icons/successrate.svg',
            label: 'Success Rate',
            value: '${successRate}%',
            sub: 'On-time delivery',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String iconAsset;
  final String label;
  final String value;
  final String sub;

  const _StatCard({
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 14.r,
                height: 14.r,
                colorFilter: ColorFilter.mode(
                    AppColors.secondaryTextColor, BlendMode.srcIn),
              ),
              SizedBox(width: 5.w),
              CustomText(
                text: label,
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: value,
            fontsize: 22.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 3.h),
          CustomText(
            text: sub,
            fontsize: 11.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}