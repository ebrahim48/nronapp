import 'package:flutter/material.dart';

class ChangePasswordController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController =
  TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  void toggleCurrent() {
    obscureCurrent = !obscureCurrent;
    notifyListeners();
  }

  void toggleNew() {
    obscureNew = !obscureNew;
    notifyListeners();
  }

  void toggleConfirm() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  Future<bool> saveChange() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}