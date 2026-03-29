import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/core/custom_widgets/custom_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 206.5.h),
            Assets.images.splashicon.image(
              width: 300.w,
              height: 277.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text:
                  'Work Smarter, Not Harder',
                  textAlign: TextAlign.center,
                    color: AppColors.primaryTextColor,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 9.h),
                CustomText(text:
                  "Let's be effective on how we Create Lean Informed Organizations.",
                  textAlign: TextAlign.center,
                    color: AppColors.secondaryTextColor,
                    fontsize: 12.sp,

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
