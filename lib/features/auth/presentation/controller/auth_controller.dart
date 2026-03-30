import 'package:flutter/material.dart';

class AuthController {
  // ── Login ──────────────────────────────────────────────────────────────────
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  // ── Sign Up ────────────────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final signupFormKey = GlobalKey<FormState>();

  bool validateLogin() => loginFormKey.currentState?.validate() ?? false;
  bool validateSignUp() => signupFormKey.currentState?.validate() ?? false;

  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    nameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
  }
}
