import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';

class ReportSuccessScreen extends StatelessWidget {
  const ReportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),


              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A3A3A),
                ),
                child: Center(
                  child: Container(
                    width: 58.r,
                    height: 58.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.primaryColor,
                        size: 28.r,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              CustomText(
                text: 'Report Submitted\nSuccessfully!',
                fontsize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.center,
                textHeight: 1.3,
              ),

              SizedBox(height: 10.h),

              SizedBox(
                width: 280.w,
                child: CustomText(
                  text:
                  'Your submission has been received and is being processed by the vendor team.',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.center,
                  textHeight: 1.5,
                ),
              ),

              SizedBox(height: 28.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFEC5B131A).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFEC5B131A).withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Report ID',
                      value: 'RPT-22458',
                      valueWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 12.h),
                    _InfoRow(
                      label: 'Sent to',
                      value: 'MedTech Inc.',
                      valueWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 12.h),
                    _InfoRow(
                      label: 'Status',
                      valueWidget: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6A817).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.r,
                              height: 6.r,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE6A817),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            CustomText(
                              text: 'IN PROGRESS',
                              fontsize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE6A817),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2A3A),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.primaryColor, size: 16.r),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomText(
                        text:
                        'Vendor will respond within 24 hours. An email thread has been automatically created between you and the vendor.',
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                        textHeight: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoutes.trayDetailsScreen);
                },
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Center(
                    child: CustomText(
                      text: 'Back to Tray Details',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              GestureDetector(
                onTap: () {
                },
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mail_outline,
                          color: AppColors.primaryTextColor, size: 16.r),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'View Sent Email',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final FontWeight valueWeight;
  final Widget? valueWidget;

  const _InfoRow({
    required this.label,
    this.value,
    this.valueWeight = FontWeight.w400,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontsize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.start,
        ),
        valueWidget ??
            CustomText(
              text: value ?? '',
              fontsize: 13.sp,
              fontWeight: valueWeight,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.end,
            ),
      ],
    );
  }
}