import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class ActivityLogRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ActivityLogRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  Future<Map<String, dynamic>> getAll(
    String token, {
    String? module,
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (module != null && module.isNotEmpty) params['module'] = module;
    final res = await _api.get(
      ApiConstants.getActiveLog,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getModels(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getActiveLogModel,
      options: _auth(token),
    );
    final data = res.data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return [];
  }
}
