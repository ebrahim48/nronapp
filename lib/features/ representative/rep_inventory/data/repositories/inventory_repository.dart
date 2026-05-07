import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class InventoryRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  InventoryRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Options _auth(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  // ── Overview ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.getInventory, options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  // ── Implants ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getImplants(
    String token, {
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) params['search'] = search;
    final res = await _api.get(
      ApiConstants.getImplant,
      queryParameters: params,
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getImplantDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.getSingleImplant(id), options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createImplant(
    String token, {
    required String facilityId,
    required String serialNumber,
    required String systemType,
    String? lotNumber,
    String? material,
    String? vendor,
    String? recipientEmail,
    String? additionalNotes,
    String? brokenNotes,
    List<File>? inboundImages,
    List<File>? brokenImages,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'facility': facilityId,
      'serialNumber': serialNumber,
      'systemType': systemType,
    };
    if (lotNumber != null && lotNumber.isNotEmpty) fields['lotNumber'] = lotNumber;
    if (material != null && material.isNotEmpty) fields['material'] = material;
    if (vendor != null && vendor.isNotEmpty) fields['vendor'] = vendor;
    if (recipientEmail != null && recipientEmail.isNotEmpty) fields['recipientEmail'] = recipientEmail;
    if (additionalNotes != null && additionalNotes.isNotEmpty) fields['inboundNotes'] = additionalNotes;
    if (brokenNotes != null && brokenNotes.isNotEmpty) fields['brokenInstrumentsNotes'] = brokenNotes;
    if (inboundImages != null && inboundImages.isNotEmpty) {
      fields['inbound'] = await Future.wait(
        inboundImages.map((f) => MultipartFile.fromFile(f.path)),
      );
    }
    if (brokenImages != null && brokenImages.isNotEmpty) {
      fields['broken'] = await Future.wait(
        brokenImages.map((f) => MultipartFile.fromFile(f.path)),
      );
    }
    final res = await _api.post(
      ApiConstants.createImplant,
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateImplant(
    String token,
    String id, {
    String? facilityId,
    String? serialNumber,
    String? systemType,
    String? lotNumber,
    String? material,
    String? vendor,
    String? recipientEmail,
    String? additionalNotes,
    String? brokenNotes,
    List<File>? inboundImages,
    List<File>? brokenImages,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (facilityId != null) fields['facility'] = facilityId;
    if (serialNumber != null) fields['serialNumber'] = serialNumber;
    if (systemType != null) fields['systemType'] = systemType;
    if (lotNumber != null) fields['lotNumber'] = lotNumber;
    if (material != null) fields['material'] = material;
    if (vendor != null) fields['vendor'] = vendor;
    if (recipientEmail != null) fields['recipientEmail'] = recipientEmail;
    if (additionalNotes != null) fields['inboundNotes'] = additionalNotes;
    if (brokenNotes != null) fields['brokenInstrumentsNotes'] = brokenNotes;
    if (inboundImages != null && inboundImages.isNotEmpty) {
      fields['inbound'] = await Future.wait(inboundImages.map((f) => MultipartFile.fromFile(f.path)));
    }
    if (brokenImages != null && brokenImages.isNotEmpty) {
      fields['broken'] = await Future.wait(brokenImages.map((f) => MultipartFile.fromFile(f.path)));
    }
    final res = await _api.patch(
      ApiConstants.updateImplantById(id),
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteImplant(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.delete(
      ApiConstants.deleteImplantById(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendTransferRequest(
    String token,
    String id, {
    required String from,
    required String to,
    required String reason,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.post(
      ApiConstants.sendTransferRequest(id),
      data: {'from': from, 'to': to, 'reason': reason},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  // ── Trays ─────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getTrays(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getTray,
      queryParameters: {'page': page, 'limit': limit},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTrayDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.getTrayById(id), options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createTray(
    String token, {
    required String title,
    required String facilityId,
    String? vendorId,
    String? systemType,
    String? inventoryModel,
    String? status,
    String? returnDate,
    String? notes,
    File? thumbnail,
    List<File>? files,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'title': title,
      'facility': facilityId,
    };
    if (vendorId != null && vendorId.isNotEmpty) fields['vendor'] = vendorId;
    if (systemType != null && systemType.isNotEmpty) fields['systemType'] = systemType;
    if (inventoryModel != null && inventoryModel.isNotEmpty) fields['inventory'] = inventoryModel;
    if (status != null && status.isNotEmpty) fields['status'] = status;
    if (returnDate != null && returnDate.isNotEmpty) fields['returnDate'] = returnDate;
    if (notes != null && notes.isNotEmpty) fields['notes'] = notes;
    if (thumbnail != null) fields['thumbnail'] = await MultipartFile.fromFile(thumbnail.path);
    if (files != null && files.isNotEmpty) {
      fields['files'] = await Future.wait(files.map((f) => MultipartFile.fromFile(f.path)));
    }
    final res = await _api.post(
      ApiConstants.createTray,
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateTray(
    String token,
    String id, {
    String? title,
    String? facilityId,
    String? vendorId,
    String? systemType,
    String? inventoryModel,
    String? status,
    String? returnDate,
    String? notes,
    File? thumbnail,
    List<File>? files,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (title != null && title.isNotEmpty) fields['title'] = title;
    if (facilityId != null && facilityId.isNotEmpty) fields['facility'] = facilityId;
    if (vendorId != null && vendorId.isNotEmpty) fields['vendor'] = vendorId;
    if (systemType != null && systemType.isNotEmpty) fields['systemType'] = systemType;
    if (inventoryModel != null && inventoryModel.isNotEmpty) fields['inventory'] = inventoryModel;
    if (status != null && status.isNotEmpty) fields['status'] = status;
    if (returnDate != null && returnDate.isNotEmpty) fields['returnDate'] = returnDate;
    if (notes != null && notes.isNotEmpty) fields['notes'] = notes;
    if (thumbnail != null) fields['thumbnail'] = await MultipartFile.fromFile(thumbnail.path);
    if (files != null && files.isNotEmpty) {
      fields['files'] = await Future.wait(files.map((f) => MultipartFile.fromFile(f.path)));
    }
    final res = await _api.patch(
      ApiConstants.updateTrayById(id),
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteTray(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.delete(
      ApiConstants.deleteTrayById(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendTray(
    String token,
    String id, {
    required String facilityId,
    String? systemType,
    String? recipientName,
    String? recipientEmail,
    String? notes,
    File? thumbnail,
    List<File>? files,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{'facility': facilityId};
    if (systemType != null && systemType.isNotEmpty) fields['systemType'] = systemType;
    if (recipientName != null && recipientName.isNotEmpty) fields['recipientName'] = recipientName;
    if (recipientEmail != null && recipientEmail.isNotEmpty) fields['recipientEmail'] = recipientEmail;
    if (notes != null && notes.isNotEmpty) fields['notes'] = notes;
    if (thumbnail != null) fields['thumbnail'] = await MultipartFile.fromFile(thumbnail.path);
    if (files != null && files.isNotEmpty) {
      fields['files'] = await Future.wait(files.map((f) => MultipartFile.fromFile(f.path)));
    }
    final res = await _api.patch(
      ApiConstants.sendTrayById(id),
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> receiveTray(
    String token,
    String id, {
    File? thumbnail,
    List<File>? files,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (thumbnail != null) fields['thumbnail'] = await MultipartFile.fromFile(thumbnail.path);
    if (files != null && files.isNotEmpty) {
      fields['files'] = await Future.wait(files.map((f) => MultipartFile.fromFile(f.path)));
    }
    final res = await _api.patch(
      ApiConstants.receiveTrayById(id),
      data: fields.isEmpty ? {} : FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  // ── Bio ───────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getBio(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getBio,
      queryParameters: {'page': page, 'limit': limit},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBioDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.getSingleBio(id), options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createBio(
    String token, {
    required String itemName,
    required String lotNumber,
    required String quantity,
    required String location,
    String? vendorId,
    String? expiryDate,
    String? additionalNotes,
    File? photo,
  }) async {
    await _connectivity.checkConnectivity();
    final parsedQty = num.tryParse(quantity) ??
        num.tryParse(quantity.replaceAll(RegExp(r'[^0-9.]'), '')) ??
        quantity;
    final fields = <String, dynamic>{
      'itemName': itemName,
      'lotNumber': lotNumber,
      'quantity': parsedQty,
      'location': location,
    };
    if (vendorId != null && vendorId.isNotEmpty) fields['vendor'] = vendorId;
    if (expiryDate != null && expiryDate.isNotEmpty) fields['expiryDate'] = expiryDate;
    if (additionalNotes != null && additionalNotes.isNotEmpty) fields['notes'] = additionalNotes;
    if (photo != null) fields['thumbnail'] = await MultipartFile.fromFile(photo.path);
    final res = await _api.post(
      ApiConstants.createBio,
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateBio(
    String token,
    String id, {
    String? itemName,
    String? lotNumber,
    String? quantity,
    String? location,
    String? vendorId,
    String? expiryDate,
    String? additionalNotes,
    File? photo,
    List<File>? files,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (itemName != null && itemName.isNotEmpty) fields['itemName'] = itemName;
    if (lotNumber != null && lotNumber.isNotEmpty) fields['lotNumber'] = lotNumber;
    if (quantity != null && quantity.isNotEmpty) {
      final parsed = num.tryParse(quantity) ??
          num.tryParse(quantity.replaceAll(RegExp(r'[^0-9.]'), ''));
      fields['quantity'] = parsed ?? quantity;
    }
    if (location != null && location.isNotEmpty) fields['location'] = location;
    if (vendorId != null && vendorId.isNotEmpty) fields['vendor'] = vendorId;
    if (expiryDate != null && expiryDate.isNotEmpty) fields['expiryDate'] = expiryDate;
    if (additionalNotes != null && additionalNotes.isNotEmpty) fields['notes'] = additionalNotes;
    if (photo != null) fields['thumbnail'] = await MultipartFile.fromFile(photo.path);
    if (files != null && files.isNotEmpty) {
      fields['files'] = await Future.wait(files.map((f) => MultipartFile.fromFile(f.path)));
    }
    final res = await _api.patch(
      ApiConstants.updateBioById(id),
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteBio(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.delete(
      ApiConstants.deleteBioById(id),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  // ── Missing Instruments ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> createMissingInstrument(
    String token, {
    required String trayId,
    required String instrumentName,
    required String issueType,
    String? vendorId,
    String? descriptionAndNotes,
    File? photo,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'tray': trayId,
      'instrumentName': instrumentName,
      'issueType': issueType,
    };
    if (vendorId != null && vendorId.isNotEmpty) fields['vendor'] = vendorId;
    if (descriptionAndNotes != null && descriptionAndNotes.isNotEmpty) fields['descriptionAndNotes'] = descriptionAndNotes;
    if (photo != null) fields['files'] = await MultipartFile.fromFile(photo.path);
    final res = await _api.post(
      ApiConstants.createMissingInstrument,
      data: FormData.fromMap(fields),
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMissingOverview(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.getSummaryCount, options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMissingHistory(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getMissingHistory,
      queryParameters: {'page': page, 'limit': limit},
      options: _auth(token),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMissingDetail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(ApiConstants.findMissingInstrument(id), options: _auth(token));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendVendorMail(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.patch(
      ApiConstants.sendMissingVendorMail(id),
      data: {},
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
}
