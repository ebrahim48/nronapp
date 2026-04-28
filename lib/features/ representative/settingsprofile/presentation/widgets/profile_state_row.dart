import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../domain/model/settings_model.dart';

class ProfileStatsRow extends StatelessWidget {
  final UserProfileModel profile;
  final bool showRating;

  const ProfileStatsRow({
    super.key,
    required this.profile,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCell(
            label: 'TOTAL POS',
            value: profile.totalPos.toString(),
            valueColor: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCell(
            label: 'COMM YTD',
            value: profile.commYtd,
            valueColor: AppColors.primaryColor,
          ),
        ),
        if (showRating) ...[
          SizedBox(width: 12.w),
          Expanded(
            child: _StatCell(
              label: 'RATING',
              value: '${profile.rating} ★',
              valueColor: AppColors.primaryColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCell({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryTextColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 18.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ],
      ),
    );
  }
}