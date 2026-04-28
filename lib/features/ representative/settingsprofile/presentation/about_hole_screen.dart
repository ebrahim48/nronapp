import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';

class AboutHoleScreen extends StatelessWidget {
  const AboutHoleScreen({super.key});

  static const _points = [
    'H.O.L.E (Healthcare Operations & Logistics Engine) is a cutting-edge B2B field sales and logistics platform designed specifically for the medical device and implant industry.',
    'Our platform empowers sales representatives to efficiently manage implant inventory, create purchase orders, and track real-time sales performance from anywhere in the field.',
    'H.O.L.E connects representatives, managers, and drivers in a seamless workflow — from order creation to delivery — ensuring full visibility across the supply chain.',
    'Built with a focus on accuracy and compliance, H.O.L.E helps organizations reduce manual errors, improve traceability of serialized implants, and streamline commission tracking.',
    'We are committed to providing a reliable and secure platform that meets the evolving needs of the healthcare logistics ecosystem.',
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
          text: 'About H.O.L.E',
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
                  'assets/images/abouthole.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                      size: 64.r,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            CustomText(
              text: 'About H.O.L.E',
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
