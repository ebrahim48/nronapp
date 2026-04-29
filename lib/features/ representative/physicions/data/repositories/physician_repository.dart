import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class PhysicianRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  PhysicianRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Future<Map<String, dynamic>> getAll(
    String token, {
    int page = 1,
    int limit = 10,
    String? searchTerm,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (searchTerm != null && searchTerm.isNotEmpty) {
      params['searchTerm'] = searchTerm;
    }
    final res = await _api.get(
      ApiConstants.getPhysicianAll,
      queryParameters: params,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSingle(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getSinglePhysician(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> create(
    String token, {
    required String fullName,
    required String email,
    required String practice,
    required String specialty,
    required String location,
    required String phoneNumber,
    required String cellNumber,
    required String dateOfBirth,
    required String noteToSelf,
    File? docs,
    File? profileImage,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'fullName': fullName,
      'practice': practice,
      'specialty': specialty,
      'location': location,
      'phoneNumber': phoneNumber,
      'cellNumber': cellNumber,
      'noteToSelf': noteToSelf,
    };
    if (email.isNotEmpty) fields['email'] = email;
    if (dateOfBirth.isNotEmpty) fields['dateOfBirth'] = dateOfBirth;
    if (docs != null) {
      fields['docs'] = await MultipartFile.fromFile(docs.path);
    }
    if (profileImage != null) {
      fields['profile'] = await MultipartFile.fromFile(profileImage.path);
    }
    final res = await _api.post(
      ApiConstants.createPhysician,
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> update(
    String token,
    String id, {
    String? fullName,
    String? practice,
    String? specialty,
    String? location,
    String? phoneNumber,
    String? cellNumber,
    String? dateOfBirth,
    String? noteToSelf,
    File? docs,
    File? profileImage,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (fullName != null && fullName.isNotEmpty) fields['fullName'] = fullName;
    if (practice != null && practice.isNotEmpty) fields['practice'] = practice;
    if (specialty != null && specialty.isNotEmpty) fields['specialty'] = specialty;
    if (location != null && location.isNotEmpty) fields['location'] = location;
    if (phoneNumber != null && phoneNumber.isNotEmpty) fields['phoneNumber'] = phoneNumber;
    if (cellNumber != null && cellNumber.isNotEmpty) fields['cellNumber'] = cellNumber;
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) fields['dateOfBirth'] = dateOfBirth;
    if (noteToSelf != null && noteToSelf.isNotEmpty) fields['noteToSelf'] = noteToSelf;
    if (docs != null) {
      fields['docs'] = await MultipartFile.fromFile(docs.path);
    }
    if (profileImage != null) {
      fields['profile'] = await MultipartFile.fromFile(profileImage.path);
    }
    final res = await _api.patch(
      ApiConstants.updatePhysician(id),
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String token, String id) async {
    await _connectivity.checkConnectivity();
    try {
      final res = await _api.dio.delete(
        ApiConstants.deletePhysician(id),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to delete physician';
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }
      throw ServerException(message, e.response?.statusCode, e.message);
    }
  }
}
