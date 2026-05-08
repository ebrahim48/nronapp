import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class ManagerCommissionRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ManagerCommissionRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /commission/overview
  Future<Map<String, dynamic>> getOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommissionOverviewManager,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /commission/get-all
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
      ApiConstants.getCommissionAllManager,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /commission/find/:id
  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommissionDetail(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// PATCH /sales/status-update/:id  (approve commission)
  Future<Map<String, dynamic>> approveCommission(
      String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.patch(
      ApiConstants.approveCommissionById(id),
      data: {'status': 'approved'},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /commission-manage/overview
  Future<Map<String, dynamic>> getManageOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommissionManageOverview,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /commission-manage/get-all
  Future<Map<String, dynamic>> getManageAll(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommissionManageAll,
      queryParameters: {'page': page, 'limit': limit},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// PATCH /commission-manage/update-commission/:id
  Future<Map<String, dynamic>> updateCommissionRate(
    String token,
    String id, {
    required double rate,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.patch(
      ApiConstants.updateCommissionRate(id),
      data: {'commissionRate': rate},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
