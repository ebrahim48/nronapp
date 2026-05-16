import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class NotificationRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  NotificationRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  Future<Map<String, dynamic>> getAll(
    String token, {
    int page = 1,
    int limit = 10,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getNotificationAll,
      queryParameters: {'page': page, 'limit': limit},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
