import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/repositories/auth_repository.dart';

class SignInController extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isLoading = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final generalError = ''.obs;

  final _repo = AuthRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  static const _emailRx = r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$';

  Future<void> login(BuildContext context) async {
    emailError.value = '';
    passwordError.value = '';
    generalError.value = '';

    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    bool valid = true;
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      valid = false;
    } else if (!RegExp(_emailRx).hasMatch(email)) {
      emailError.value = 'Enter a valid email address';
      valid = false;
    }
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      valid = false;
    } else if (password.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      valid = false;
    }
    if (!valid) return;

    try {
      isLoading.value = true;
      final res = await _repo.login(email: email, password: password);

      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>? ?? {};
        debugPrint('LOGIN DATA KEYS: ${data.keys.toList()}');
        debugPrint('LOGIN TOKEN: ${data['token']}');
        debugPrint('LOGIN accessToken: ${data['accessToken']}');
        debugPrint('LOGIN FULL DATA: $data');
        await PrefsHelper.setString('auth_token', data['token'] ?? '');
        await PrefsHelper.setString('auth_refresh_token', data['refreshToken'] ?? '');
        final role = (data['results']?['role'] ?? 'representative').toString();
        await PrefsHelper.setString('user_role', role);

        if (context.mounted) _navigateByRole(context, role);
      } else {
        generalError.value = res['message']?.toString() ?? 'Login failed. Please try again.';
      }
    } on NoInternetException {
      generalError.value = 'No internet connection. Please check your network.';
    } on ServerException catch (e) {
      generalError.value = e.message;
    } catch (_) {
      generalError.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateByRole(BuildContext context, String role) {
    switch (role) {
      case 'manager':
        context.go(AppRoutes.managerBottomNavBar);
        break;
      case 'driver':
        context.go(AppRoutes.driverBottomNavBar);
        break;
      case 'representative':
      default:
        context.go(AppRoutes.repBottomNavBar);
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
