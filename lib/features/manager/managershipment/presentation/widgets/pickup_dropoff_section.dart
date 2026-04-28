import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class PickupDropoffSection extends StatelessWidget {
  final String pickupDate;
  final String pickupTime;
  final String pickupLocation;
  final String pickupBuilding;
  final String pickupNote;
  final String dropoffEstTime;
  final String dropoffLocation;
  final String dropoffBuilding;
  final String dropoffNote;

  const PickupDropoffSection({
    super.key,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupLocation,
    required this.pickupBuilding,
    required this.pickupNote,
    required this.dropoffEstTime,
    required this.dropoffLocation,
    required this.dropoffBuilding,
    required this.dropoffNote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pickup
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.upload_outlined,
                      color: AppColors.blackColor, size: 16.r),
                ),
                Container(
                  width: 2,
                  height: 100.h,
                  color: const Color(0xFF3A3A3A),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Pickup Details',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: '$pickupDate • $pickupTime',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: pickupLocation,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: pickupBuilding,
                          fontsize: 10.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                color: AppColors.secondaryTextColor,
                                size: 12.r),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: CustomText(
                                text: pickupNote,
                                fontsize: 10.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Dropoff
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Icon(Icons.download_outlined,
                  color: AppColors.secondaryTextColor, size: 16.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Dropoff Details',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: 'Estimated: $dropoffEstTime',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: dropoffLocation,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: dropoffBuilding,
                          fontsize: 10.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_outlined,
                                color: AppColors.warningColor,
                                size: 12.r),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: CustomText(
                                text: dropoffNote,
                                fontsize: 10.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}