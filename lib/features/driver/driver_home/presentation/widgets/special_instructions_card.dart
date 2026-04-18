import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SpecialInstructionsCard extends StatelessWidget {
  final String instructions;

  const SpecialInstructionsCard({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.warningColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.warningColor.withValues(alpha: 0.3),
            width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_outlined,
                  color: AppColors.warningColor, size: 16.r),
              SizedBox(width: 6.w),
              CustomText(
                text: 'Special Instructions',
                fontsize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.warningColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: instructions,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
            textHeight: 1.5,
          ),
        ],
      ),
    );
  }
}