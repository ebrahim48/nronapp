import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../global/custom_assets/assets.gen.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../../../core/custom_widgets/custom_text.dart';
import '../../../core/custom_widgets/custom_text_field.dart';
import '../../auth/presentation/widgets/auth_field_label.dart';
import '../../auth/presentation/widgets/auth_grid_decoration.dart';
import 'controllers/reset_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ResetController());
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

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryTextColor,
                        size: 22.r,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // Logo
                Center(
                  child: Assets.images.splashicon.image(
                    width: 158.w,
                    height: 125.h,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 24.h),

                // Title
                CustomText(
                  text: 'Reset Password',
                  fontsize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Subtitle
                CustomText(
                  text: 'Reset your password',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthFieldLabel(label: 'New Password *'),
                      Obx(
                        () => CustomTextField(
                          controller: controller.passwordCtrl,
                          hintText: 'Enter new password',
                          isPassword: true,
                          errorText: controller.passwordError.value.isEmpty
                              ? null
                              : controller.passwordError.value,
                          onChanged: (_) => controller.validatePassword(),
                        ),
                      ),

                      AuthFieldLabel(label: 'Confirm Password *'),
                      Obx(
                        () => CustomTextField(
                          controller: controller.confirmPasswordCtrl,
                          hintText: 'Re-enter new password',
                          isPassword: true,
                          errorText:
                              controller.confirmPasswordError.value.isEmpty
                                  ? null
                                  : controller.confirmPasswordError.value,
                          onChanged: (_) =>
                              controller.validateConfirmPassword(),
                        ),
                      ),

                      SizedBox(height: 200.h),

                      Obx(
                        () => CustomButton(
                          title: controller.isLoading.value
                              ? 'Resetting...'
                              : 'Reset Password',
                          loading: controller.isLoading.value,
                          onpress: () {

                          },
                        ),
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
