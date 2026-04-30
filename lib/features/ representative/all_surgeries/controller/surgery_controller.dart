import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../physicions/data/repositories/physician_repository.dart';
import '../../physicions/domain/model/physician_model.dart';
import '../data/repositories/surgery_repository.dart';
import '../model/surgery_model.dart';

class SurgeryController extends GetxController {
  final _repo = SurgeryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final _physicianRepo = PhysicianRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoadingPhysician = false.obs;

  // ── List ──────────────────────────────────────────────────────────────────
  final surgeries = <SurgeryModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final searchQuery = ''.obs;
  final scrollController = ScrollController();

  int _currentPage = 1;
  int _totalPage = 1;
  Timer? _searchDebounce;

  // ── Detail ────────────────────────────────────────────────────────────────
  final detail = Rxn<SurgeryDetailModel>();
  final isLoadingDetail = false.obs;

  // ── Common physicians for dropdown ────────────────────────────────────────
  final commonPhysicians = <CommonPhysicianModel>[].obs;
  final isLoadingPhysicians = false.obs;
  final selectedPhysicianId = ''.obs;
  final selectedPhysicianName = ''.obs;

  // ── Common facilities for dropdown ────────────────────────────────────────
  final facilities = <FacilityModel>[].obs;
  final isLoadingFacilities = false.obs;
  final selectedFacilityId = ''.obs;
  final selectedFacilityName = ''.obs;

  // ── Add/Edit form ─────────────────────────────────────────────────────────
  final patientIdController = TextEditingController();
  final facilityIdController = TextEditingController();
  final facilityNameController = TextEditingController();
  final surgeryTypeController = TextEditingController();
  final screwsController = TextEditingController();
  final platesController = TextEditingController();
  final rodsController = TextEditingController();
  final implantsController = TextEditingController();
  final biologicsController = TextEditingController();
  final caseNotesController = TextEditingController();
  final dateOfSurgery = ''.obs;
  final isSubmitting = false.obs;

  // ── Radiology picked images ───────────────────────────────────────────────
  final radiologyPickedImages = <String, String?>{
    'AP POST': null,
    'AP PRE': null,
    'LATERAL POST': null,
    'LATERAL PRE': null,
    'PATIENT STICKER': null,
  }.obs;

