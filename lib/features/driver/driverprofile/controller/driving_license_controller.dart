import 'package:flutter/material.dart';

class DrivingLicenseController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController licenseController =
  TextEditingController(text: '3264 35465 341654');

  String? frontImagePath;
  String? backImagePath;
  bool isLoading = false;

  void setFrontImage(String path) {
    frontImagePath = path;
    notifyListeners();
  }

  void setBackImage(String path) {
    backImagePath = path;
    notifyListeners();
  }

  Future<bool> submit() async {
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
    licenseController.dispose();
    super.dispose();
  }
}