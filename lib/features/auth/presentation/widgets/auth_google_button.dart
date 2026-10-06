import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:nron_app/core/config/app-routes/app_routes.dart';
import 'package:nron_app/core/config/google_sign_in_config.dart';
import 'package:nron_app/core/helpers/prefs_helper.dart';
import 'package:nron_app/core/services/api_service.dart';
import 'package:nron_app/core/services/connectivity_service.dart';
import 'package:nron_app/core/services/google_sign_in_service.dart';
import 'package:nron_app/core/utils/app_colors.dart';
import 'package:nron_app/core/utils/manager_controller_cleaner.dart';
import 'package:nron_app/features/auth/data/auth_temp_data.dart';
import 'package:nron_app/features/auth/data/repositories/auth_repository.dart';

import '../../../ representative/settingsprofile/controller/setting_controller.dart';

class AuthGoogleButton extends StatefulWidget {
  const AuthGoogleButton({super.key});

  @override
  State<AuthGoogleButton> createState() => _AuthGoogleButtonState();
}

class _AuthGoogleButtonState extends State<AuthGoogleButton> {
  bool _isLoading = false;

  final _repo = AuthRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  Future<void> _onTap() async {
    // TEMP DIAGNOSTIC — remove once the flow works.
    debugPrint('[GoogleLogin] TAP RECEIVED (isLoading=$_isLoading, '
        'configured=${GoogleSignInConfig.isConfigured})');
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Native Google account picker — returns the ID token on-device. The
      // server verifies it with Google and issues our own JWTs; no browser
      // redirect involved.
      final account = await GoogleSignInService.authenticate();

      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Failed to obtain Google ID token');
      }

      final fullName = (account.displayName ?? '').trim();


      // Role is chosen before login (RoleSelectionScreen); default representative.
      final role = AuthTempData.selectedRole;

      developer.log('[GoogleLogin] role=$role, name="$fullName"',
          name: 'GoogleLogin');

      final res = await _repo.signInWithGoogle(
        idToken: idToken,
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
          res['message']?.toString() ??
              'Google sign-in failed. Please try again.',
        );
      }
    } on StateError catch (e) {
      // Missing/placeholder client ids — a build configuration problem.
      developer.log('[GoogleLogin] ${e.message}', name: 'GoogleLogin');
      _showError('Google sign-in is not configured yet.');
    } on GoogleSignInException catch (e) {
      // User dismissed the account picker — treat as a no-op, not an error.
      if (e.code == GoogleSignInExceptionCode.canceled) {
        developer.log('[GoogleLogin] cancelled by user', name: 'GoogleLogin');
      } else {
        developer.log('[GoogleLogin] sign-in error: ${e.code} ${e.description}',
            name: 'GoogleLogin');
        _showError(
          kDebugMode
              ? 'Google sign-in failed: ${e.code.name} — ${e.description}'
              : 'Google sign-in failed. Please try again.',
        );
      }
    } catch (e, st) {
      developer.log('[GoogleLogin] failed: $e',
          name: 'GoogleLogin', error: e, stackTrace: st);
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
                      size: 22,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Continue with Google',
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
