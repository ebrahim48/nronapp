import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/auth_temp_data.dart';
import '../../data/repositories/auth_repository.dart';

class VerifyController extends GetxController {
  final isLoading = false.obs;
  final otpError = ''.obs;
  final generalError = ''.obs;
  final countdown = 60.obs;
  final isCountingDown = false.obs;

  Timer? _timer;

  final _repo = AuthRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  void startCountdown() {
    countdown.value = 60;
    isCountingDown.value = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        isCountingDown.value = false;
        t.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    generalError.value = '';
    try {
      await _repo.resendOtp(email: AuthTempData.email);
      startCountdown();
    } on NoInternetException {
      generalError.value = 'No internet connection.';
    } on ServerException catch (e) {
      generalError.value = e.message;
    } catch (_) {
      generalError.value = 'Failed to resend code. Please try again.';
    }
  }

  Future<void> verify(BuildContext context, String otp) async {
    otpError.value = '';
    generalError.value = '';

    if (otp.length < 6) {
      otpError.value = 'Please enter the complete 6-digit code';
      return;
    }

    try {
      isLoading.value = true;

      if (AuthTempData.verifyFlow == 'register') {
        await _verifyRegister(context, otp);
      } else {
        await _verifyForgot(context, otp);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifyRegister(BuildContext context, String otp) async {
    try {
      final res = await _repo.verifyOtp(
        otp: otp,
        verifyToken: AuthTempData.verifyToken,
      );

      if (res['success'] == true) {
        final role = AuthTempData.selectedRole;
        AuthTempData.clear();
        if (context.mounted) {
          if (role == 'driver') {
            context.go(AppRoutes.personalInfoScreen, extra: true);
          } else {
            context.go(AppRoutes.signInScreen);
          }
        }
      } else {
        otpError.value = res['message']?.toString() ?? 'Invalid code. Please try again.';
      }
    } on NoInternetException {
      generalError.value = 'No internet connection.';
    } on ServerException catch (e) {
      otpError.value = e.message;
    } catch (_) {
      generalError.value = 'Something went wrong. Please try again.';
    }
  }

  Future<void> _verifyForgot(BuildContext context, String otp) async {
    try {
      final res = await _repo.forgotOtpVerify(
        otp: otp,
        forgotToken: AuthTempData.forgotToken,
      );

      if (res['success'] == true) {
        if (context.mounted) context.pushNamed(AppRoutes.resetPasswordScreen);
      } else {
        otpError.value = res['message']?.toString() ?? 'Invalid code. Please try again.';
      }
    } on NoInternetException {
      generalError.value = 'No internet connection.';
    } on ServerException catch (e) {
      otpError.value = e.message;
    } catch (_) {
      generalError.value = 'Something went wrong. Please try again.';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
