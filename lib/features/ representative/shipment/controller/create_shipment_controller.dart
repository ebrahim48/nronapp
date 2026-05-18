import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/shipment_repository.dart';

class FacilityOption {
  final String id;
  final String name;
  const FacilityOption({required this.id, required this.name});
}

class CreateShipmentController extends GetxController {
  final _repo = ShipmentRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Shipment Information ──────────────────────────────────────────────────
  final companyController             = TextEditingController();
  final jobNameController             = TextEditingController();
  final recipientController           = TextEditingController();
  final specialInstructionsController = TextEditingController();

  // ── Logistics – Pickup ────────────────────────────────────────────────────
  final pickupAddressController      = TextEditingController();
  final pickupContactController      = TextEditingController();
  final pickupPhoneController        = TextEditingController();
  final pickupDateController         = TextEditingController();
  final pickupInstructionsController = TextEditingController();

  // ── Logistics – Drop-off ──────────────────────────────────────────────────
  final dropoffAddressController      = TextEditingController();
  final dropoffContactController      = TextEditingController();
  final dropoffPhoneController        = TextEditingController();
  final dropoffInstructionsController = TextEditingController();

  // ── Package Details ───────────────────────────────────────────────────────
  final weightController     = TextEditingController();
  final dimensionsController = TextEditingController();
  final distanceController   = TextEditingController();
  final totalCostController  = TextEditingController();

  // ── Coordinates (set by map picker, not user-typed) ───────────────────────
  double? pickupLat;
  double? pickupLng;
  double? dropoffLat;
  double? dropoffLng;

  // ── Dropdowns ─────────────────────────────────────────────────────────────
  static const serviceTypes = ['fedex', 'courier'];
  static const packageTypes = ['implant', 'tray', 'bio', 'other'];
  static const priorities   = ['urgent', 'express', 'priority', 'standard', 'economy'];

  final selectedServiceType = 'fedex'.obs;
  final selectedPackageType = 'implant'.obs;
  final selectedPriority    = 'standard'.obs;

  // ── Shipment Rate (from API) ──────────────────────────────────────────────
  double amountPerKm = 0;
  final Map<String, double> _priorityCharges = {};
  final estimatedCost   = 0.0.obs;
  final estimatedBase   = 0.0.obs;
  final priorityCharge  = 0.0.obs;
  final isRateLoading   = false.obs;

  // ── Facility ─────────────────────────────────────────────────────────────
  final facilities           = <FacilityOption>[].obs;
  final isFacilitiesLoading  = false.obs;
  final selectedFacilityId   = ''.obs;
  final selectedFacilityName = ''.obs;

  final isLoading = false.obs;

