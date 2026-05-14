import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/driver_job_model.dart';

class CompletedJobCard extends StatelessWidget {
  final CompletedJobModel job;
  final VoidCallback? onTap;

  const CompletedJobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: job.shipmentId,
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                textAlign: TextAlign.start,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: '\$${job.earnings.toStringAsFixed(2)}',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003A00),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1DB954),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 4.h),

          CustomText(
            text: job.type,
            fontsize: 11.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 12.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.circle_outlined,
                        color: AppColors.primaryColor, size: 14.r),
                  ),
                  Container(
                      width: 1.5,
                      height: 30.h,
                      color: const Color(0xFF3A3A3A)),
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.location_on_outlined,
                        color: AppColors.primaryColor, size: 14.r),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Pickup',
                      fontsize: 9.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: job.pickup,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'Drop-off',
                      fontsize: 9.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: job.dropoff,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(
              height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),

          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(Icons.access_time_outlined,
                  color: AppColors.secondaryTextColor, size: 13.r),
              SizedBox(width: 4.w),
              CustomText(
                text: 'Completed at ${job.completedAt}',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
