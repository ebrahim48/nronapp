import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/core/constants/api_constants.dart';
import 'package:nron_app/core/utils/app_colors.dart';
import 'package:nron_app/features/auth/data/auth_temp_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthGoogleButton extends StatefulWidget {
  const AuthGoogleButton({super.key});

  @override
  State<AuthGoogleButton> createState() => _AuthGoogleButtonState();
}

class _AuthGoogleButtonState extends State<AuthGoogleButton> {
  bool _isLoading = false;

  Future<void> _onTap() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Read role at tap time — not at build time — so it's always current
      final role = AuthTempData.selectedRole;
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.loginWithGoogle(role),
      );

      // Open in external browser
      // app_links in main.dart will intercept nron://oauth-callback
      // inAppBrowserView (Custom Tab) closes automatically when the
      // nron://oauth-callback deep link is caught by MainActivity
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } catch (_) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Could not open browser. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: Colors.white,
          margin: EdgeInsets.all(16.r),
          borderRadius: 10.r,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: 345.w,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.secondaryTextColor.withValues(alpha: 0.4),
          ),
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
            width: 20.r,
            height: 20.r,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                  Icons.g_mobiledata,
                  color: AppColors.textColorF5F5F5F5,
                  size: 22),
              SizedBox(width: 8.w),
              Text(
                'Continue with Google',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColorF5F5F5F5

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}