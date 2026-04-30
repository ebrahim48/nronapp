import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class ExpenseRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ExpenseRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Future<Map<String, dynamic>> getAll(
    String token, {
    int page = 1,
    int limit = 10,
    String? searchTerm,
    String? status,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (searchTerm != null && searchTerm.isNotEmpty) params['searchTerm'] = searchTerm;
    if (status != null && status.isNotEmpty) params['status'] = status;
    final res = await _api.get(
      ApiConstants.getExpenseMyAll,
      queryParameters: params,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getExpenseDetails(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> create(
    String token, {
    required String representativeId,
    String? physicianId,
    required String category,
    required String date,
    required String year,
    required String month,
    required double totalAmount,
    required bool isPaid,
    required String description,
    List<File>? files,
    List<File>? docs,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'representative': representativeId,
      'category': category,
      'date': date,
      'year': year,
      'month': month,
      'totalAmount': totalAmount.toStringAsFixed(0),
      'isPaid': isPaid.toString(),
      'description': description,
    };
    if (physicianId != null && physicianId.isNotEmpty) fields['physician'] = physicianId;
    if (files != null && files.isNotEmpty) {
      final fileList = <MultipartFile>[];
      for (final f in files) fileList.add(await MultipartFile.fromFile(f.path));
      fields['files'] = fileList;
    }
    if (docs != null && docs.isNotEmpty) {
      final docList = <MultipartFile>[];
      for (final f in docs) docList.add(await MultipartFile.fromFile(f.path));
      fields['docs'] = docList;
    }
    final res = await _api.post(
      ApiConstants.createExpense,
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> update(
    String token,
    String id, {
    String? representativeId,
    String? physicianId,
    String? category,
    String? date,
    String? year,
    String? month,
    double? totalAmount,
    bool? isPaid,
    String? description,
    List<File>? files,
    List<File>? docs,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (representativeId != null && representativeId.isNotEmpty) fields['representative'] = representativeId;
    if (physicianId != null && physicianId.isNotEmpty) fields['physician'] = physicianId;
    if (category != null && category.isNotEmpty) fields['category'] = category;
    if (date != null && date.isNotEmpty) fields['date'] = date;
    if (year != null && year.isNotEmpty) fields['year'] = year;
    if (month != null && month.isNotEmpty) fields['month'] = month;
    if (totalAmount != null) fields['totalAmount'] = totalAmount.toStringAsFixed(0);
    if (isPaid != null) fields['isPaid'] = isPaid.toString();
    if (description != null && description.isNotEmpty) fields['description'] = description;
    if (files != null && files.isNotEmpty) {
      final fileList = <MultipartFile>[];
      for (final f in files) fileList.add(await MultipartFile.fromFile(f.path));
      fields['files'] = fileList;
    }
    if (docs != null && docs.isNotEmpty) {
      final docList = <MultipartFile>[];
      for (final f in docs) docList.add(await MultipartFile.fromFile(f.path));
      fields['docs'] = docList;
    }
    final res = await _api.patch(
      ApiConstants.updateExpense(id),
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String token, String id) async {
    await _connectivity.checkConnectivity();
    try {
      final res = await _api.dio.delete(
        ApiConstants.deleteExpense(id),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to delete expense';
      if (data is Map && data['message'] != null) message = data['message'].toString();
      throw ServerException(message, e.response?.statusCode, e.message);
    }
  }

  Future<Map<String, dynamic>> getRepresentatives(String token,
      {String? search}) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    final res = await _api.get(
      ApiConstants.getCommonAllRepresentative,
      queryParameters: params.isEmpty ? null : params,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }
}
