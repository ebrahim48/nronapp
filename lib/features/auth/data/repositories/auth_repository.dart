import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class AuthRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  AuthRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  // POST /auth/register
  // Body: { fullName, email, password, role }
  // Returns: { data: { verifyToken } }
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.register,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/verify-otp
  // Header: Authorization: Bearer <verifyToken>
  // Body: { otp }
  // Returns: { data: { token, refreshToken, results } }
  Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String verifyToken,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.verify,
      data: {'otp': otp},
      options: Options(
        headers: {'Authorization': 'Bearer $verifyToken'},
      ),
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/login
  // Body: { email, password }
  // Returns: { data: { token, refreshToken, results } }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/forgot-password
  // Body: { email }
  // Returns: { data: { token } }
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.forgetPassword,
      data: {'email': email},
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/forgot-otp-verify
  // Header: Authorization: Bearer <forgotToken>
  // Body: { otp }
  Future<Map<String, dynamic>> forgotOtpVerify({
    required String otp,
    required String forgotToken,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.forgetOtpVerifyPassword,
      data: {'otp': otp},
      options: Options(
        headers: {'Authorization': 'Bearer $forgotToken'},
      ),
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/reset-password
  // Header: Authorization: Bearer <forgotToken>
  // Body: { newPassword, confirmPassword }
  Future<Map<String, dynamic>> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.resetPassword,
      data: {'newPassword': newPassword, 'confirmPassword': confirmPassword},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/google  (native Sign in with Google)
  // Body: { idToken, role, fullName? }
  // Returns: { data: { results, accessToken, refreshToken } }
  Future<Map<String, dynamic>> signInWithGoogle({
    required String idToken,
    required String role,
    String? fullName,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.googleLogin,
      data: {
        'idToken': idToken,
        'role': role,
        if (fullName != null && fullName.isNotEmpty) 'fullName': fullName,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/apple  (native Sign in with Apple)
  // Body: { identityToken, role, fullName? }
  // Returns: { data: { results, accessToken, refreshToken } }
  Future<Map<String, dynamic>> signInWithApple({
    required String identityToken,
    required String role,
    String? fullName,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.appleLogin,
      data: {
        'identityToken': identityToken,
        'role': role,
        if (fullName != null && fullName.isNotEmpty) 'fullName': fullName,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  // POST /auth/resend-otp
  // Body: { email }
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.resend,
      data: {'email': email},
    );
    return res.data as Map<String, dynamic>;
  }
}
