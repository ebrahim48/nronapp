import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class QuickActionCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.r,
              height: 50.r,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 26.r,
                  height: 26.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.secondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: label,
              fontsize: 12.sp,
              color: AppColors.primaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}