  // ── Uploaded documents ────────────────────────────────────────────────────
  final uploadedDocFiles = <File>[].obs;

  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchSurgeries();
    fetchCommonPhysicians();
    fetchFacilities();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    patientIdController.dispose();
    facilityIdController.dispose();
    facilityNameController.dispose();
    surgeryTypeController.dispose();
    screwsController.dispose();
    platesController.dispose();
    rodsController.dispose();
    implantsController.dispose();
    biologicsController.dispose();
    caseNotesController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  // ── Fetch surgeries list ──────────────────────────────────────────────────
  Future<void> fetchSurgeries({bool reset = true}) async {
    if (reset) {
      _currentPage = 1;
      surgeries.clear();
      isLoading.value = true;
    } else {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getAll(
        token,
        page: _currentPage,
        limit: 10,
        searchTerm: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final meta = data['meta'] as Map<String, dynamic>;
        final results = (data['results'] as List<dynamic>)
            .map((e) => SurgeryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _totalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;
        surgeries.addAll(results);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to load surgeries.', title: 'Error');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void onSearch(String v) {
    searchQuery.value = v;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () => fetchSurgeries());
  }

  bool get canLoadMore => _currentPage < _totalPage && !isLoadingMore.value && !isLoading.value;

  void loadMore() {
    if (!canLoadMore) return;
    _currentPage++;
    fetchSurgeries(reset: false);
  }

  Future<void> refresh() => fetchSurgeries();

  // ── Fetch single surgery detail ───────────────────────────────────────────
  Future<void> fetchDetail(String id) async {
    isLoadingDetail.value = true;
    detail.value = null;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getSingle(token, id);
      if (res['success'] == true) {
        detail.value = SurgeryDetailModel.fromJson(
            res['data'] as Map<String, dynamic>);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to load surgery details.', title: 'Error');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // ── Fetch common physicians ───────────────────────────────────────────────
  Future<void> fetchCommonPhysicians() async {
    isLoadingPhysicians.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getCommonPhysicians(token);
      if (res['success'] == true) {
        final list = (res['data'] as List<dynamic>)
            .map((e) => CommonPhysicianModel.fromJson(e as Map<String, dynamic>))
            .toList();
        commonPhysicians.assignAll(list);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {} finally {
      isLoadingPhysicians.value = false;
    }
  }

  void selectPhysician(String id, String name) {
    selectedPhysicianId.value = id;
    selectedPhysicianName.value = name;
  }

  // ── Fetch facilities ──────────────────────────────────────────────────────
  Future<void> fetchFacilities() async {
    isLoadingFacilities.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getCommonFacilities(token);
      if (res['success'] == true) {
        final list = (res['data'] as List<dynamic>)
            .map((e) => FacilityModel.fromJson(e as Map<String, dynamic>))
            .toList();
        facilities.assignAll(list);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {} finally {
      isLoadingFacilities.value = false;
    }
  }

  void selectFacility(String id, String name) {
    selectedFacilityId.value = id;
    selectedFacilityName.value = name;
  }

  // ── Prefill form for edit ─────────────────────────────────────────────────
  void prefillForEdit(SurgeryDetailModel d) {
    selectPhysician(d.physicianId, d.physicianName);
    patientIdController.text = d.patientId;
    selectFacility(d.facilityId, d.facilityName);
    surgeryTypeController.text = d.surgeryType;
    screwsController.text = d.screws;
    platesController.text = d.plates;
    rodsController.text = d.rodsOrConnectors;
    implantsController.text = d.implants;
    caseNotesController.text = d.caseNotes;
    if (d.dateOfSurgery.isNotEmpty) {
      try {
        final dt = DateTime.parse(d.dateOfSurgery);
        dateOfSurgery.value = DateFormat('MM/dd/yyyy').format(dt);
      } catch (_) {
        dateOfSurgery.value = d.dateOfSurgery;
      }
    }
  }

  void clearForm() {
    selectedPhysicianId.value = '';
    selectedPhysicianName.value = '';
    patientIdController.clear();
    facilityIdController.clear();
    facilityNameController.clear();
    selectedFacilityId.value = '';
    selectedFacilityName.value = '';
    surgeryTypeController.clear();
    screwsController.clear();
    platesController.clear();
    rodsController.clear();
    implantsController.clear();
    biologicsController.clear();
    caseNotesController.clear();
    dateOfSurgery.value = '';
    radiologyPickedImages.updateAll((key, _) => null);
    uploadedDocFiles.clear();
  }

  // ── Submit (create / update) ──────────────────────────────────────────────
  Future<void> submitSurgery(BuildContext context, {String? surgeryId}) async {
    final physicianId = selectedPhysicianId.value;
    final patientId = patientIdController.text.trim();
    final facilityId = selectedFacilityId.value;
    final surgeryType = surgeryTypeController.text.trim();
    final dob = dateOfSurgery.value.trim();

    if (physicianId.isEmpty || patientId.isEmpty || facilityId.isEmpty || surgeryType.isEmpty || dob.isEmpty) {
      return;
    }

    String apiDate = dob;
    try {
      final dt = DateFormat('MM/dd/yyyy').parse(dob);
      apiDate = dt.toUtc().toIso8601String();
    } catch (_) {}

    File? _file(String key) {
      final path = radiologyPickedImages[key];
      return path != null ? File(path) : null;
    }

    isSubmitting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      Map<String, dynamic> res;
      if (surgeryId == null) {
        res = await _repo.create(
          token,
          physicianId: physicianId,
          patientId: patientId,
          facilityId: facilityId,
          dateOfSurgery: apiDate,
          surgeryType: surgeryType,
          screws: screwsController.text.trim(),
          plates: platesController.text.trim(),
          rodsOrConnectors: rodsController.text.trim(),
          implants: implantsController.text.trim(),
          caseNotes: caseNotesController.text.trim(),
          sticker: _file('PATIENT STICKER'),
          appre: _file('AP PRE'),
          appost: _file('AP POST'),
          lateralpre: _file('LATERAL PRE'),
          lateralpost: _file('LATERAL POST'),
          notes: uploadedDocFiles.isEmpty ? null : uploadedDocFiles.toList(),
        );
      } else {
        res = await _repo.update(
          token,
          surgeryId,
          physicianId: physicianId,
          patientId: patientId,
          facilityId: facilityId,
          dateOfSurgery: apiDate,
          surgeryType: surgeryType,
          screws: screwsController.text.trim(),
          plates: platesController.text.trim(),
          rodsOrConnectors: rodsController.text.trim(),
          implants: implantsController.text.trim(),
          caseNotes: caseNotesController.text.trim(),
          sticker: _file('PATIENT STICKER'),
          appre: _file('AP PRE'),
          appost: _file('AP POST'),
          lateralpre: _file('LATERAL PRE'),
          lateralpost: _file('LATERAL POST'),
          notes: uploadedDocFiles.isEmpty ? null : uploadedDocFiles.toList(),
        );
      }
      if (res['success'] == true) {
        clearForm();
        if (context.mounted) Navigator.pop(context, true);
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Radiology image picker ────────────────────────────────────────────────
  final isDeleting = false.obs;

  Future<bool> deleteSurgery(String id) async {
    isDeleting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.delete(token, id);
      if (res['success'] == true) {
        surgeries.removeWhere((s) => s.id == id);
        return true;
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isDeleting.value = false;
    }
    return false;
  }

  final pickingRadiologyLabel = ''.obs;

  Future<void> pickRadiologyImage(String label) async {
    pickingRadiologyLabel.value = label;
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked != null) {
        radiologyPickedImages[label] = picked.path;
        radiologyPickedImages.refresh();
      }
    } finally {
      pickingRadiologyLabel.value = '';
    }
  }

  // ── Fetch full physician by ID ────────────────────────────────────────────
  Future<PhysicianModel?> fetchPhysicianById(String id) async {
    if (id.isEmpty) return null;
    isLoadingPhysician.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _physicianRepo.getSingle(token, id);
      if (res['success'] == true) {
        final data = res['data'];
        if (data is Map<String, dynamic>) {
          return PhysicianModel.fromJson(data);
        }
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to load physician.', title: 'Error');
    } finally {
      isLoadingPhysician.value = false;
    }
    return null;
  }

  // ── Document picker ───────────────────────────────────────────────────────
  Future<void> pickDocument() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      uploadedDocFiles.add(File(picked.path));
    }
  }

  void removeDoc(int index) {
    if (index < uploadedDocFiles.length) uploadedDocFiles.removeAt(index);
  }

  // ── Date picker ───────────────────────────────────────────────────────────
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00C5DA),
            onPrimary: Colors.white,
            surface: Color(0xFF252525),
            onSurface: Colors.white,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF1E2427)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dateOfSurgery.value = DateFormat('MM/dd/yyyy').format(picked);
    }
  }
}
