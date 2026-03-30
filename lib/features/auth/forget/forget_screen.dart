import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../global/custom_assets/assets.gen.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../../../core/custom_widgets/custom_text.dart';
import '../../../core/custom_widgets/custom_text_field.dart';
import '../../auth/presentation/widgets/auth_field_label.dart';
import '../../auth/presentation/widgets/auth_grid_decoration.dart';
import 'controllers/forget_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key, this.email = ''});

  final String email;

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late ForgetController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ForgetController());
    if (widget.email.isNotEmpty) {
      controller.setEmail(widget.email);
    }
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
                  text: 'Forgot Password',
                  fontsize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Subtitle
                CustomText(
                  text: 'Enter email address to reset your password.',
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
                      AuthFieldLabel(label: 'Email *'),
                      Obx(
                        () => CustomTextField(
                          controller: controller.emailCtrl,
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          isEmail: true,
                          errorText: controller.emailError.value.isEmpty
                              ? null
                              : controller.emailError.value,
                          onChanged: (_) => controller.validateEmail(),
                        ),
                      ),

                      SizedBox(height: 200.h),

                      Obx(
                        () => CustomButton(
                          title: controller.isLoading.value ? 'Sending...' : 'Send Code',
                          loading: controller.isLoading.value,
                          onpress: () {
                            context.pushNamed(AppRoutes.verifyScreen);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
