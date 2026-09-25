import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class ShipmentRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  ShipmentRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  Future<Map<String, dynamic>> getHome(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.getShipment, options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getList(
    String token, {
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (status != null && status.isNotEmpty) params['status'] = status;
    final res = await _api.get(
      ApiConstants.getMyShipment,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getShipmentDetails(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getShipmentRate(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.shipmentRate,
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

  Future<Map<String, dynamic>> create(
    String token,
    String userId, {
    required String company,
    required String jobName,
    String specialInstructions = '',
    String priority = '',
    String type = '',
    String serviceType = '',
    String weight = '',
    String dimensions = '',
    double distance = 0,
    double totalCost = 0,
    required String pickupAddress,
    String pickupPhone = '',
    String pickupDate = '',
    String pickupInstructions = '',
    double? pickupLat,
    double? pickupLng,
    required String dropoffAddress,
    String dropoffPhone = '',
    String dropoffInstructions = '',
    String dropoffFacility = '',
    double? dropoffLat,
    double? dropoffLng,
    List<Map<String, String>> products = const [],
    List<File> files = const [],
  }) async {
    await _connectivity.checkConnectivity();

    // JSON body so coordinates are actual numbers (FormData stringifies everything)
    final body = <String, dynamic>{
      'shipmentInfo': {
        'company': company,
        'recipient': userId,
        if (type.isNotEmpty) 'type': type,
        if (priority.isNotEmpty) 'priority': priority,
      },
      'packageInfo': {
        'serviceType': serviceType,
        if (weight.isNotEmpty) 'weight': weight,
        if (dimensions.isNotEmpty) 'dimensions': dimensions,
        'spacialInstructions': specialInstructions,
      },
      'pickupInfo': {
        'address': pickupAddress,
        'contactPerson': userId,
        if (pickupPhone.isNotEmpty) 'phoneNumber': pickupPhone,
        if (pickupDate.isNotEmpty) 'pickupDate': pickupDate,
        if (pickupInstructions.isNotEmpty) 'instructions': pickupInstructions,
        'coordinates': [pickupLng ?? 0.0, pickupLat ?? 0.0],
      },
      'dropoffInfo': {
        'address': dropoffAddress,
        'contactPerson': userId,
        if (dropoffPhone.isNotEmpty) 'phoneNumber': dropoffPhone,
        if (dropoffInstructions.isNotEmpty) 'instructions': dropoffInstructions,
        'facility': dropoffFacility,
        'coordinates': [dropoffLng ?? 0.0, dropoffLat ?? 0.0],
      },
      'products': products
          .map((p) => {
                'product': p['product'] ?? '',
                'productModel': _toApiProductModel(
                    (p['productModel'] != null && p['productModel']!.isNotEmpty)
                        ? p['productModel']!
                        : p['productType'] ?? ''),
                'productType': _toApiProductType(p['productType'] ?? ''),
              })
          .toList(),
      'totalPrice': totalCost,
      'totalDistance': distance.toString(),
    };

    final res = await _api.post(
      ApiConstants.createShipment,
      data: body,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  // API enum: 'Implant' | 'Tray' | 'Bio' | 'PurchaseOrder'
  String _toApiProductModel(String raw) {
    switch (raw.toLowerCase()) {
      case 'implant':       return 'Implant';
      case 'tray':          return 'Tray';
      case 'bio':           return 'Bio';
      case 'purchaseorder': return 'PurchaseOrder';
      default:              return 'Implant'; // safe fallback
    }
  }

  // API enum: 'inventory' | 'purchase'
  String _toApiProductType(String raw) {
    switch (raw.toLowerCase()) {
      case 'purchase': return 'purchase';
      default:         return 'inventory';
    }
  }

  // shippingCost.type only accepts 'fedex' | 'courier'
  String _normalizeShippingCostType(String v) =>
      v.toLowerCase() == 'fedex' ? 'fedex' : 'courier';

  // IServiceType: 'fedex' | 'ups' | 'usps' | 'courier'
  String _normalizeServiceType(String v) {
    switch (v.toLowerCase()) {
      case 'fedex': return 'fedex';
      case 'ups':   return 'ups';
      case 'usps':  return 'usps';
      default:      return 'courier';
    }
  }

  // API enum: 'implant' | 'tray' | 'bio' | 'other'
  String _normalizePackageType(String v) {
    switch (v.toLowerCase()) {
      case 'implant': return 'implant';
      case 'tray':    return 'tray';
      case 'bio':     return 'bio';
      default:        return 'other';
    }
  }

  // API enum: 'Implant' | 'Tray' | 'Bio'
  String _normalizeProductType(String v) {
    switch (v.toLowerCase()) {
      case 'tray': return 'Tray';
      case 'bio':  return 'Bio';
      default:     return 'Implant';
    }
  }
}
