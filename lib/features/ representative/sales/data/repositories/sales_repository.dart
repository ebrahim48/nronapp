import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class SalesRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  SalesRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  Future<Map<String, dynamic>> getOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getSalesOverview,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAll(
    String token, {
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) params['searchTerm'] = search;
    if (status != null && status.isNotEmpty) params['status'] = status;
    final res = await _api.get(
      ApiConstants.getSales,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getSalesDetails(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> create(
    String token, {
    required String salesType,
    required String physicianId,
    required String facilityId,
    required String procedureDate,
    required List<Map<String, dynamic>> representatives,
    required List<Map<String, dynamic>> inventoryProducts,
    required String vendorId,
    required String purchaseOrderNumber,
    required double totalAmount,
    required double vendorPayment,
    String? description,
    bool isPackingSlipGenerated = false,
    List<File>? attachments,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'salesType': salesType,
      'physician': physicianId,
      'facility': facilityId,
      'procedureDate': procedureDate,
      'isPackingSlipGenerated': isPackingSlipGenerated.toString(),
    };
    if (description != null && description.isNotEmpty) {
      fields['description'] = description;
    }

    for (var i = 0; i < representatives.length; i++) {
      final rep = representatives[i];
      fields['representatives[$i][representative]'] = rep['representative'];
      fields['representatives[$i][assignRole]'] = rep['assignRole'];
      fields['representatives[$i][commissionRate]'] =
          rep['commissionRate'].toString();
    }

    if (vendorId.isNotEmpty) fields['billing[vendor]'] = vendorId;
    fields['billing[purchaseOrderNumber]'] = purchaseOrderNumber;
    fields['billing[totalAmount]'] = totalAmount.toStringAsFixed(2);
    fields['billing[vendorPayment]'] = vendorPayment.toStringAsFixed(2);

    for (var i = 0; i < inventoryProducts.length; i++) {
      final item = inventoryProducts[i];
      fields['inventoryProducts[$i][product]'] = item['product'];
      fields['inventoryProducts[$i][productType]'] = item['productType'];
    }

    if (attachments != null && attachments.isNotEmpty) {
      final fileList = <MultipartFile>[];
      for (final f in attachments) {
        fileList.add(await MultipartFile.fromFile(f.path));
      }
      fields['docs'] = fileList;
    }

    final res = await _api.post(
      ApiConstants.createSales,
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> update(
    String token,
    String id, {
    String? salesType,
    String? physicianId,
    String? facilityId,
    String? procedureDate,
    List<Map<String, dynamic>>? representatives,
    List<Map<String, dynamic>>? inventoryProducts,
    String? vendorId,
    String? purchaseOrderNumber,
    double? totalAmount,
    double? vendorPayment,
    String? description,
    List<File>? attachments,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (salesType != null) fields['salesType'] = salesType;
    if (physicianId != null && physicianId.isNotEmpty) {
      fields['physician'] = physicianId;
    }
    if (facilityId != null && facilityId.isNotEmpty) {
      fields['facility'] = facilityId;
    }
    if (procedureDate != null && procedureDate.isNotEmpty) {
      fields['procedureDate'] = procedureDate;
    }
    if (description != null && description.isNotEmpty) {
      fields['description'] = description;
    }

    if (representatives != null) {
      for (var i = 0; i < representatives.length; i++) {
        final rep = representatives[i];
        fields['representatives[$i][representative]'] = rep['representative'];
        fields['representatives[$i][assignRole]'] = rep['assignRole'];
        fields['representatives[$i][commissionRate]'] =
            rep['commissionRate'].toString();
      }
    }

    if (vendorId != null && vendorId.isNotEmpty) {
      fields['billing[vendor]'] = vendorId;
    }
    if (purchaseOrderNumber != null) {
      fields['billing[purchaseOrderNumber]'] = purchaseOrderNumber;
    }
    if (totalAmount != null) {
      fields['billing[totalAmount]'] = totalAmount.toStringAsFixed(2);
    }
    if (vendorPayment != null) {
      fields['billing[vendorPayment]'] = vendorPayment.toStringAsFixed(2);
    }

    if (inventoryProducts != null) {
      for (var i = 0; i < inventoryProducts.length; i++) {
        final item = inventoryProducts[i];
        fields['inventoryProducts[$i][product]'] = item['product'];
        fields['inventoryProducts[$i][productType]'] = item['productType'];
      }
    }

    if (attachments != null && attachments.isNotEmpty) {
      final fileList = <MultipartFile>[];
      for (final f in attachments) {
        fileList.add(await MultipartFile.fromFile(f.path));
      }
      fields['attachments'] = fileList;
    }

    final res = await _api.patch(
      ApiConstants.updateSales(id),
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String token, String id) async {
    await _connectivity.checkConnectivity();
    try {
      final res = await _api.dio.delete(
        ApiConstants.deleteSales(id),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to delete sale';
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }
      throw ServerException(message, e.response?.statusCode, e.message);
    }
  }

  Future<Map<String, dynamic>> convertType(
      String token, String id, String currentSalesType) async {
    await _connectivity.checkConnectivity();
    final newType =
        currentSalesType.toLowerCase() == 'sold' ? 'consigned' : 'sold';
    final res = await _api.dio.patch(
      ApiConstants.convertSalesType(id),
      data: {'salesType': newType},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: 'application/json',
      ),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getVendors(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.commonAllVendors,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFacilities(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommonAllFacilities,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPhysicians(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommonPhysiciansAll,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getRepresentatives(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommonAllRepresentative,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInventory(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.commonAllInventory,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }
}