  final selectedProducts = <Map<String, String>>[].obs;
  final uploadedFiles    = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFacilities();
    _loadShipmentRate();
    distanceController.addListener(_recalculate);
  }

  Future<void> _loadShipmentRate() async {
    try {
      isRateLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getShipmentRate(token);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        amountPerKm = (data['amountPerKm'] as num?)?.toDouble() ?? 0;
        final charges = data['priorityCharges'] as List? ?? [];
        for (final c in charges) {
          final p = c['priority']?.toString() ?? '';
          final extra = (c['extraCharge'] as num?)?.toDouble() ?? 0;
          if (p.isNotEmpty) _priorityCharges[p] = extra;
        }
        _recalculate();
      }
    } catch (_) {
    } finally {
      isRateLoading.value = false;
    }
  }

  void _recalculate() {
    final dist = double.tryParse(distanceController.text.trim()) ?? 0;
    final base  = amountPerKm * dist;
    final extra = _priorityCharges[selectedPriority.value] ?? 0;
    estimatedBase.value  = base;
    priorityCharge.value = extra;
    estimatedCost.value  = base + extra;
    totalCostController.text =
        (base + extra) > 0 ? (base + extra).toStringAsFixed(2) : '';
  }

  Future<void> _loadFacilities() async {
    try {
      isFacilitiesLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getFacilities(token);
      final raw = res['data'] as List? ?? [];
      facilities.assignAll(
        raw.whereType<Map<String, dynamic>>().map((f) => FacilityOption(
              id: f['_id']?.toString() ?? '',
              name: f['name']?.toString() ?? f['facilityName']?.toString() ?? '',
            )).where((f) => f.id.isNotEmpty).toList(),
      );
      if (facilities.isNotEmpty) {
        selectedFacilityId.value   = facilities.first.id;
        selectedFacilityName.value = facilities.first.name;
      }
    } catch (_) {
    } finally {
      isFacilitiesLoading.value = false;
    }
  }

  void setServiceType(String v) => selectedServiceType.value = v;
  void setPackageType(String v) => selectedPackageType.value = v;

  void setPriority(String v) {
    selectedPriority.value = v;
    _recalculate();
  }

  void setFacility(FacilityOption f) {
    selectedFacilityId.value   = f.id;
    selectedFacilityName.value = f.name;
  }

  void setPickupLocation(String address, double lat, double lng) {
    pickupAddressController.text = address;
    pickupLat = lat;
    pickupLng = lng;
  }

  void setDropoffLocation(String address, double lat, double lng) {
    dropoffAddressController.text = address;
    dropoffLat = lat;
    dropoffLng = lng;
  }

  void addFile(File f)   => uploadedFiles.add(f);
  void removeFile(int i) => uploadedFiles.removeAt(i);

  bool validateStep1() {
    if (companyController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter company name');
      return false;
    }
    if (selectedProducts.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please add at least one product');
      return false;
    }
    if (distanceController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter distance');
      return false;
    }
    if (totalCostController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Cost not calculated yet, enter distance first');
      return false;
    }
    return true;
  }

  bool validateStep2() {
    if (pickupAddressController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select pickup address');
      return false;
    }
    if (pickupPhoneController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter pickup phone number');
      return false;
    }
    if (dropoffAddressController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select drop-off address');
      return false;
    }
    if (dropoffPhoneController.text.trim().isEmpty) {
      ToastMessageHelper.showErrorMessage('Please enter drop-off phone number');
      return false;
    }
    if (selectedFacilityId.value.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select a drop-off facility');
      return false;
    }
    return true;
  }

  Future<bool> createJob() async {
    if (!validateStep1() || !validateStep2()) return false;
    try {
      isLoading.value = true;
      final token  = await PrefsHelper.getString('auth_token');
      final userId = await PrefsHelper.getString('user_id');
      await _repo.create(
        token,
        userId,
        company:             companyController.text.trim(),
        jobName:             jobNameController.text.trim(),
        specialInstructions: specialInstructionsController.text.trim(),
        priority:            selectedPriority.value,
        type:                selectedPackageType.value,
        serviceType:         selectedServiceType.value,
        weight:              weightController.text.trim(),
        dimensions:          dimensionsController.text.trim(),
        distance:            double.tryParse(distanceController.text.trim()) ?? 0,
        totalCost:           double.tryParse(totalCostController.text.trim()) ?? 0,
        pickupAddress:       pickupAddressController.text.trim(),
        pickupPhone:         pickupPhoneController.text.trim(),
        pickupDate:          pickupDateController.text.trim(),
        pickupInstructions:  pickupInstructionsController.text.trim(),
        pickupLat:           pickupLat,
        pickupLng:           pickupLng,
        dropoffAddress:      dropoffAddressController.text.trim(),
        dropoffPhone:        dropoffPhoneController.text.trim(),
        dropoffInstructions: dropoffInstructionsController.text.trim(),
        dropoffFacility:     selectedFacilityId.value,
        dropoffLat:          dropoffLat,
        dropoffLng:          dropoffLng,
        products:            selectedProducts,
        files:               uploadedFiles,
      );
      ToastMessageHelper.showSuccessMessage('Shipment job created successfully');
      return true;
    } catch (e) {
      final raw = e is AppException ? e.message : 'Failed to create shipment job';
      final msg = raw
          .replaceAll(RegExp(r'\b[0-9a-f]{24}\b'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      ToastMessageHelper.showErrorMessage(msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    distanceController.removeListener(_recalculate);
    companyController.dispose();
    jobNameController.dispose();
    recipientController.dispose();
    specialInstructionsController.dispose();
    pickupAddressController.dispose();
    pickupContactController.dispose();
    pickupPhoneController.dispose();
    pickupDateController.dispose();
    pickupInstructionsController.dispose();
    dropoffAddressController.dispose();
    dropoffContactController.dispose();
    dropoffPhoneController.dispose();
    dropoffInstructionsController.dispose();
    weightController.dispose();
    dimensionsController.dispose();
    distanceController.dispose();
    totalCostController.dispose();
    super.onClose();
  }
}
