import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SettingsSectionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final Widget child;
  final VoidCallback? onEditTap;

  const SettingsSectionCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.child,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: title,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ),
              if (onEditTap != null)
                GestureDetector(
                  onTap: onEditTap,
                  child: SvgPicture.asset(
                    'assets/icons/edit.svg',
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}