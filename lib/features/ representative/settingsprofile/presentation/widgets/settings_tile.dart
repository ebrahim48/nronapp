import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SettingsTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const SettingsTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Row(
          children: [
            // Icon
            SvgPicture.asset(
              iconPath,
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                iconColor ?? AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 12.w),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    CustomText(
                      text: subtitle!,
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.secondaryTextColor, size: 20.r),
          ],
        ),
      ),
    );
  }
}