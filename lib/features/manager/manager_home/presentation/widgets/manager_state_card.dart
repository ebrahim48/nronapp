import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_home_model.dart';

class ManagerStatCard extends StatelessWidget {
  final ManagerStatModel stat;

  const ManagerStatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              stat.iconPath,
              width: 24.r,
              height: 24.r,
            ),
            SizedBox(height: 10.h),
            CustomText(
              text: stat.label,
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: stat.value,
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: stat.valueColor ?? AppColors.primaryTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}