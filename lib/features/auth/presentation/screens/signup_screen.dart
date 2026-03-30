import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/core/constants/app_colors.dart';

import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../../../global/custom_assets/assets.gen.dart';
import '../controller/auth_controller.dart';
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
  final _controller = AuthController();

  @override
  void dispose() {
    _controller.dispose();
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

                Center(
                  child: Assets.images.splashicon.image(
                    width: 100.w, height: 100.h, fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 12.h),

                CustomText(
                  text: 'Sign Up now',
                  fontsize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                CustomText(
                  text: 'Create an account or log in to\nexplore about our app',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.center,
                  textHeight: 1.4,
                ),

                SizedBox(height: 24.h),

                Padding(
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

                SizedBox(height: 24.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _controller.signupFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthFieldLabel(label: 'Full Name *'),
                        CustomTextField(
                          controller: _controller.nameController,
                          hintText: 'Name',
                          keyboardType: TextInputType.name,
                        ),

                        AuthFieldLabel(label: 'Email *'),
                        CustomTextField(
                          controller: _controller.signupEmailController,
                          hintText: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          isEmail: true,
                        ),

                        AuthFieldLabel(label: 'Password *'),
                        CustomTextField(
                          controller: _controller.signupPasswordController,
                          hintText: 'Enter your Password',
                          isPassword: true,
                        ),

                        AuthFieldLabel(label: 'Confirm Password *'),
                        CustomTextField(
                          controller: _controller.confirmPasswordController,
                          hintText: 'Enter your Confirm Password',
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please confirm your password';
                            if (value != _controller.signupPasswordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),

                        SizedBox(height: 8.h),

                        CustomButton(
                          title: 'Sign Up',
                          onpress: () => _controller.validateSignUp(),
                        ),

                        SizedBox(height: 20.h),
                        const AuthOrDivider(),
                        SizedBox(height: 16.h),
                        const AuthGoogleButton(),
                        SizedBox(height: 40.h),
                      ],
                    ),
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
