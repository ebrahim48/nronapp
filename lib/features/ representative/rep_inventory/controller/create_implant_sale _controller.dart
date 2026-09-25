import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../ representative/sales/data/repositories/sales_repository.dart';
import '../../../ representative/sales/model/sales_model.dart';
import '../model/implant_model.dart';

class CreateImplantSaleController extends GetxController {
  final ImplantModel implant;
  CreateImplantSaleController({required this.implant});

  String get implantId => implant.id;

  final _repo = SalesRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Dropdowns ──────────────────────────────────────────────────────────────
  final physicianList = <VendorModel>[].obs;
  final facilityList = <FacilityDropdownModel>[].obs;
  final vendorList = <VendorModel>[].obs;
  final repDropdownList = <VendorModel>[].obs;
  final isLoadingDropdowns = true.obs;
  final isLoadingRepDropdown = false.obs;

  final selectedPhysicianId = ''.obs;
  final selectedPhysicianName = ''.obs;
  final selectedFacilityId = ''.obs;
  final selectedFacilityName = ''.obs;
  final selectedVendorId = ''.obs;
  final selectedVendorName = ''.obs;

  // ── Representatives ────────────────────────────────────────────────────────
  final addedRepresentatives = <RepresentativeModel>[].obs;

  int get totalCommissionPercent =>
      addedRepresentatives.fold(0, (sum, r) => sum + r.commissionPercent);

  void addRepresentative(RepresentativeModel rep) =>
      addedRepresentatives.add(rep);
  void removeRepresentative(int index) => addedRepresentatives.removeAt(index);

  // ── Inventory implants ────────────────────────────────────────────────────
  final allInventoryImplants = <ImplantItem>[].obs;
  final selectedInventoryImplants = <ImplantItem>[].obs;
  final isLoadingInventory = false.obs;
  final implantSearchQuery = ''.obs;

  List<ImplantItem> get filteredImplants {
    final q = implantSearchQuery.value.toLowerCase();
    if (q.isEmpty) return allInventoryImplants;
    return allInventoryImplants
        .where((item) =>
            item.name.toLowerCase().contains(q) ||
            item.serial.toLowerCase().contains(q))
        .toList();
  }

  int get selectedImplantCount =>
      allInventoryImplants.where((i) => i.isSelected).length;

  void toggleImplant(int index) {
    allInventoryImplants[index].isSelected =
        !allInventoryImplants[index].isSelected;
    allInventoryImplants.refresh();
  }

  void confirmSelectedImplants() {
    selectedInventoryImplants
        .assignAll(allInventoryImplants.where((i) => i.isSelected));
  }

  // ── Form ───────────────────────────────────────────────────────────────────
  final saleType = 'sold'.obs;
  final procedureDate = ''.obs;
  final procedureDateController = TextEditingController();
  final poNumberController = TextEditingController();
  final totalBillController = TextEditingController();
  final vendorPaymentController = TextEditingController();
  final additionalNotesController = TextEditingController();
  final generatePackingSlip = true.obs;
  final isSubmitting = false.obs;

  List<String> get physicianNames => physicianList.map((p) => p.name).toList();
  List<String> get facilityNames => facilityList.map((f) => f.name).toList();
  List<String> get vendorNames => vendorList.map((v) => v.name).toList();

