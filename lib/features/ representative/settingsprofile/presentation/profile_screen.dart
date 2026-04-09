import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/password_field.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/profile_header.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/profile_state_row.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../controller/setting_controller.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SettingsController>();
    final profile = c.userProfile;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 60.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Profile',
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: 'Manage your account and preferences',
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Top profile area (scrollable background) ──────────
          Expanded(
            child: SingleChildScrollView(
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                children: [
                  ProfileHeaderWidget(profile: profile),
                  SizedBox(height: 20.h),
                  // Stats with rating
                  ProfileStatsRow(profile: profile, showRating: true),
                ],
              ),
            ),
          ),

          // ── Password Change bottom sheet ──────────────────────
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E2427),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),

                Center(
                  child: CustomText(
                    text: 'Password Change',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),

                SizedBox(height: 16.h),

                // Current Password
                PasswordField(
                  controller: c.currentPasswordController,
                  hint: 'Current password',
                  isVisible: c.showCurrentPassword,
                  onToggle: () => c.showCurrentPassword.toggle(),
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: CustomText(
                        text: 'Forgot Password?',
                        fontsize: 12.sp,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),

                // New Password
                PasswordField(
                  controller: c.newPasswordController,
                  hint: 'Enter New password',
                  isVisible: c.showNewPassword,
                  onToggle: () => c.showNewPassword.toggle(),
                ),

                // Confirm Password
                PasswordField(
                  controller: c.confirmPasswordController,
                  hint: 'Confirm New password',
                  isVisible: c.showConfirmPassword,
                  onToggle: () => c.showConfirmPassword.toggle(),
                ),

                SizedBox(height: 8.h),

                // Save Change
                CustomButton(
                  title: 'Save Change',
                  onpress: c.savePasswordChange,
                  titlecolor: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}