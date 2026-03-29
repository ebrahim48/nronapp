import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';

class OnboardingDotsNav extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final bool showArrow;
  final VoidCallback onArrowTap;

  const OnboardingDotsNav({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.showArrow,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w),
      child: SizedBox(
        height: 44.h,
        child: Row(
          mainAxisAlignment: showArrow
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dots
            Row(
              children: List.generate(totalPages, (i) {
                final isActive = i == currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.only(
                    right: i < totalPages - 1 ? 8.w : 0,
                  ),
                  width: isActive ? 25.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.dotButtonActiveColor
                        : AppColors.dotButtonInactiveColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                );
              }),
            ),

            // Circle arrow — only on first slide
            if (showArrow)
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: GestureDetector(
                  onTap: onArrowTap,
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: const BoxDecoration(
                      color: AppColors.dotButtonActiveColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/arrows.svg',
                        width: 16.r,
                        height: 16.r,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff656565),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
