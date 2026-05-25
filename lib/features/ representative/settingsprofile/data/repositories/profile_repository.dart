import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class ProfileRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ProfileRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Future<Map<String, dynamic>> getMyProfile(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getMyProfile,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMyProfile(
    String token, {
    String? fullName,
    String? bio,
    String? designation,
    File? profileImage,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (fullName != null && fullName.isNotEmpty) fields['fullName'] = fullName;
    if (bio != null) fields['bio'] = bio;
    if (designation != null) fields['designation'] = designation;
    if (profileImage != null) {
      fields['profile'] = await MultipartFile.fromFile(profileImage.path);
    }
    final res = await _api.patch(
      ApiConstants.updateMyProfile,
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> changePassword(
    String token, {
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendSupportMessage(
    String token, {
    required String subject,
    required String message,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.sendSupportMessage,
      data: {'subject': subject, 'message': message},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAboutUs(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.aboutUs,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTerms(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.terms,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPrivacyPolicy(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.privacyPolicy,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }
}
