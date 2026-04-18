import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/driver_home_model.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class JobRequestCard extends StatelessWidget {
  final JobRequestModel job;
  final VoidCallback? onTap;

  const JobRequestCard({super.key, required this.job, this.onTap});

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
                Row(
                  children: [
                    CustomText(
                      text: job.shipmentId,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    if (job.isUrgent) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.redColorFF1D1D
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'urgent',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: AppColors.redColorFF1D1D,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                CustomText(
                  text: '\$${job.earnings.toStringAsFixed(0)}',
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),

            SizedBox(height: 4.h),

            CustomText(
              text: job.timeAway,
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 10.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DB954),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 24.h,
                      color: const Color(0xFF3A3A3A),
                    ),
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: AppColors.redColorFF1D1D,
                        shape: BoxShape.circle,
                      ),
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
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        text: 'Drop-off',
                        fontsize: 9.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        text: job.dropoff,
                        fontsize: 12.sp,
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
              height: 1,
              color: const Color(0xFF3A3A3A),
              thickness: 0.5,
            ),

            SizedBox(height: 8.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.navigation_outlined,
                        color: AppColors.secondaryTextColor, size: 14.r),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: '${job.distanceKm} km',
                      fontsize: 12.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Icon(Icons.chevron_right,
                    color: AppColors.secondaryTextColor, size: 18.r),
              ],
            ),
          ],
        ),
      ),
    );
  }
}