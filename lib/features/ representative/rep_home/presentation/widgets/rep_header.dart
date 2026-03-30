import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class RepHeader extends StatelessWidget {
  const RepHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      height: 52.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              // Avatar with #00C5DA border
              Container(
                width: 54.r,
                height: 54.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryColor, // #00C5DA
                    width: 2,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              // Greeting text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Good Morning,',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: 'AI Jamil',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),

          // ── Right icons ─────────────────────────────────────────────
          Row(
            children: [
              // Notification icon with red dot badge
              SizedBox(
                width: 42.r,
                height: 42.r,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Notification svg
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/notification.svg',
                        width: 26.r,
                        height: 26.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor, // #00C5DA
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    // Red dot badge — top right of icon
                    Positioned(
                      top: 6.h,
                      right: 6.w,
                      child: Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2828),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundColor,
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 3,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // Drawer icon — circle bg
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 3,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/drawer.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}