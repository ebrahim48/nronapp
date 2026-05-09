import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class ManagerPORepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ManagerPORepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /purchase-order/get-all?status=...
  Future<Map<String, dynamic>> getAll(
    String token, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null && status.isNotEmpty && status != 'all') {
      params['status'] = status;
    }
    final res = await _api.get(
      ApiConstants.getManagerPurchaseOrder,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /purchase-order/find/:id
  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerSinglePurchaseOrder(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// POST /purchase-order/send-to-mail/:id
  Future<Map<String, dynamic>> sendVendorMail(
      String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.managerSendVendorMail(id),
      data: {},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
