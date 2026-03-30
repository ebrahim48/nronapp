import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetController extends GetxController {
  final emailCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void setEmail(String email) {
    emailCtrl.text = email;
  }

  void validateEmail() {
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!emailRegex.hasMatch(email)) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }
}
