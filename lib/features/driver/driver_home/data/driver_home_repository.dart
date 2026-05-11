import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class DriverHomeRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  DriverHomeRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// GET /shipment/driver-meta
  Future<Map<String, dynamic>> getDriverHome(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getDriverHome,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
