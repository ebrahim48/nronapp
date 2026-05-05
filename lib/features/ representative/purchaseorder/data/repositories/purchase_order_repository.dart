import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class PurchaseOrderRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  PurchaseOrderRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  Future<Map<String, dynamic>> getAll(
    String token, {
    int page = 1,
    int limit = 15,
    String? status,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null && status.isNotEmpty) params['status'] = status;
    final res = await _api.get(
      ApiConstants.getPurchaseMyOrder,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getPurchaseDetailsOrder(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> create(
    String token, {
    required String orderType,
    required String status,
    required String patientId,
    required String surgeryId,
    required String facilityId,
    required String procedureDate,
    required String purchaseOrderNumber,
    required double totalAmount,
    String? vendorId,
    String? notes,
    List<Map<String, dynamic>>? products,
    List<File>? docs,
    List<File>? write,
    File? thumbnail,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'orderType': orderType,
      'status': status,
      'patientId': patientId,
      'surgery': surgeryId,
      'facility': facilityId,
      'procedureDate': procedureDate,
      'purchaseOrderNumber': purchaseOrderNumber,
      'totalAmount': totalAmount.toString(),
    };
    if (vendorId != null && vendorId.isNotEmpty) fields['vendor'] = vendorId;
    if (notes != null && notes.isNotEmpty) fields['notes'] = notes;

    if (products != null) {
      for (var i = 0; i < products.length; i++) {
        final p = products[i];
        fields['products[$i][productId]'] = p['productId'];
        fields['products[$i][productName]'] = p['productName'];
        final items = p['listOfItems'] as List<dynamic>? ?? [];
        for (var j = 0; j < items.length; j++) {
          fields['products[$i][listOfItems][$j][slName]'] = items[j]['slName'];
        }
      }
    }

    if (thumbnail != null) {
      fields['thumbnail'] = await MultipartFile.fromFile(thumbnail.path);
    }
    if (docs != null && docs.isNotEmpty) {
      fields['docs'] =
          await Future.wait(docs.map((f) => MultipartFile.fromFile(f.path)));
    }
    if (write != null && write.isNotEmpty) {
      fields['write'] =
          await Future.wait(write.map((f) => MultipartFile.fromFile(f.path)));
    }

    final res = await _api.post(
      ApiConstants.createPurchaseOrder,
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> update(
    String token,
    String id, {
    String? orderType,
    String? status,
    String? patientId,
    String? surgeryId,
    String? facilityId,
    String? procedureDate,
    String? purchaseOrderNumber,
    double? totalAmount,
    String? vendorId,
    String? notes,
    List<Map<String, dynamic>>? products,
    List<File>? docs,
    List<File>? write,
    File? thumbnail,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (orderType != null) fields['orderType'] = orderType;
    if (status != null) fields['status'] = status;
    if (patientId != null) fields['patientId'] = patientId;
    if (surgeryId != null && surgeryId.isNotEmpty) fields['surgery'] = surgeryId;
    if (facilityId != null && facilityId.isNotEmpty) fields['facility'] = facilityId;
    if (procedureDate != null) fields['procedureDate'] = procedureDate;
    if (purchaseOrderNumber != null) fields['purchaseOrderNumber'] = purchaseOrderNumber;
    if (totalAmount != null) fields['totalAmount'] = totalAmount.toString();
    if (vendorId != null && vendorId.isNotEmpty) fields['vendor'] = vendorId;
    if (notes != null && notes.isNotEmpty) fields['notes'] = notes;

    if (products != null) {
      for (var i = 0; i < products.length; i++) {
        final p = products[i];
        fields['products[$i][productId]'] = p['productId'];
        fields['products[$i][productName]'] = p['productName'];
        final items = p['listOfItems'] as List<dynamic>? ?? [];
        for (var j = 0; j < items.length; j++) {
          fields['products[$i][listOfItems][$j][slName]'] = items[j]['slName'];
        }
      }
    }

    if (thumbnail != null) {
      fields['thumbnail'] = await MultipartFile.fromFile(thumbnail.path);
    }
    if (docs != null && docs.isNotEmpty) {
      fields['docs'] =
          await Future.wait(docs.map((f) => MultipartFile.fromFile(f.path)));
    }
    if (write != null && write.isNotEmpty) {
      fields['write'] =
          await Future.wait(write.map((f) => MultipartFile.fromFile(f.path)));
    }

    final res = await _api.patch(
      ApiConstants.updatePurchaseOrder(id),
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFacilities(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.getCommonAllFacilities, options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getVendors(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.commonAllVendors, options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String token, String id) async {
    await _connectivity.checkConnectivity();
    try {
      final res = await _api.dio.delete(
        '/purchase-order/delete/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to delete purchase order';
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }
      throw ServerException(message, e.response?.statusCode, e.message);
    }
  }

  Future<Map<String, dynamic>> getSurgeries(String token) async {
    await _connectivity.checkConnectivity();
    try {
      final res = await _api.get(ApiConstants.commonAllSurgeries, options: _auth(token));
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to load surgeries';
      if (data is Map && data['message'] != null) message = data['message'].toString();
      throw ServerException(message, e.response?.statusCode, e.message);
    }
  }
}
