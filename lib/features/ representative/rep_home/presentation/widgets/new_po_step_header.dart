import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../../core/custom_widgets/custom_text.dart';

class NewPoStepHeader extends StatelessWidget {
  const NewPoStepHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step label
          CustomText(
            text: 'Step 01 of 03',
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 2.h),

          // Title + counter row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Select Order Type',
                fontsize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '1',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: '/3',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Progress bar
          SizedBox(
            width: 342.w,
            height: 6.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: LinearProgressIndicator(
                value: 1 / 3,
                backgroundColor: const Color(0xFF332F2F),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Available Categories label
          CustomText(
            text: 'Available Categories',
            fontsize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}