import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class CommissionRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  CommissionRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Future<Map<String, dynamic>> getOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommissionOverview,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHistory(
    String token, {
    int page = 1,
    int limit = 10,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommissionHistory,
      queryParameters: {'page': page, 'limit': limit},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommissionDetails(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }
}
