import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class ManagerShipmentRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ManagerShipmentRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /shipment/get-stats/home  — stats + active shipments
  Future<Map<String, dynamic>> getStats(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerShipmentStats,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /shipment/get-all
  Future<Map<String, dynamic>> getAll(
    String token, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null && status.isNotEmpty) params['status'] = status;
    final res = await _api.get(
      ApiConstants.getManagerShipment,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /shipment/find/:id
  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerShipmentDetail(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// PATCH /shipment/status-update/:id
  Future<Map<String, dynamic>> updateStatus(
    String token,
    String id, {
    required String status,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.patch(
      ApiConstants.updateManagerShipmentStatus(id),
      data: {'status': status},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
