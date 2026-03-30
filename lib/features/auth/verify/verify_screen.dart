import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../global/custom_assets/assets.gen.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../../../core/custom_widgets/custom_text.dart';
import '../../auth/presentation/widgets/auth_grid_decoration.dart';
import 'controller/verify_controller.dart';
import 'widgets/custom_pin_code.dart';

class VerifyScreen extends StatefulWidget {


  const VerifyScreen({
    super.key,

  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController otpController = TextEditingController();
  late VerifyController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VerifyController());
    controller.startCountdown();
  }

  @override
  void dispose() {
    try {
      otpController.dispose();
    } catch (_) {}
    super.dispose();
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

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      CustomText(
                        text: 'Enter verification code',
                        fontsize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 12.h),

                      // Subtitle
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryTextColor,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text: "We've sent a verification code to ",
                            ),
                            TextSpan(
                              text: 'email',
                              style: TextStyle(
                                color: AppColors.primaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' that will expire in 10 minutes. Please enter the code to continue',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // OTP boxes
                      CustomPinCodeTextField(
                        textEditingController: otpController,
                      ),

                      SizedBox(height: 16.h),

                      // Resend row
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Didn't receive the code?",
                              fontsize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryTextColor,
                            ),
                            GestureDetector(
                              onTap: controller.isCountingDown.value
                                  ? null
                                  : () => controller.resendOtp(),
                              child: CustomText(
                                text: controller.isCountingDown.value
                                    ? 'Resend ${controller.countdown.value}s'
                                    : 'Resend',
                                fontsize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: controller.isCountingDown.value
                                    ? AppColors.secondaryTextColor
                                    : const Color(0xFFFF2828),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 200.h),

                      // Continue button
                      Obx(
                        () => CustomButton(
                          title: controller.isLoading.value
                              ? 'Verifying...'
                              : 'Verify',
                          loading: controller.isLoading.value,
                          onpress: () {
                            context.pushNamed(AppRoutes.resetPasswordScreen);

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
