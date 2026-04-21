import 'package:flutter/material.dart';

class CarPicturesController extends ChangeNotifier {
  String? carPlatePath;
  String? carPicturePath;
  bool isLoading = false;

  void setCarPlate(String path) {
    carPlatePath = path;
    notifyListeners();
  }

  void setCarPicture(String path) {
    carPicturePath = path;
    notifyListeners();
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