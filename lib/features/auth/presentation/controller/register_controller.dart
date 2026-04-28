import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/auth_temp_data.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterController extends GetxController {
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isLoading = false.obs;
  final fullNameError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final generalError = ''.obs;

  static const _emailRx = r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$';

  final _repo = AuthRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  Future<void> register(BuildContext context, {required String role}) async {
    fullNameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    generalError.value = '';

    final fullName = fullNameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    bool valid = true;
    if (fullName.isEmpty) {
      fullNameError.value = 'Full name is required';
      valid = false;
    }
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
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      valid = false;
    } else if (password != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match';
      valid = false;
    }
    if (!valid) return;

    try {
      isLoading.value = true;
      final res = await _repo.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );

      if (res['success'] == true) {
        final verifyToken = (res['data']?['verifyToken'] ?? '').toString();
        AuthTempData.email = email;
        AuthTempData.verifyToken = verifyToken;
        AuthTempData.verifyFlow = 'register';

        if (context.mounted) context.pushNamed(AppRoutes.verifyScreen);
      } else {
        generalError.value = res['message']?.toString() ?? 'Registration failed. Please try again.';
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

  @override
  void onClose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
