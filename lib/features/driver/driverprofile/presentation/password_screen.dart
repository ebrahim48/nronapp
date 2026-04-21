import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/driver_avatar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/change_password_controller.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _ctrl = ChangePasswordController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      height: 52.h,
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.dotButtonInactiveColor, width: 0.8),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Icon(Icons.key_outlined,
              color: AppColors.secondaryTextColor, size: 18.r),
          SizedBox(width: 10.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              validator: validator,
              style: TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 13.sp,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppColors.secondaryTextColor,
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.secondaryTextColor,
                size: 18.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SafeArea(
            child: Column(
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 14.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios_new,
                            color: AppColors.primaryTextColor,
                            size: 18.r),
                      ),
                      SizedBox(width: 12.w),
                      CustomText(
                        text: 'Profile',
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      DriverAvatar(initial: 'A', isOnline: true),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Driver Alex',
                            fontsize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            text: 'ID: DRV-2847',
                            fontsize: 12.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CustomText(
                          text: 'Available for Jobs',
                          fontsize: 13.sp,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        const Spacer(),
                        Switch(
                          value: true,
                          onChanged: (_) {},
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6.h),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r)),
                    ),
                    child: Column(
                      children: [
                        // Drag handle
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A3A3A),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        Expanded(
                          child: Form(
                            key: _ctrl.formKey,
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w, 0, 16.w, 100.h),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: CustomText(
                                          text: 'Password Change',
                                          fontsize: 17.sp,
                                          fontWeight:
                                          FontWeight.w700,
                                          color:
                                          AppColors.primaryTextColor,
                                        ),
                                      ),
                                      SizedBox(height: 22.h),

                                      // Current password
                                      _passwordField(
                                        controller: _ctrl
                                            .currentPasswordController,
                                        hint: 'Current password',
                                        obscure: _ctrl.obscureCurrent,
                                        onToggle: _ctrl.toggleCurrent,
                                        validator: (v) =>
                                        (v?.isEmpty ?? true)
                                            ? 'Enter current password'
                                            : null,
                                      ),

                                      // Forgot password
                                      Align(
                                        alignment:
                                        Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: CustomText(
                                            text: 'Forgot Password?',
                                            fontsize: 12.sp,
                                            fontWeight:
                                            FontWeight.w500,
                                            color:
                                            AppColors.primaryColor,
                                            right: 2.w,
                                            bottom: 14.h,
                                          ),
                                        ),
                                      ),

                                      // New password
                                      _passwordField(
                                        controller:
                                        _ctrl.newPasswordController,
                                        hint: 'Enter New password',
                                        obscure: _ctrl.obscureNew,
                                        onToggle: _ctrl.toggleNew,
                                        validator: (v) {
                                          if (v?.isEmpty ?? true) {
                                            return 'Enter new password';
                                          }
                                          if ((v?.length ?? 0) < 8) {
                                            return 'Min 8 characters';
                                          }
                                          return null;
                                        },
                                      ),

                                      // Confirm password
                                      _passwordField(
                                        controller: _ctrl
                                            .confirmPasswordController,
                                        hint: 'Confirm New password',
                                        obscure: _ctrl.obscureConfirm,
                                        onToggle:
                                        _ctrl.toggleConfirm,
                                        validator: (v) {
                                          if (v !=
                                              _ctrl
                                                  .newPasswordController
                                                  .text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Sticky Save Change button
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: const Color(0xFF1A1A1A),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h),
                                    child: CustomButton(
                                      title: 'Save Change',
                                      loading: _ctrl.isLoading,
                                      onpress: () async {
                                        final ok =
                                        await _ctrl.saveChange();
                                        if (ok && context.mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Password changed!'),
                                              backgroundColor:
                                              AppColors.primaryColor,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


