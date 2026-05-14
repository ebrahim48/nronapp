import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class DriverJobRepository {
  final ApiService _api = ApiService();
  final ConnectivityService _connectivity = ConnectivityService();

  Future<Map<String, dynamic>> getAllJobs(String token, {String? status}) async {
    final isConnected = await _connectivity.checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }
    final params = <String, dynamic>{'page': 1, 'limit': 10};
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }
    final response = await _api.get(
      ApiConstants.getAllJob,
      queryParameters: params,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSingleJob(String token, String id) async {
    final isConnected = await _connectivity.checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }
    final response = await _api.get(
      ApiConstants.getAllSingleJob(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> acceptJob(String token, String id) async {
    final isConnected = await _connectivity.checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }
    final response = await _api.patch(
      ApiConstants.acceptJob(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> changeStatus(
      String token, String id, String status) async {
    final isConnected = await _connectivity.checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }
    final response = await _api.patch(
      ApiConstants.changeStatus(id),
      data: {'status': status},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitDelivery({
    required String token,
    required String id,
    required String notes,
    String? photoPath,
  }) async {
    final isConnected = await _connectivity.checkConnectivity();
    if (!isConnected) throw Exception('No internet connection');

    final fields = <String, dynamic>{'status': 'picked_up'};
    if (notes.isNotEmpty) fields['notes'] = notes;
    if (photoPath != null && photoPath.isNotEmpty) {
      fields['files'] = await MultipartFile.fromFile(photoPath);
    }

    final response = await _api.patch(
      ApiConstants.changeStatus(id),
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }
}
