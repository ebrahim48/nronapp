import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/driver_home_model.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class DriverStatCard extends StatelessWidget {
  final DriverStatModel stat;

  const DriverStatCard({super.key, required this.stat});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  stat.iconPath,
                  width: 20.r,
                  height: 20.r,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            CustomText(
              text: stat.value,
              fontsize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 2.h),
            CustomText(
              text: stat.label,
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}