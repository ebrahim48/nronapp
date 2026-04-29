import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../config/app-routes/app_routes.dart';
import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../helpers/prefs_helper.dart';

final _log = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 100,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    // Token refresh interceptor — must be added FIRST
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          final statusCode = error.response?.statusCode;
          final requestOptions = error.requestOptions;

          // Only attempt refresh on 401 or 403, and not on the refresh endpoint itself
          if ((statusCode == 401 || statusCode == 403) &&
              !requestOptions.path.contains(ApiConstants.refreshToken)) {
            try {
              final refreshToken =
                  await PrefsHelper.getString('auth_refresh_token');
              if (refreshToken.isEmpty) {
                _logout();
                return handler.next(error);
              }

              // Call refresh-token endpoint
              final refreshRes = await _dio.post(
                ApiConstants.refreshToken,
                data: {'refreshToken': refreshToken},
              );

              final data =
                  refreshRes.data['data'] as Map<String, dynamic>? ?? {};
              final newToken =
                  (data['accessToken'] ?? data['token'] ?? '').toString();

              if (newToken.isEmpty) {
                _logout();
                return handler.next(error);
              }

              await PrefsHelper.setString('auth_token', newToken);

              // Retry original request with new token
              requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryRes = await _dio.fetch(requestOptions);
              return handler.resolve(retryRes);
            } catch (_) {
              _logout();
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final body = options.data is FormData
                ? _formDataToMap(options.data as FormData)
                : options.data;
            _log.i(
              '➡ ${options.method} ${options.path}\n'
              'Headers: ${_sanitizeHeaders(options.headers)}\n'
              'Body: $body',
            );
            return handler.next(options);
          },
          onResponse: (response, handler) {
            _log.i(
              '✅ ${response.statusCode} ${response.requestOptions.path}\n'
              'Response: ${response.data}',
            );
            return handler.next(response);
          },
          onError: (error, handler) {
            _log.e(
              '❌ ${error.response?.statusCode ?? 'NO_CODE'} ${error.requestOptions.path}\n'
              'Error: ${error.response?.data ?? error.message}',
            );
            return handler.next(error);
          },
        ),
      );
    }
  }

  void _logout() {
    PrefsHelper.remove('auth_token');
    PrefsHelper.remove('auth_refresh_token');
    PrefsHelper.remove('user_role');
    AppRoutes.goRouter.go(AppRoutes.roleSelection);
  }

  Map<String, dynamic> _formDataToMap(FormData formData) {
    final map = <String, dynamic>{};
    for (final f in formData.fields) {
      map[f.key] = f.value;
    }
    for (final f in formData.files) {
      map[f.key] = '[File: ${f.value.filename ?? f.value.contentType}]';
    }
    return map;
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    if (copy.containsKey('Authorization')) {
      final raw = copy['Authorization'].toString();
      copy['Authorization'] = raw.length > 20
          ? '${raw.substring(0, 20)}...[redacted]'
          : '[redacted]';
    }
    return copy;
  }

  Dio get dio => _dio;

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(error.message);

      case DioExceptionType.connectionError:
        return NoInternetException(error.message);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String message = 'Server error';
        if (responseData is Map && responseData['message'] != null) {
          message = responseData['message'].toString();
        } else if (error.response?.statusMessage?.isNotEmpty == true) {
          message = error.response!.statusMessage!;
        }
        return ServerException(message, statusCode, error.message);

      case DioExceptionType.cancel:
        return UnknownException('Request cancelled');

      case DioExceptionType.badCertificate:
        return ServerException('Bad certificate', null, error.message);

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NoInternetException(error.message);
        }
        return UnknownException(error.message);
    }
  }

  void dispose() {
    _dio.close();
  }
}
