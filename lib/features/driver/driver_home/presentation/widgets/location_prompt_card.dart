import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/custom_widgets/custom_button.dart';
import '../../controller/driver_home_controller.dart';

class LocationPromptCard extends StatelessWidget {
  const LocationPromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverHomeController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 65.r,
                height: 65.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.blackColor,
                  size: 22.r,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          CustomText(
            text: 'Enable your location',
            fontsize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),

          SizedBox(height: 8.h),

          CustomText(
            text: 'Choose your location to start find the request around you',
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          CustomButton(
            title: 'Use my location',
            onpress: c.useMyLocation,
            titlecolor: AppColors.blackColor,
            fontWeight: FontWeight.w700,
            borderRadius: 30,
          ),

          SizedBox(height: 10.h),

          GestureDetector(
            onTap: c.skipLocation,
            child: Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Center(
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}