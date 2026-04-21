import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DrivingLicenseController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController licenseController =
  TextEditingController(text: '3264 35465 341654');

  String? frontImagePath;
  String? backImagePath;
  bool isLoading = false;

  final _picker = ImagePicker();

  Future<void> setFrontImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      frontImagePath = picked.path;
      notifyListeners();
    }
  }

  Future<void> setBackImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      backImagePath = picked.path;
      notifyListeners();
    }
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