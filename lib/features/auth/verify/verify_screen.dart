import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/core/utils/app_colors.dart';

import '../../../core/custom_widgets/animated_entry.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../../../core/custom_widgets/custom_text.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../auth/presentation/widgets/auth_grid_decoration.dart';
import '../data/auth_temp_data.dart';
import 'controller/verify_controller.dart';
import 'widgets/custom_pin_code.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // Track OTP as a plain String — no TextEditingController needed.
  // This avoids the double-dispose that occurs because pin_code_fields
  // disposes any TextEditingController it receives internally.
  String _otp = '';
  late VerifyController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.put(VerifyController());
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
                    child: Assets.images.splashicon.image(
                      width: 158.w, height: 125.h, fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 160),
                        child: CustomText(
                          text: 'Enter verification code',
                          fontsize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      AnimatedEntry(
                        delay: const Duration(milliseconds: 240),
                        child: RichText(
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
                              const TextSpan(text: "We've sent a verification code to "),
                              TextSpan(
                                text: AuthTempData.email,
                                style: TextStyle(
                                  color: AppColors.primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text: ' that will expire in 10 minutes. Please enter the code to continue',
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      AnimatedEntry(
                        delay: const Duration(milliseconds: 320),
                        child: CustomPinCodeTextField(
                          onChanged: (v) => _otp = v,
                          onCompleted: (v) => _otp = v,
                        ),
                      ),

                      // OTP error
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 320),
                        child: Obx(() {
                          if (_c.otpError.value.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: CustomText(
                              text: _c.otpError.value,
                              fontsize: 12.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 16.h),

                      AnimatedEntry(
                        delay: const Duration(milliseconds: 400),
                        child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Didn't receive the code?",
                              fontsize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryTextColor,
                            ),
                            GestureDetector(
                              onTap: _c.isCountingDown.value
                                  ? null
                                  : () => _c.resendOtp(),
                              child: CustomText(
                                text: _c.isCountingDown.value
                                    ? 'Resend ${_c.countdown.value}s'
                                    : 'Resend',
                                fontsize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: _c.isCountingDown.value
                                    ? AppColors.secondaryTextColor
                                    : const Color(0xFFFF2828),
                              ),
                            ),
                          ],
                        )),
                      ),

                      // General error
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 400),
                        child: Obx(() {
                          if (_c.generalError.value.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
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
                          title: 'Verify',
                          loading: _c.isLoading.value,
                          onpress: () => _c.verify(context, _otp),
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
