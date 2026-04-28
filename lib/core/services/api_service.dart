import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';

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
        headers: ApiConstants.headers,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            _log.i(
              '➡ ${options.method} ${options.path}\n'
              'Headers: ${_sanitizeHeaders(options.headers)}\n'
              'Body: ${options.data}',
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

  // Redact Authorization header value in logs
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
