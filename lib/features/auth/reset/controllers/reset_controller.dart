import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetController extends GetxController {
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  void validatePassword() {
    final password = passwordCtrl.text.trim();
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }

  void validateConfirmPassword() {
    final confirmPassword = confirmPasswordCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
    } else if (password != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  bool get isFormValid {
    validatePassword();
    validateConfirmPassword();
    return passwordError.value.isEmpty && confirmPasswordError.value.isEmpty;
  }

  @override
  void onClose() {
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
