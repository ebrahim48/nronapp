import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../data/profile_repository.dart';

class PersonalInfoController extends ChangeNotifier {
  String? profileImagePath;
  String? existingProfileUrl;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String selectedGender = 'Male';
  final List<String> genders = ['Male', 'Female', 'Other'];

  bool isLoading = false;
  String errorMessage = '';

  final _repo = ProfileRepository(apiService: ApiService());

  int get bioCharCount => bioController.text.length;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();
    try {
      final res = await _repo.getMyProfile();
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        fullNameController.text = data['fullName']?.toString() ?? '';
        addressController.text = data['address']?.toString() ?? '';
        bioController.text = data['bio']?.toString() ?? '';
        existingProfileUrl = data['profileUrl']?.toString();
        errorMessage = '';
      }
    } catch (_) {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      profileImagePath = picked.path;
      notifyListeners();
    }
  }

  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final map = <String, dynamic>{
        'fullName': fullNameController.text.trim(),
        'bio': bioController.text.trim(),
      };
      if (addressController.text.trim().isNotEmpty) {
        map['address'] = addressController.text.trim();
      }
      if (profileImagePath != null) {
        map['profile'] = await MultipartFile.fromFile(
          profileImagePath!,
          filename: 'profile.jpg',
        );
      }

      final res = await _repo.updateMyProfile(FormData.fromMap(map));
      if (res['success'] == true) {
        isLoading = false;
        notifyListeners();
        return true;
      }
      errorMessage = res['message']?.toString() ?? 'Update failed';
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
    fullNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    dobController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
