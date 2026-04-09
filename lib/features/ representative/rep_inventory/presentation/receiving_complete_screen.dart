import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';

class ReceivingSessionCompleteScreen extends StatelessWidget {
  const ReceivingSessionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Receiving Session',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            SizedBox(height: 30.h),


            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.3),
                    AppColors.primaryColor.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check,
                      color: Colors.white, size: 30.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            CustomText(
              text: 'Receiving Session\nComplete',
              fontsize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textHeight: 1.4,
            ),
            SizedBox(height: 6.h),
            CustomText(
              text: 'Session #XYZ5416 Verified successfully',
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
            ),
            SizedBox(height: 24.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Scanning Summary',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D500).withValues(alpha: 0.15),
                          border: Border.all(
                              color: const Color(0xFF00D500), width: 0.8),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          text: 'All items verified',
                          fontsize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00D500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Divider(
                      color: const Color(0xFF3A3A3A),
                      height: 1,
                      thickness: 0.5),
                  SizedBox(height: 10.h),
                  _SummaryRow(
                      label: 'Total Items Received', value: '50/50'),
                  _SummaryRow(
                      label: 'Expected', value: '50 (from MedTech Inc.)'),
                  _SummaryRow(
                      label: 'Scanned',
                      value: '50 (Serials #XYZ545 to #ABC254)'),
                ],
              ),
            ),

            const Spacer(),


            CustomButton(
              title: 'Add to Inventory',
              suffixIcon: Icon(Icons.save_outlined,
                  color: AppColors.primaryTextColor, size: 18.r),
              onpress: () => Navigator.pop(context),
            ),
            SizedBox(height: 10.h),
            CustomButton(
              title: 'Back to Inventory',
              color: Colors.transparent,
              borderColor: AppColors.primaryColor,
              prefixIcon: Icon(Icons.arrow_back,
                  color: AppColors.primaryTextColor, size: 18.r),
              onpress: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          CustomText(
            text: value,
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}