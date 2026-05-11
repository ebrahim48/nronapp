import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class EarningRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  EarningRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /earnings/my-summary
  Future<Map<String, dynamic>> getSummary(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getEarningsSummary,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /earnings/history
  Future<Map<String, dynamic>> getHistory(
    String token, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null && status.isNotEmpty && status != 'All') {
      params['status'] = status.toLowerCase();
    }
    final res = await _api.get(
      ApiConstants.getEarningsHistory,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
