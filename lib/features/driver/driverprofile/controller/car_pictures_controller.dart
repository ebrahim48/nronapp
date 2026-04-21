import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarPicturesController extends ChangeNotifier {
  String? carPlatePath;
  String? carPicturePath;
  bool isLoading = false;

  final _picker = ImagePicker();

  Future<void> setCarPlate() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      carPlatePath = picked.path;
      notifyListeners();
    }
  }

  Future<void> setCarPicture() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      carPicturePath = picked.path;
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
    return true;
  }
}