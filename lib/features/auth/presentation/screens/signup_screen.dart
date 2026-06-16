import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/core/utils/app_colors.dart';

import '../../../../core/custom_widgets/animated_entry.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../../../global/custom_assets/assets.gen.dart';
import '../../data/auth_temp_data.dart';
import '../controller/register_controller.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/auth_grid_decoration.dart';
import '../widgets/auth_or_divider.dart';
import '../widgets/auth_tab_switcher.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late RegisterController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.put(RegisterController());
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
                  child: Center(
                    child: Assets.images.logo.image(
                      width: 100.w, height: 100.h, fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                AnimatedEntry(
                  delay: const Duration(milliseconds: 80),
                  child: CustomText(
                    text: 'Sign Up now',
                    fontsize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 4.h),

                AnimatedEntry(
                  delay: const Duration(milliseconds: 160),
                  child: CustomText(
                    text: 'Create an account or log in to\nexplore about our app',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.center,
                    textHeight: 1.4,
                  ),
                ),

                SizedBox(height: 24.h),

                AnimatedEntry(
                  delay: const Duration(milliseconds: 240),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: AuthTabSwitcher(
                      isLogin: false,
                      onLoginTap: () => Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const SignInScreen(),
                          transitionDuration: Duration.zero,
                        ),
                      ),
                      onSignUpTap: () {},
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 320),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthFieldLabel(label: 'Full Name *'),
                            Obx(() => CustomTextField(
                              controller: _c.fullNameCtrl,
                              hintText: 'Full name',
                              keyboardType: TextInputType.name,
                              errorText: _c.fullNameError.value.isEmpty
                                  ? null
                                  : _c.fullNameError.value,
                              onChanged: (_) {
                                if (_c.fullNameError.value.isNotEmpty) {
                                  _c.fullNameError.value = '';
                                }
                              },
                            )),
                          ],
                        ),
                      ),

                      // Email
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthFieldLabel(label: 'Email *'),
                            Obx(() => CustomTextField(
                              controller: _c.emailCtrl,
                              hintText: 'E-mail',
                              keyboardType: TextInputType.emailAddress,
                              isEmail: true,
                              errorText: _c.emailError.value.isEmpty
                                  ? null
                                  : _c.emailError.value,
                              onChanged: (_) {
                                if (_c.emailError.value.isNotEmpty) {
                                  _c.emailError.value = '';
                                }
                              },
                            )),
                          ],
                        ),
                      ),

                      // Password
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 480),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthFieldLabel(label: 'Password *'),
                            Obx(() => CustomTextField(
                              controller: _c.passwordCtrl,
                              hintText: 'Enter your Password',
                              isPassword: true,
                              errorText: _c.passwordError.value.isEmpty
                                  ? null
                                  : _c.passwordError.value,
                              onChanged: (_) {
                                if (_c.passwordError.value.isNotEmpty) {
                                  _c.passwordError.value = '';
                                }
                              },
                            )),
                          ],
                        ),
                      ),

                      // Confirm Password
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 560),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthFieldLabel(label: 'Confirm Password *'),
                            Obx(() => CustomTextField(
                              controller: _c.confirmPasswordCtrl,
                              hintText: 'Re-enter your Password',
                              isPassword: true,
                              errorText: _c.confirmPasswordError.value.isEmpty
                                  ? null
                                  : _c.confirmPasswordError.value,
                              onChanged: (_) {
                                if (_c.confirmPasswordError.value.isNotEmpty) {
                                  _c.confirmPasswordError.value = '';
                                }
                              },
                            )),
                          ],
                        ),
                      ),

                      // General error
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 560),
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

                      SizedBox(height: 8.h),

                      AnimatedEntry(
                        delay: const Duration(milliseconds: 640),
                        child: Obx(() => CustomButton(
                          title: 'Sign Up',
                          loading: _c.isLoading.value,
                          onpress: () => _c.register(
                            context,
                            role: AuthTempData.selectedRole,
                          ),
                        )),
                      ),

                      SizedBox(height: 20.h),
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 720),
                        child: const AuthOrDivider(),
                      ),
                      SizedBox(height: 16.h),
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 800),
                        child: const AuthGoogleButton(),
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
