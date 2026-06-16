import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/core/utils/app_colors.dart';

import '../../../core/custom_widgets/animated_entry.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../../../core/custom_widgets/custom_text.dart';
import '../../../core/custom_widgets/custom_text_field.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../auth/presentation/widgets/auth_field_label.dart';
import '../../auth/presentation/widgets/auth_grid_decoration.dart';
import 'controllers/reset_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.put(ResetController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Positioned(top: 0, right: 0, child: AuthGridDecoration()),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),

                AnimatedEntry(
                  delay: const Duration(milliseconds: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: AppColors.primaryTextColor, size: 22.r),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                AnimatedEntry(
                  delay: const Duration(milliseconds: 80),
                  child: Center(
                    child: Assets.images.logo.image(
                      width: 158.w, height: 125.h, fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                AnimatedEntry(
                  delay: const Duration(milliseconds: 160),
                  child: CustomText(
                    text: 'Reset Password',
                    fontsize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 8.h),

                AnimatedEntry(
                  delay: const Duration(milliseconds: 240),
                  child: CustomText(
                    text: 'Create a new password for your account.',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 32.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // New Password
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 320),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthFieldLabel(label: 'New Password *'),
                            Obx(() => CustomTextField(
                              controller: _c.passwordCtrl,
                              hintText: 'Enter new password',
                              isPassword: true,
                              errorText: _c.passwordError.value.isEmpty
                                  ? null
                                  : _c.passwordError.value,
                              onChanged: (_) => _c.validatePassword(),
                            )),
                          ],
                        ),
                      ),

                      // Confirm Password
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthFieldLabel(label: 'Confirm Password *'),
                            Obx(() => CustomTextField(
                              controller: _c.confirmPasswordCtrl,
                              hintText: 'Re-enter new password',
                              isPassword: true,
                              errorText: _c.confirmPasswordError.value.isEmpty
                                  ? null
                                  : _c.confirmPasswordError.value,
                              onChanged: (_) => _c.validateConfirmPassword(),
                            )),
                          ],
                        ),
                      ),

                      // General error
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 400),
                        child: Obx(() {
                          if (_c.generalError.value.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: CustomText(
                              text: _c.generalError.value,
                              fontsize: 12.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 200.h),

                      AnimatedEntry(
                        delay: const Duration(milliseconds: 480),
                        child: Obx(() => CustomButton(
                          title: 'Reset Password',
                          loading: _c.isLoading.value,
                          onpress: () => _c.resetPassword(context),
                        )),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
