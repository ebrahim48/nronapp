import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/setting_controller.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  late final SettingsController _ctrl;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(SettingsController());
  }

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
          text: 'Contact Support',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: _sent ? _buildSuccess() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 32.h),

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

          CustomTextField(
            controller: _ctrl.subjectController,
            labelText: 'Subject',
            hintText: 'Subject',
            prefixIcon: Icon(
              Icons.grid_view_outlined,
              color: AppColors.secondaryTextColor,
              size: 18.r,
            ),
          ),

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
                      controller: _ctrl.messageController,
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

          Obx(() => CustomButton(
                title: 'Submit',
                loading: _ctrl.isSubmittingSupport.value,
                onpress: () async {
                  final ok = await _ctrl.submitContactSupport();
                  if (ok && mounted) setState(() => _sent = true);
                },
                titlecolor: AppColors.blackColor,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: const Color(0xFF0F2A1A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2E6B47),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                color: const Color(0xFF4ADE80),
                size: 40.r,
              ),
            ),
            SizedBox(height: 20.h),
            CustomText(
              text: 'Message Sent!',
              fontsize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text:
                  'Your message has been sent to our support team. We will get back to you shortly.',
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
              textHeight: 1.5,
            ),
            SizedBox(height: 32.h),
            CustomButton(
              title: 'Send Another',
              loading: false,
              onpress: () => setState(() => _sent = false),
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
