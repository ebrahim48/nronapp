import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/auth_temp_data.dart';
import '../../data/repositories/auth_repository.dart';

class ForgetController extends GetxController {
  final emailCtrl = TextEditingController();

  final isLoading = false.obs;
  final emailError = ''.obs;
  final generalError = ''.obs;

  static const _emailRx = r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$';

  final _repo = AuthRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  void setEmail(String email) => emailCtrl.text = email;

  Future<void> sendCode(BuildContext context) async {
    emailError.value = '';
    generalError.value = '';

    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return;
    }
    if (!RegExp(_emailRx).hasMatch(email)) {
      emailError.value = 'Enter a valid email address';
      return;
    }

    try {
      isLoading.value = true;
      final res = await _repo.forgotPassword(email: email);

      if (res['success'] == true) {
        final forgotToken = (res['data']?['token'] ?? '').toString();
        AuthTempData.email = email;
        AuthTempData.forgotToken = forgotToken;
        AuthTempData.verifyFlow = 'forgot';

        if (context.mounted) context.pushNamed(AppRoutes.verifyScreen);
      } else {
        generalError.value = res['message']?.toString() ?? 'Failed to send code. Please try again.';
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
    emailCtrl.dispose();
    super.onClose();
  }
}
