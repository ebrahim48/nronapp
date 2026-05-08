import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class ManagerSalesRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ManagerSalesRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /sales/get-all?status=pending|approved|rejected
  Future<Map<String, dynamic>> getAllSales(
    String token, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null && status.isNotEmpty && status != 'allSales') {
      params['status'] = status;
    }
    final res = await _api.get(
      ApiConstants.getManagerSales,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /sales/find/:id
  Future<Map<String, dynamic>> getSaleDetail(
      String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerSaleDetail(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
