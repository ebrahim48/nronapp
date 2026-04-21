import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const _points = [
    'By using the H.O.L.E platform, you agree to be bound by these Terms and Conditions. Please read them carefully before accessing or using any features of the application.',
    'All content, data, and transactions conducted through H.O.L.E are intended solely for authorized business users. Unauthorized access, sharing of credentials, or misuse of the platform is strictly prohibited.',
    'Users are responsible for maintaining the confidentiality of their account credentials and for all activities that occur under their account. Any suspected unauthorized use must be reported immediately.',
    'H.O.L.E reserves the right to modify, suspend, or discontinue any part of the service at any time without prior notice. Continued use of the platform constitutes acceptance of any revised terms.',
    'All intellectual property rights in the platform, including but not limited to software, design, and content, are owned by or licensed to H.O.L.E. You may not reproduce or distribute any part of the platform without express written permission.',
  ];

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
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Terms & Conditions',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  'assets/images/privacy.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.gavel_outlined,
                      color: AppColors.primaryColor,
                      size: 64.r,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            CustomText(
              text: 'Terms & Conditions',
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 12.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _points.map((point) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 6.h, right: 8.w),
                          child: Container(
                            width: 5.r,
                            height: 5.r,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryTextColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            point,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontFamily: 'Poppins',
                              color: AppColors.secondaryTextColor,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
