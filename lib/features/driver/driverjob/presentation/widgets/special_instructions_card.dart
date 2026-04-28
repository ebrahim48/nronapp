import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class SpecialInstructionsCard extends StatelessWidget {
  final String instructions;

  const SpecialInstructionsCard({
    super.key,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1F0A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.warningColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warningColor,
                size: 18.r,
              ),
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

          // Body
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