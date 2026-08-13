import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:nron_app/core/config/app-routes/app_routes.dart';
import 'package:nron_app/core/helpers/prefs_helper.dart';
import 'package:nron_app/core/services/api_service.dart';
import 'package:nron_app/core/services/connectivity_service.dart';
import 'package:nron_app/core/utils/app_colors.dart';
import 'package:nron_app/core/utils/manager_controller_cleaner.dart';
import 'package:nron_app/features/auth/data/auth_temp_data.dart';
import 'package:nron_app/features/auth/data/repositories/auth_repository.dart';

import '../../../ representative/settingsprofile/controller/setting_controller.dart';

class AuthAppleButton extends StatefulWidget {
  const AuthAppleButton({super.key});

  @override
  State<AuthAppleButton> createState() => _AuthAppleButtonState();
}

class _AuthAppleButtonState extends State<AuthAppleButton> {
  bool _isLoading = false;

  final _repo = AuthRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  Future<void> _onTap() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Native Apple sheet — returns the identity token on-device. Apple only
      // sends the name on the FIRST authorization, so forward it when present.
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw Exception('Failed to obtain Apple identity token');
      }

      final givenName = credential.givenName ?? '';
      final familyName = credential.familyName ?? '';
      final fullName = '$givenName $familyName'.trim();

      // Role is chosen before login (RoleSelectionScreen); default representative.
      final role = AuthTempData.selectedRole;

      developer.log('[AppleLogin] role=$role, name="$fullName"',
          name: 'AppleLogin');

      final res = await _repo.signInWithApple(
        identityToken: identityToken,
        role: role,
        fullName: fullName,
      );

      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>? ?? {};
        final token = (data['accessToken'] ?? data['token'] ?? '').toString();
        final results = (data['results'] as Map<String, dynamic>?) ?? {};
        final resolvedRole = (results['role'] ?? role).toString();
        final userId = (results['_id'] ?? results['id'] ?? '').toString();

        await PrefsHelper.setString('auth_token', token);
        await PrefsHelper.setString(
            'auth_refresh_token', data['refreshToken']?.toString() ?? '');
        await PrefsHelper.setString('user_role', resolvedRole);
        await PrefsHelper.setString('user_id', userId);

        _navigateByRole(resolvedRole, results);
      } else {
        _showError(
          res['message']?.toString() ?? 'Apple sign-in failed. Please try again.',
        );
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      // User tapped Cancel on the Apple sheet — treat as a no-op, not an error.
      if (e.code == AuthorizationErrorCode.canceled) {
        developer.log('[AppleLogin] cancelled by user', name: 'AppleLogin');
      } else {
        developer.log('[AppleLogin] authorization error: ${e.code} ${e.message}',
            name: 'AppleLogin');
        _showError('Apple sign-in failed. Please try again.');
      }
    } catch (e, st) {
      developer.log('[AppleLogin] failed: $e',
          name: 'AppleLogin', error: e, stackTrace: st);
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateByRole(String role, Map<String, dynamic> results) {
    switch (role) {
      case 'manager':
        ManagerControllerCleaner.clear();
        AppRoutes.goRouter.go(AppRoutes.managerBottomNavBar);
        break;
      case 'driver':
        final isSetupCompleted =
            results['isProfileSetupCompleted'] as bool? ?? true;
        if (!isSetupCompleted) {
          AppRoutes.goRouter.go(AppRoutes.personalInfoScreen, extra: true);
        } else {
          AppRoutes.goRouter.go(AppRoutes.driverBottomNavBar);
        }
        break;
      case 'representative':
      default:
        ManagerControllerCleaner.clear();
        if (Get.isRegistered<SettingsController>()) {
          Get.delete<SettingsController>(force: true);
        }
        AppRoutes.goRouter.go(AppRoutes.repBottomNavBar);
        break;
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1E1E),
        margin: EdgeInsets.all(16.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Native Sign in with Apple is only available on Apple platforms.
    if (!(Platform.isIOS || Platform.isMacOS)) {
      return const SizedBox.shrink();
    }

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
                      Icons.apple,
                      color: AppColors.textColorF5F5F5F5,
                      size: 22,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Continue with Apple',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColorF5F5F5F5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
