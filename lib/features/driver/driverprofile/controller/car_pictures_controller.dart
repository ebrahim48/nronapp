import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../data/profile_repository.dart';

class CarPicturesController extends ChangeNotifier {
  String? carPlatePath;
  String? carPicturePath;
  bool isLoading = false;
  String errorMessage = '';

  final _picker = ImagePicker();
  final _repo = ProfileRepository(apiService: ApiService());

  Future<void> setCarPlate() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      carPlatePath = picked.path;
      notifyListeners();
    }
  }

  Future<void> setCarPicture() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      carPicturePath = picked.path;
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    if (carPlatePath == null || carPicturePath == null) {
      errorMessage = 'Please upload both car plate and car pictures';
      notifyListeners();
      return false;
    }
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final formData = FormData.fromMap({
        'plate': await MultipartFile.fromFile(
          carPlatePath!,
          filename: 'plate.jpg',
        ),
        'car': await MultipartFile.fromFile(
          carPicturePath!,
          filename: 'car.jpg',
        ),
      });
      final res = await _repo.updateMyProfile(formData);
      if (res['success'] == true) {
        isLoading = false;
        notifyListeners();
        return true;
      }
      errorMessage = res['message']?.toString() ?? 'Upload failed';
    } on ServerException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
}
