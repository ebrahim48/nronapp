import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class ManagerExpenseRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ManagerExpenseRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /expense/get-all?status=pending|approved|rejected
  Future<Map<String, dynamic>> getAllExpenses(
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
      ApiConstants.getExpenseAll,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// GET /expense/find/:id
  Future<Map<String, dynamic>> getExpenseDetail(
      String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getManagerSingleExpense(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  /// PATCH /expense/status-update/:id
  /// [status] must be either "approved" or "rejected"
  /// [rejectionNote] is required when status is "rejected"
  Future<Map<String, dynamic>> updateExpenseStatus(
    String token,
    String id,
    String status, {
    String? rejectionNote,
  }) async {
    await _connectivity.checkConnectivity();
    final body = <String, dynamic>{'status': status};
    if (status == 'rejected' && rejectionNote != null && rejectionNote.isNotEmpty) {
      body['rejectionNote'] = rejectionNote;
    }
    final res = await _api.patch(
      ApiConstants.expenseStatusUpdate(id),
      data: body,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
