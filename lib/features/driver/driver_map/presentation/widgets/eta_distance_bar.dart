import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class EtaDistanceBar extends StatelessWidget {
  final String eta;
  final String distance;

  const EtaDistanceBar({
    super.key,
    required this.eta,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 344.6.w,
      height: 78.58.h,
      padding: EdgeInsets.only(
        left: 17.3.w,
        right: 17.3.w,
        top: 17.3.h,
        bottom: 1.3.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12, width: 1.3.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_outlined,
                      color: AppColors.primaryColor, size: 14.r),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: 'ETA to Pickup',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: eta,
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: 'Distance',
                fontsize: 10.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: distance,
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}