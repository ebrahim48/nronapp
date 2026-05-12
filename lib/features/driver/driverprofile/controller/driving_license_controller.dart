import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../data/profile_repository.dart';

class DrivingLicenseController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController licenseController = TextEditingController();

  String? frontImagePath;
  String? backImagePath;
  bool isLoading = false;
  String errorMessage = '';

  final _picker = ImagePicker();
  final _repo = ProfileRepository(apiService: ApiService());

  Future<void> setFrontImage() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      frontImagePath = picked.path;
      notifyListeners();
    }
  }

  Future<void> setBackImage() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      backImagePath = picked.path;
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (frontImagePath == null || backImagePath == null) {
      errorMessage = 'Please upload both front and back photos';
      notifyListeners();
      return false;
    }
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final formData = FormData.fromMap({
        'licenseNumber': licenseController.text.trim(),
        'drvFront': await MultipartFile.fromFile(
          frontImagePath!,
          filename: 'drv_front.jpg',
        ),
        'drvBack': await MultipartFile.fromFile(
          backImagePath!,
          filename: 'drv_back.jpg',
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

  @override
  void dispose() {
    licenseController.dispose();
    super.dispose();
  }
}
