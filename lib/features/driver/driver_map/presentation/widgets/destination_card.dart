import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class DestinationCard extends StatelessWidget {
  final String destinationName;
  final VoidCallback onCall;

  const DestinationCard({
    super.key,
    required this.destinationName,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A1A),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
            color: AppColors.redColorFF1D1D.withValues(alpha: 0.3),
            width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: AppColors.redColorFF1D1D.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on_outlined,
                color: AppColors.redColorFF1D1D, size: 18.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Destination',
                  fontsize: 9.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: destinationName,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCall,
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone_outlined,
                  color: AppColors.blackColor, size: 16.r),
            ),
          ),
        ],
      ),
    );
  }
}