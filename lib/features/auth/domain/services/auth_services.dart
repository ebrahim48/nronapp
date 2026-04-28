import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;
  final ConnectivityService _connectivityService;

  AuthService({
    required AuthRepository repository,
    required ConnectivityService connectivityService,
  })  : _repository = repository,
        _connectivityService = connectivityService;

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      throw ServerException('All fields are required', 400, 'Validation error');
    }
    if (password.length < 8) {
      throw ServerException('Password must be at least 8 characters', 400, 'Validation error');
    }
    await _connectivityService.checkConnectivity();
    return _repository.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw ServerException('Email and password are required', 400, 'Validation error');
    }
    await _connectivityService.checkConnectivity();
    return _repository.login(email: email, password: password);
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    if (email.isEmpty) throw ServerException('Email is required', 400, 'Validation error');
    await _connectivityService.checkConnectivity();
    return _repository.forgotPassword(email: email);
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String verifyToken,
  }) async {
    if (otp.isEmpty || verifyToken.isEmpty) {
      throw ServerException('OTP and token are required', 400, 'Validation error');
    }
    await _connectivityService.checkConnectivity();
    return _repository.verifyOtp(otp: otp, verifyToken: verifyToken);
  }

  Future<Map<String, dynamic>> forgotOtpVerify({
    required String otp,
    required String forgotToken,
  }) async {
    await _connectivityService.checkConnectivity();
    return _repository.forgotOtpVerify(otp: otp, forgotToken: forgotToken);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      throw ServerException('All fields are required', 400, 'Validation error');
    }
    if (newPassword.length < 8) {
      throw ServerException('Password must be at least 8 characters', 400, 'Validation error');
    }
    if (newPassword != confirmPassword) {
      throw ServerException('Passwords do not match', 400, 'Validation error');
    }
    await _connectivityService.checkConnectivity();
    return _repository.resetPassword(
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      token: token,
    );
  }

  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    if (email.isEmpty) throw ServerException('Email is required', 400, 'Validation error');
    await _connectivityService.checkConnectivity();
    return _repository.resendOtp(email: email);
  }
}
