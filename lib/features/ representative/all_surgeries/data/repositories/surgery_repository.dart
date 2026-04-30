import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class SurgeryRepository {
  final ConnectivityService _connectivity;
  final ApiService _api;

  SurgeryRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivity = connectivityService,
        _api = apiService;

  Future<Map<String, dynamic>> getCommonPhysicians(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommonPhysiciansAll,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCommonFacilities(String token) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getCommonAllFacilities,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAll(
    String token, {
    int page = 1,
    int limit = 10,
    String? searchTerm,
  }) async {
    await _connectivity.checkConnectivity();
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (searchTerm != null && searchTerm.isNotEmpty) {
      params['searchTerm'] = searchTerm;
    }
    final res = await _api.get(
      ApiConstants.getSurgeryAll,
      queryParameters: params,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSingle(String token, String id) async {
    await _connectivity.checkConnectivity();
    final res = await _api.get(
      ApiConstants.getSingleSurgery(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> create(
    String token, {
    required String physicianId,
    required String patientId,
    required String facilityId,
    required String dateOfSurgery,
    required String surgeryType,
    required String screws,
    required String plates,
    required String rodsOrConnectors,
    required String implants,
    required String caseNotes,
    File? sticker,
    File? appre,
    File? appost,
    File? lateralpre,
    File? lateralpost,
    List<File>? notes,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{
      'physician': physicianId,
      'patientId': patientId,
      'facility': facilityId,
      'dateOfSurgery': dateOfSurgery,
      'surgeryType': surgeryType,
      'screws': screws,
      'plates': plates,
      'rodsOrconnectors': rodsOrConnectors,
      'implants': implants,
      'caseNotes': caseNotes,
    };
    if (sticker != null) fields['sticker'] = await MultipartFile.fromFile(sticker.path);
    if (appre != null) fields['appre'] = await MultipartFile.fromFile(appre.path);
    if (appost != null) fields['appost'] = await MultipartFile.fromFile(appost.path);
    if (lateralpre != null) fields['lateralpre'] = await MultipartFile.fromFile(lateralpre.path);
    if (lateralpost != null) fields['lateralpost'] = await MultipartFile.fromFile(lateralpost.path);
    if (notes != null && notes.isNotEmpty) {
      for (final f in notes) {
        fields['notes'] = await MultipartFile.fromFile(f.path);
      }
    }
    final res = await _api.post(
      ApiConstants.createSurgery,
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> update(
    String token,
    String id, {
    String? physicianId,
    String? patientId,
    String? facilityId,
    String? dateOfSurgery,
    String? surgeryType,
    String? screws,
    String? plates,
    String? rodsOrConnectors,
    String? implants,
    String? caseNotes,
    File? sticker,
    File? appre,
    File? appost,
    File? lateralpre,
    File? lateralpost,
    List<File>? notes,
  }) async {
    await _connectivity.checkConnectivity();
    final fields = <String, dynamic>{};
    if (physicianId != null && physicianId.isNotEmpty) fields['physician'] = physicianId;
    if (patientId != null && patientId.isNotEmpty) fields['patientId'] = patientId;
    if (facilityId != null && facilityId.isNotEmpty) fields['facility'] = facilityId;
    if (dateOfSurgery != null && dateOfSurgery.isNotEmpty) fields['dateOfSurgery'] = dateOfSurgery;
    if (surgeryType != null && surgeryType.isNotEmpty) fields['surgeryType'] = surgeryType;
    if (screws != null && screws.isNotEmpty) fields['screws'] = screws;
    if (plates != null && plates.isNotEmpty) fields['plates'] = plates;
    if (rodsOrConnectors != null && rodsOrConnectors.isNotEmpty) fields['rodsOrconnectors'] = rodsOrConnectors;
    if (implants != null && implants.isNotEmpty) fields['implants'] = implants;
    if (caseNotes != null && caseNotes.isNotEmpty) fields['caseNotes'] = caseNotes;
    if (sticker != null) fields['sticker'] = await MultipartFile.fromFile(sticker.path);
    if (appre != null) fields['appre'] = await MultipartFile.fromFile(appre.path);
    if (appost != null) fields['appost'] = await MultipartFile.fromFile(appost.path);
    if (lateralpre != null) fields['lateralpre'] = await MultipartFile.fromFile(lateralpre.path);
    if (lateralpost != null) fields['lateralpost'] = await MultipartFile.fromFile(lateralpost.path);
    if (notes != null && notes.isNotEmpty) {
      for (final f in notes) {
        fields['notes'] = await MultipartFile.fromFile(f.path);
      }
    }
    final res = await _api.patch(
      ApiConstants.updateSurgery(id),
      data: FormData.fromMap(fields),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String token, String id) async {
    await _connectivity.checkConnectivity();
    try {
      final res = await _api.dio.delete(
        ApiConstants.deleteSurgery(id),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to delete surgery';
      if (data is Map && data['message'] != null) message = data['message'].toString();
      throw ServerException(message, e.response?.statusCode, e.message);
    }
  }
}
