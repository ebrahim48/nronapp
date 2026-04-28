import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';

/// Professional sign-out confirmation dialog
class SignOutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const SignOutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2427),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon Circle
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/logout.svg',
                  width: 32.r,
                  height: 32.r,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFF5252),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            CustomText(
              text: 'Sign Out',
              fontsize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            // Message
            CustomText(
              text: 'Are you sure you want to sign out? You will need to log in again to access your account.',
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 28.h),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: const Color(0xFF00C5DA),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Cancel',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00C5DA),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Sign Out Button
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Sign Out',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
