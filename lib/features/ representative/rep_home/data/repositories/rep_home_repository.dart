import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class RepHomeRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  RepHomeRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Future<Map<String, dynamic>> getOverview(String token) async {
    await _connectivity.checkConnectivity();
    try {
      final res = await _api.get(
        ApiConstants.home,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to load overview';
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }
      throw ServerException(message, e.response?.statusCode, e.message);
    }
  }
}
