import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
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
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                  text: 'Sign in now',
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
                    isLogin: true,
                    onLoginTap: () {},
                    onSignUpTap: () => Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const SignUpScreen(),
                        transitionDuration: Duration.zero,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _controller.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthFieldLabel(label: 'Email *'),
                        CustomTextField(
                          controller: _controller.loginEmailController,
                          hintText: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          isEmail: true,
                        ),

                        AuthFieldLabel(label: 'Password *'),
                        CustomTextField(
                          controller: _controller.loginPasswordController,
                          hintText: 'Enter your Password',
                          isPassword: true,
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRoutes.forgetPasswordScreen);
                            },
                            child: CustomText(
                              text: 'Forget password',
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryColor,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        CustomButton(
                          title: 'Log In',
                          onpress: () => _controller.validateLogin(),
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
