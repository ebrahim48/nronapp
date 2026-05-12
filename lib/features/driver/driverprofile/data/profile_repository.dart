import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<Map<String, dynamic>> getMyProfile() async {
    final token = await PrefsHelper.getString('auth_token');
    final res = await _apiService.get(
      ApiConstants.getMyProfile,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMyProfile(FormData formData) async {
    final token = await PrefsHelper.getString('auth_token');
    final res = await _apiService.patch(
      ApiConstants.updateMyProfile,
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }
}
