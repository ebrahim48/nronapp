import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class CommissionStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const CommissionStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: label,
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: value,
              fontsize: 20.sp,
              fontWeight: FontWeight.w700,
              color: valueColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}