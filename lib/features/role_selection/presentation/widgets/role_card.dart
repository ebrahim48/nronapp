import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

enum RoleCardStyle { manager, representative }

class RoleCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String subtitle;
  final RoleCardStyle style;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.subtitle,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: style == RoleCardStyle.manager
          ? _ManagerCard(iconPath: iconPath, label: label, subtitle: subtitle)
          : _RepresentativeCard(
          iconPath: iconPath, label: label, subtitle: subtitle),
    );
  }
}

class _ManagerCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String subtitle;

  const _ManagerCard({
    required this.iconPath,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      height: 130.h,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.roleCardBaseDark,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.roleCardBorderColor),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 3,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.roleCardGlowStart,
                  AppColors.roleCardGlowEnd,
                ],
                stops: [0.0, 0.5],
              ),
            ),
          ),

          Center(
            child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.cyanColorLight,
                        AppColors.cyanColorTransparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 30.r,
                      height: 30.r,
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // Label + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: label,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: subtitle,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                        maxline: 3,
                        textHeight: 1.4,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Arrow icon
                SvgPicture.asset(
                  'assets/icons/arrows.svg',
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}

class _RepresentativeCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String subtitle;

  const _RepresentativeCard({
    required this.iconPath,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      height: 130.h,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.roleCardBaseDark,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.roleCardBorderColor),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 3,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.roleCardGlowStart,
                  AppColors.roleCardGlowEnd,
                ],
                stops: [0.0, 0.5],
              ),
            ),
          ),

          // Content row
          Center(
            child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.dotButtonActiveColor,
                        AppColors.tealDarkColor,
                      ],
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 30.r,
                      height: 30.r,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // Label + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: label,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: subtitle,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                        maxline: 3,
                        textHeight: 1.4,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                SvgPicture.asset(
                  'assets/icons/arrows.svg',
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}
