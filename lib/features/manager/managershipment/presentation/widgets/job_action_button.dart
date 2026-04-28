import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';

class JobActionButtons extends StatelessWidget {
  final VoidCallback onSendCourierOrder;
  final VoidCallback onCloseJob;

  const JobActionButtons({
    super.key,
    required this.onSendCourierOrder,
    required this.onCloseJob,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Send Courier Order
        GestureDetector(
          onTap: onSendCourierOrder,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping_outlined,
                    color: AppColors.blackColor, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  'Send Courier Order',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // Close Job
        GestureDetector(
          onTap: onCloseJob,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: const Color(0xFF3A3A3A), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close,
                    color: AppColors.primaryTextColor, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  'Close Job',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}