import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/setting_controller.dart';


class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingsController());

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
          text: 'Contact Support',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 32.h),

            // Icon circle
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent_outlined,
                color: AppColors.secondaryTextColor,
                size: 38.r,
              ),
            ),

            SizedBox(height: 16.h),

            // Faded "Contact Support" watermark text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.warningColor.withValues(alpha: 0.3),
                  AppColors.warningColor.withValues(alpha: 0.1),
                ],
              ).createShader(bounds),
              child: Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Subject field
            CustomTextField(
              controller: c.subjectController,
              labelText: 'Subject',
              hintText: 'Subject',
              prefixIcon: Icon(
                Icons.grid_view_outlined,
                color: AppColors.secondaryTextColor,
                size: 18.r,
              ),
            ),

            // Message field
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Your Message',
                    bottom: 6.h,
                    left: 2.w,
                    color: AppColors.primaryTextColor,
                  ),
                  Stack(
                    children: [
                      CustomTextField(
                        controller: c.messageController,
                        hintText: 'How can we help you?',
                        maxLine: 4,
                        contentPaddingHorizontal: 44.w,
                      ),
                      Positioned(
                        left: 12.w,
                        top: 14.h,
                        child: Icon(
                          Icons.chat_bubble_outline,
                          color: AppColors.secondaryTextColor,
                          size: 18.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Submit button
            CustomButton(
              title: 'Submit',
              onpress: c.submitContactSupport,
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}