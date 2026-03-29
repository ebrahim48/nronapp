import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../model/onboarding_data.dart';

class OnboardingSlidePage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingSlidePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image card — 345x330, borderRadius 16, color #332F2F
          Container(
            width: 345.w,
            height: 330.h,
            decoration: BoxDecoration(
              color: const Color(0xff332F2F),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Image.asset(
                data.imagePath,
                width: 235.w,
                height: 208.h,
                fit: BoxFit.contain,
                color: data.applyBlend ? Colors.white : null,
                colorBlendMode: data.applyBlend ? BlendMode.softLight : null,
              ),
            ),
          ),

          SizedBox(height: 42.h),

          // Text section
          SizedBox(
            width: 345.w,
            child: Column(
              children: [
                CustomText(
                  text: data.title,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: data.subtitle,
                  maxline: data.subtitleMaxLines,
                  textOverflow: TextOverflow.clip,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.center,
                  textHeight: 1.2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
