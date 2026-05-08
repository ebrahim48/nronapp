import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class ManagerInventoryRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ManagerInventoryRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /meta/inventory/overview
  Future<Map<String, dynamic>> getInventoryOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerInventory,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /missing-instrument/overview
  Future<Map<String, dynamic>> getMissingInstrumentOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerSummaryCountInstrument,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /missing-instrument/report
  Future<Map<String, dynamic>> getMissingInstrumentReport(
    String token, {
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) params['search'] = search;
    final res = await _api.get(
      ApiConstants.getMissingInstrumentReport,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /missing-instrument/find/:id
  Future<Map<String, dynamic>> getMissingInstrumentDetail(
      String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerMissingInstrumentDetail(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// PATCH /missing-instrument/send-vendor/:id
  Future<Map<String, dynamic>> sendVendorMail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.patch(
      ApiConstants.sendManagerVendorMail(id),
      data: {},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /meta/inventory/transfer-requests?status=...
  Future<Map<String, dynamic>> getTransferRequests(
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
      ApiConstants.getAllTransferRequest,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