  @override
  void onInit() {
    super.onInit();
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    try {
      isLoadingDropdowns.value = true;
      final token = await PrefsHelper.getString('auth_token');

      final results = await Future.wait([
        _repo.getPhysicians(token),       // [0]
        _repo.getFacilities(token),       // [1]
        _repo.getVendors(token),          // [2]
        _repo.getRepresentatives(token),  // [3]
        _repo.getInventory(token, type: 'inventory'),        // [4]
      ]);

      // Guard: screen may have been popped while requests were in-flight
      if (isClosed) return;

      physicianList.assignAll(
        _parseList(results[0]['data'])
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      facilityList.assignAll(
        _parseList(results[1]['data'])
            .map((e) => FacilityDropdownModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      vendorList.assignAll(
        _parseList(results[2]['data'])
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      repDropdownList.assignAll(
        _parseList(results[3]['data'])
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      allInventoryImplants.assignAll(
        _parseList(results[4]['data'])
            .map((e) => ImplantItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      _preselectFromImplant();
    } catch (_) {
    } finally {
      if (!isClosed) isLoadingDropdowns.value = false;
    }
  }

  List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map) return (data['results'] ?? data['data'] ?? []) as List<dynamic>;
    return [];
  }

  void _preselectFromImplant() {
    if (implant.vendorId != null && implant.vendorId!.isNotEmpty) {
      final match = vendorList.where((v) => v.id == implant.vendorId!);
      if (match.isNotEmpty) {
        selectedVendorId.value = match.first.id;
        selectedVendorName.value = match.first.name;
      }
    } else if (implant.vendor.isNotEmpty) {
      final match = vendorList.where(
          (v) => v.name.toLowerCase() == implant.vendor.toLowerCase());
      if (match.isNotEmpty) {
        selectedVendorId.value = match.first.id;
        selectedVendorName.value = match.first.name;
      }
    }

    if (implant.facilityId != null && implant.facilityId!.isNotEmpty) {
      final match = facilityList.where((f) => f.id == implant.facilityId!);
      if (match.isNotEmpty) {
        selectedFacilityId.value = match.first.id;
        selectedFacilityName.value = match.first.name;
      }
    } else if (implant.facility.isNotEmpty) {
      final match = facilityList.where(
          (f) => f.name.toLowerCase() == implant.facility.toLowerCase());
      if (match.isNotEmpty) {
        selectedFacilityId.value = match.first.id;
        selectedFacilityName.value = match.first.name;
      }
    }
  }

  void selectPhysician(String? name) {
    if (name == null) return;
    final match = physicianList.where((p) => p.name == name);
    if (match.isNotEmpty) {
      selectedPhysicianId.value = match.first.id;
      selectedPhysicianName.value = match.first.name;
    }
  }

  void selectFacility(String? name) {
    if (name == null) return;
    final match = facilityList.where((f) => f.name == name);
    if (match.isNotEmpty) {
      selectedFacilityId.value = match.first.id;
      selectedFacilityName.value = match.first.name;
    }
  }

  void selectVendor(String? name) {
    if (name == null) return;
    final match = vendorList.where((v) => v.name == name);
    if (match.isNotEmpty) {
      selectedVendorId.value = match.first.id;
      selectedVendorName.value = match.first.name;
    }
  }

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
      final formatted = DateFormat('MM/dd/yyyy').format(picked);
      procedureDate.value = formatted;
      procedureDateController.text = formatted;
    }
  }

  String _toApiProductModel(String raw) {
    switch (raw.toLowerCase()) {
      case 'implant':       return 'Implant';
      case 'tray':          return 'Tray';
      case 'bio':           return 'Bio';
      case 'purchaseorder': return 'PurchaseOrder';
      default:              return 'Implant'; // safe fallback
    }
  }

  String _toApiAssignRole(String role) {
    switch (role.toLowerCase()) {
      case 'assist': return 'assist';
      default:       return 'primary';
    }
  }

  Future<bool> submit() async {
    if (selectedPhysicianId.value.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select a physician');
      return false;
    }
    if (selectedFacilityId.value.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select a facility');
      return false;
    }
    if (procedureDate.value.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please select a procedure date');
      return false;
    }
    if (addedRepresentatives.isEmpty) {
      ToastMessageHelper.showErrorMessage('Please add at least one representative');
      return false;
    }

    final totalBill = double.tryParse(totalBillController.text.trim()) ?? 0;
    final vendorPay = double.tryParse(vendorPaymentController.text.trim()) ?? 0;

    final reps = addedRepresentatives
        .map((r) => {
              'representative': r.id,
              'assignRole': _toApiAssignRole(r.role),
              'commissionRate': r.commissionPercent,
            })
        .toList();

    final products = [
      // The implant this sale is created from — always an Implant inventory item
      {
        'product': implantId,
        'productModel': 'Implant',
        'productType': 'inventory',
      },
      // Any additional inventory items the user selected
      ...selectedInventoryImplants.map((item) {
        final model = _toApiProductModel(
            item.productModel.isNotEmpty ? item.productModel : item.productType);
        return {
          'product': item.id,
          'productModel': model,
          'productType': 'inventory',
        };
      }),
    ];

    try {
      isSubmitting.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.create(
        token,
        salesType: saleType.value,
        physicianId: selectedPhysicianId.value,
        facilityId: selectedFacilityId.value,
        procedureDate: procedureDate.value,
        representatives: reps,
        inventoryProducts: products,
        vendorId: selectedVendorId.value,
        purchaseOrderNumber: poNumberController.text.trim(),
        totalAmount: totalBill,
        vendorPayment: vendorPay,
        description: additionalNotesController.text.trim().isNotEmpty
            ? additionalNotesController.text.trim()
            : null,
        isPackingSlipGenerated: generatePackingSlip.value,
      );
      return true;
    } catch (e) {
      final raw = e is AppException ? e.message : 'Failed to create sale';
      final msg = raw
          .replaceAll(RegExp(r'\b[0-9a-f]{24}\b'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      ToastMessageHelper.showErrorMessage(msg);
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    procedureDateController.dispose();
    poNumberController.dispose();
    totalBillController.dispose();
    vendorPaymentController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}
