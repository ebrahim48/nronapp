import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/auth_temp_data.dart';
import '../../data/repositories/auth_repository.dart';

class ResetController extends GetxController {
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isLoading = false.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final generalError = ''.obs;

  final _repo = AuthRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  void validatePassword() {
    final v = passwordCtrl.text.trim();
    if (v.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (v.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
    } else {
      passwordError.value = '';
    }
  }

  void validateConfirmPassword() {
    final v = confirmPasswordCtrl.text.trim();
    if (v.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
    } else if (v != passwordCtrl.text.trim()) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    passwordError.value = '';
    confirmPasswordError.value = '';
    generalError.value = '';

    validatePassword();
    validateConfirmPassword();
    if (passwordError.value.isNotEmpty || confirmPasswordError.value.isNotEmpty) return;

    try {
      isLoading.value = true;
      final res = await _repo.resetPassword(
        newPassword: passwordCtrl.text.trim(),
        confirmPassword: confirmPasswordCtrl.text.trim(),
        token: AuthTempData.forgotToken,
      );

      if (res['success'] == true) {
        AuthTempData.clear();
        if (context.mounted) {
          context.go(AppRoutes.signInScreen);
        }
      } else {
        generalError.value = res['message']?.toString() ?? 'Reset failed. Please try again.';
      }
    } on NoInternetException {
      generalError.value = 'No internet connection.';
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
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
