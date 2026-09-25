import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/sales_repository.dart';
import '../model/sales_model.dart';
import '../../../../core/helpers/email_helper.dart';

class SaleController extends GetxController {
  final _repo = SalesRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final implantSales = 0.obs;
  final bioSales = 0.obs;
  final totalRevenue = 0.obs;
  final commission = 0.obs;
  final isLoadingOverview = false.obs;

  final recentSales = <SaleModel>[].obs;
  final isLoadingSales = false.obs;
  final isLoadingMore = false.obs;
  int _currentPage = 1;
  int _totalPage = 1;
  final scrollController = ScrollController();

  final allSalesList = <SaleModel>[].obs;
  final isLoadingAllSales = false.obs;
  final isLoadingMoreAllSales = false.obs;
  final allSalesFilter = ''.obs; // '' = all, 'pending', 'approved', 'rejected'
  int _allSalesPage = 1;
  int _allSalesTotalPage = 1;
  int _allSalesRequestId = 0; // drops stale responses on fast tab switches
  final allSalesScrollController = ScrollController();

  final detailObs = Rxn<SaleDetailModel>();
  final isLoadingDetail = false.obs;

  final isDeleting = false.obs;
  final isConverting = false.obs;
  final isSubmitting = false.obs;

  final physicianList = <VendorModel>[].obs;
  final facilityList = <FacilityDropdownModel>[].obs;
  final vendorList = <VendorModel>[].obs;
  final repDropdownList = <VendorModel>[].obs;

  final isLoadingPhysicians = false.obs;
  final isLoadingFacilities = false.obs;
  final isLoadingVendors = false.obs;
  final isLoadingRepDropdown = false.obs;
  final isLoadingInventory = false.obs;

  final selectedSaleType = SaleType.sold.obs;
  final selectedPhysician = ''.obs;       // stores physician ID
  final selectedPhysicianName = ''.obs;
  final selectedFacility = ''.obs;        // stores facility ID
  final selectedFacilityName = ''.obs;
  final procedureDate = ''.obs;
  final procedureDateController = TextEditingController();

  final selectedVendorId = ''.obs;
  final selectedVendorName = ''.obs;
  final vendorController = TextEditingController(); // kept for compat
  final poNumberController = TextEditingController();
  final totalBillController = TextEditingController();
  final vendorPaymentController = TextEditingController();
  final additionalNotesController = TextEditingController();
  final generatePackingSlip = true.obs;

  final addedRepresentatives = <RepresentativeModel>[].obs;

  final selectedImplants = <ImplantItem>[].obs;
  final allImplants = <ImplantItem>[].obs;
  final implantSearchQuery = ''.obs;

  final allPoItems = <ImplantItem>[].obs;
  final selectedPoItems = <ImplantItem>[].obs;
  final poSearchQuery = ''.obs;
  final inventoryModelFilter = ''.obs; // '' = All, 'Implant', 'Tray', 'Bio'

  final uploadedAttachments = <AttachmentFileModel>[].obs;
  final uploadedFiles = <File>[].obs;

  final packingSlipItems = const <PackingSlipItem>[
    PackingSlipItem(
        product: 'Neural Link Hub V2', serial: 'NL-882-991-A', qty: 1, price: 1250.00),
    PackingSlipItem(
        product: 'Titanium Mounting Kit', serial: 'TM-KIT-002', qty: 2, price: 45.00),
    PackingSlipItem(
        product: 'Fiber Optic Cable (5m)', serial: 'FO-5M-X9', qty: 5, price: 12.50),
  ];

  List<String> get physicians => physicianList.map((p) => p.name).toList();
  List<String> get physicianIds => physicianList.map((p) => p.id).toList();
  List<String> get facilities => facilityList.map((f) => f.name).toList();
  List<String> get facilityIds => facilityList.map((f) => f.id).toList();
  List<String> get vendorNames => vendorList.map((v) => v.name).toList();
  List<String> get vendorIds => vendorList.map((v) => v.id).toList();

  List<ImplantItem> get filteredImplants {
    var list = allImplants.toList();
    if (inventoryModelFilter.value.isNotEmpty) {
      list = list.where((i) => i.productModel == inventoryModelFilter.value).toList();
    }
    if (implantSearchQuery.value.isNotEmpty) {
      final q = implantSearchQuery.value.toLowerCase();
      list = list.where((i) =>
          i.name.toLowerCase().contains(q) ||
          i.serial.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  List<ImplantItem> get filteredPoItems {
    if (poSearchQuery.value.isEmpty) return allPoItems;
    final q = poSearchQuery.value.toLowerCase();
    return allPoItems
        .where((i) =>
            i.name.toLowerCase().contains(q) ||
            i.serial.toLowerCase().contains(q))
        .toList();
  }

  int get selectedImplantCount =>
      allImplants.where((i) => i.isSelected).length;

  int get selectedPoCount => allPoItems.where((i) => i.isSelected).length;

  int get totalCommissionPercent =>
      addedRepresentatives.fold(0, (sum, r) => sum + r.commissionPercent);

  double get packingSlipSubtotal =>
      packingSlipItems.fold(0, (s, i) => s + i.price);

  @override
  void onInit() {
    super.onInit();
    fetchOverview();
    fetchSales();
    fetchDropdowns();
    scrollController.addListener(_onScroll);
    allSalesScrollController.addListener(_onAllSalesScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    allSalesScrollController.removeListener(_onAllSalesScroll);
    allSalesScrollController.dispose();
    procedureDateController.dispose();
    vendorController.dispose();
    poNumberController.dispose();
    totalBillController.dispose();
    vendorPaymentController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> fetchOverview() async {
    isLoadingOverview.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getOverview(token);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>? ?? {};
        implantSales.value = (data['implantSales'] as num?)?.toInt() ?? 0;
        bioSales.value = (data['bioSales'] as num?)?.toInt() ?? 0;
        totalRevenue.value = (data['totalRevenue'] as num?)?.toInt() ?? 0;
        commission.value = (data['commission'] as num?)?.toInt() ?? 0;
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isLoadingOverview.value = false;
    }
  }

  Future<void> fetchSales({bool reset = true}) async {
    if (reset) {
      _currentPage = 1;
      recentSales.clear();
      isLoadingSales.value = true;
    } else {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res =
          await _repo.getAll(token, page: _currentPage, limit: 10);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final meta = data['meta'] as Map<String, dynamic>? ?? {};
        _totalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;
        final results = (data['results'] as List<dynamic>)
            .map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
            .toList();
        recentSales.addAll(results);
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isLoadingSales.value = false;
      isLoadingMore.value = false;
    }
  }

  void _loadMore() {
    if (_currentPage >= _totalPage ||
        isLoadingMore.value ||
        isLoadingSales.value) return;
    _currentPage++;
    fetchSales(reset: false);
  }

  Future<void> fetchAllSales({bool reset = true, String? filter}) async {
    final requestId = reset ? ++_allSalesRequestId : _allSalesRequestId;
    if (reset) {
      _allSalesPage = 1;
      allSalesList.clear();
      isLoadingAllSales.value = true;
      if (filter != null) allSalesFilter.value = filter;
    } else {
      if (isLoadingMoreAllSales.value) return;
      isLoadingMoreAllSales.value = true;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final status = allSalesFilter.value.isEmpty ? null : allSalesFilter.value;
      final res = await _repo.getAll(token,
          page: _allSalesPage, limit: 15, status: status);
      if (requestId != _allSalesRequestId) return; // a newer tab took over
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final meta = data['meta'] as Map<String, dynamic>? ?? {};
        _allSalesTotalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;
        final results = (data['results'] as List<dynamic>)
            .map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
            // Enforce the tab client-side too, in case the API ignores status.
            .where((s) => status == null || s.status.name == status)
            .toList();
        allSalesList.addAll(results);
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      if (requestId == _allSalesRequestId) {
        isLoadingAllSales.value = false;
        isLoadingMoreAllSales.value = false;
      }
    }
    // Too few matches on this page to scroll → pull the next page.
    if (requestId == _allSalesRequestId &&
        allSalesList.length < 10 &&
        _allSalesPage < _allSalesTotalPage) {
      _allSalesPage++;
      await fetchAllSales(reset: false);
    }
  }

  void _onAllSalesScroll() {
    if (allSalesScrollController.position.pixels >=
        allSalesScrollController.position.maxScrollExtent - 200) {
      if (_allSalesPage < _allSalesTotalPage &&
          !isLoadingMoreAllSales.value &&
          !isLoadingAllSales.value) {
        _allSalesPage++;
        fetchAllSales(reset: false);
      }
    }
  }

  Future<void> fetchDetail(String id) async {
    isLoadingDetail.value = true;
    detailObs.value = null;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      debugPrint('[SaleCtrl] fetchDetail res: $res');
      if (res['success'] == true) {
        final rawData = res['data'];
        final data = rawData is Map<String, dynamic>
            ? rawData
            : Map<String, dynamic>.from(rawData as Map);
        detailObs.value = SaleDetailModel.fromJson(data);
      }
    } on NoInternetException {
    } on ServerException catch (e) {
      debugPrint('[SaleCtrl] fetchDetail ServerException: ${e.message}');
    } catch (e, st) {
      debugPrint('[SaleCtrl] fetchDetail error: $e\n$st');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<bool> deleteSale(String id) async {
    isDeleting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.delete(token, id);
      if (res['success'] == true) {
        recentSales.removeWhere((s) => s.id == id);
        return true;
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isDeleting.value = false;
    }
    return false;
  }

  Future<bool> convertSaleType(String id) async {
    isConverting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final currentType = detailObs.value?.salesTypeRaw ?? '';
      final res = await _repo.convertType(token, id, currentType);
      if (res['success'] == true) {
        await fetchDetail(id);
        return true;
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isConverting.value = false;
    }
    return false;
  }

  // ── Packing slip: email to vendor ─────────────────────────────────────────
  Future<void> emailPackingSlipToVendor(SaleDetailModel d) async {
    String fmt(String v) => v.trim().isEmpty ? '—' : v.trim();
    final items = d.inventoryItems;
    final subtotal =
        items.fold<double>(0, (sum, i) => sum + (i.price * i.qty));
    final total = subtotal > 0 ? subtotal : d.totalAmount;

    final body = StringBuffer()
      ..writeln('Hello ${fmt(d.vendor)},')
      ..writeln()
      ..writeln('Please find the packing slip details below.')
      ..writeln()
      ..writeln('PACKING SLIP')
      ..writeln('Sale ID: ${fmt(d.saleNumber)}')
      ..writeln('Date: ${fmt(d.procedureDate)}')
      ..writeln('Facility: ${fmt(d.facility)}')
      ..writeln('Physician: ${fmt(d.physician)}')
      ..writeln('PO Number: ${fmt(d.ppoNumber)}')
      ..writeln()
      ..writeln('ITEMS');
    if (items.isEmpty) {
      body.writeln('No items.');
    } else {
      for (final i in items) {
        final name = i.name.isEmpty ? i.tag : i.name;
        final sn = i.serial.isNotEmpty ? ' (SN: ${i.serial})' : '';
        final price = i.price > 0
            ? ' - \$${(i.price * i.qty).toStringAsFixed(2)}'
            : '';
        body.writeln('• $name$sn x${i.qty}$price');
      }
    }
    body
      ..writeln()
      ..writeln('TOTAL: \$${total.toStringAsFixed(2)}');

    await EmailHelper.compose(
      to: d.vendorEmail.trim(),
      subject: 'Packing Slip - ${fmt(d.saleNumber)}',
      body: body.toString(),
    );
  }

  Future<void> fetchDropdowns() async {
    await Future.wait([
      fetchPhysicians(),
      fetchFacilities(),
      fetchVendors(),
      fetchRepDropdown(),
      fetchInventory(),
    ]);
  }

  Future<void> fetchPhysicians() async {
    isLoadingPhysicians.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getPhysicians(token);
      if (res['success'] == true) {
        physicianList.assignAll(_parseList(res['data'])
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    } catch (_) {
    } finally {
      isLoadingPhysicians.value = false;
    }
  }

  Future<void> fetchFacilities() async {
    isLoadingFacilities.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getFacilities(token);
      if (res['success'] == true) {
        facilityList.assignAll(_parseList(res['data'])
            .map((e) =>
                FacilityDropdownModel.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    } catch (_) {
    } finally {
      isLoadingFacilities.value = false;
    }
  }

  Future<void> fetchVendors() async {
    isLoadingVendors.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getVendors(token);
      if (res['success'] == true) {
        vendorList.assignAll(_parseList(res['data'])
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    } catch (_) {
    } finally {
      isLoadingVendors.value = false;
    }
  }

  Future<void> fetchRepDropdown() async {
    isLoadingRepDropdown.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getRepresentatives(token);
      if (res['success'] == true) {
        repDropdownList.assignAll(_parseList(res['data'])
            .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    } catch (_) {
    } finally {
      isLoadingRepDropdown.value = false;
    }
  }

  Future<void> fetchInventory() async {
    isLoadingInventory.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final results = await Future.wait([
        _repo.getInventory(token, type: 'inventory'),
        _repo.getInventory(token, type: 'purchase'),
      ]);
      final invRes = results[0];
      final poRes = results[1];
      if (invRes['success'] == true) {
        allImplants.assignAll(_parseList(invRes['data'])
            .map((e) => ImplantItem.fromJson(e as Map<String, dynamic>))
            .toList());
      }
      if (poRes['success'] == true) {
        allPoItems.assignAll(_parseList(poRes['data'])
            .map((e) => ImplantItem.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    } catch (e, st) {
      debugPrint('[Inventory] error: $e\n$st');
    } finally {
      isLoadingInventory.value = false;
    }
  }

  List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      return (data['results'] ?? data['data'] ?? []) as List<dynamic>;
    }
    return [];
  }

  void toggleImplant(int index) {
    allImplants[index].isSelected = !allImplants[index].isSelected;
    allImplants.refresh();
  }

  void confirmSelectedImplants() {
    selectedImplants.assignAll(allImplants.where((i) => i.isSelected));
  }

  void togglePoItem(int index) {
    allPoItems[index].isSelected = !allPoItems[index].isSelected;
    allPoItems.refresh();
  }

  void confirmSelectedPoItems() {
    selectedPoItems.assignAll(allPoItems.where((i) => i.isSelected));
  }

  void removeRepresentative(int index) {
    addedRepresentatives.removeAt(index);
  }

  void addRepresentative(RepresentativeModel rep) {
    addedRepresentatives.add(rep);
  }

  void pickDate(BuildContext context) async {
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
          dialogTheme:
              const DialogThemeData(backgroundColor: Color(0xFF1E2427)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final formatted =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      procedureDate.value = formatted;
      procedureDateController.text = formatted;
    }
  }

  Future<void> attachFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
        withData: false,
      );
      if (result != null) {
        for (final f in result.files) {
          if (f.path != null) {
            uploadedFiles.add(File(f.path!));
            uploadedAttachments.add(AttachmentFileModel.fromUrl(f.path!));
          }
        }
      }
    } catch (_) {}
  }

  void removeAttachment(int index) {
    uploadedAttachments.removeAt(index);
    if (index < uploadedFiles.length) uploadedFiles.removeAt(index);
  }

  void prefillForEdit(SaleDetailModel d) {
    selectedSaleType.value = d.salesTypeRaw.toLowerCase() == 'consigned'
        ? SaleType.consigned
        : SaleType.sold;
    selectedPhysician.value = d.physicianId;
    selectedPhysicianName.value = d.physician;
    selectedFacility.value = d.facilityId;
    selectedFacilityName.value = d.facility;
    final formattedDate = d.procedureDate;
    procedureDate.value = formattedDate;
    procedureDateController.text = formattedDate;
    selectedVendorId.value = d.vendorId;
    selectedVendorName.value = d.vendor;
    poNumberController.text = d.ppoNumber;
    totalBillController.text =
        d.totalAmount > 0 ? d.totalAmount.toStringAsFixed(0) : '';
    vendorPaymentController.text =
        d.vendorPayment > 0 ? d.vendorPayment.toStringAsFixed(0) : '';
    additionalNotesController.text = d.note;

    addedRepresentatives.assignAll(d.repSplits.map((r) => RepresentativeModel(
          id: r.id,
          name: r.name,
          role: r.role,
          commissionPercent: r.splitPercent,
        )));

    for (final item in allImplants) {
      item.isSelected = false;
    }
    allImplants.refresh();
    selectedImplants.clear();
    for (final item in allPoItems) {
      item.isSelected = false;
    }
    allPoItems.refresh();
    selectedPoItems.clear();
    uploadedAttachments.clear();
    uploadedFiles.clear();
  }


  void clearForm() {
    submitError.value = null;
    selectedSaleType.value = SaleType.sold;
    selectedPhysician.value = '';
    selectedPhysicianName.value = '';
    selectedFacility.value = '';
    selectedFacilityName.value = '';
    procedureDate.value = '';
    procedureDateController.clear();
    selectedVendorId.value = '';
    selectedVendorName.value = '';
    poNumberController.clear();
    totalBillController.clear();
    vendorPaymentController.clear();
    additionalNotesController.clear();
    generatePackingSlip.value = true;
    addedRepresentatives.clear();
    selectedImplants.clear();
    selectedPoItems.clear();
    uploadedAttachments.clear();
    uploadedFiles.clear();
    for (final item in allImplants) {
      item.isSelected = false;
    }
    allImplants.refresh();
    for (final item in allPoItems) {
      item.isSelected = false;
    }
    allPoItems.refresh();
  }


  final submitError = Rxn<String>();

  /// Maps the raw productModel/productType string to a valid API productModel.
  /// API accepts: 'Implant' | 'Tray' | 'Bio' | 'PurchaseOrder'
  /// Falls back to 'Implant' if value is unrecognised or empty.
  String _toApiProductModel(String raw) {
    switch (raw.toLowerCase()) {
      case 'implant':
        return 'Implant';
      case 'tray':
        return 'Tray';
      case 'bio':
        return 'Bio';
      case 'purchaseorder':
        return 'PurchaseOrder';
      default:
        return 'Implant'; // safe fallback — never send empty string
    }
  }

  /// Maps the rep role to a valid API assignRole value.
  /// API accepts: 'primary' | 'assist'
  String _toApiAssignRole(String role) {
    switch (role.toLowerCase()) {
      case 'assist':
        return 'assist';
      case 'primary':
      default:
        return 'primary';
    }
  }

  Future<bool> submitSale(BuildContext context, {String? saleId}) async {
    submitError.value = null;
    final physicianId = selectedPhysician.value;
    final facilityId = selectedFacility.value;
    final vendorId = selectedVendorId.value;
    final dateStr = procedureDate.value;
    final totalBill =
        double.tryParse(totalBillController.text.trim()) ?? 0;
    final vendorPay =
        double.tryParse(vendorPaymentController.text.trim()) ?? 0;
    final notes = additionalNotesController.text.trim();

    if (physicianId.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a physician.',
          title: 'Required');
      return false;
    }
    if (facilityId.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a facility.',
          title: 'Required');
      return false;
    }
    if (dateStr.isEmpty) {
      ToastMessageHelper.showToastMessage(
          'Please select a procedure date.',
          title: 'Required');
      return false;
    }
    if (addedRepresentatives.isEmpty) {
      ToastMessageHelper.showToastMessage(
          'Please add at least one representative.',
          title: 'Required');
      return false;
    }
    String apiDate = dateStr;
    try {
      final dt = DateFormat('MM/dd/yyyy').parse(dateStr);
      apiDate = dt.toUtc().toIso8601String();
    } catch (_) {}

    final reps = addedRepresentatives
        .map((r) => {
              'representative': r.id,
              'assignRole': _toApiAssignRole(r.role),
              'commissionRate': r.commissionPercent,
            })
        .toList();

    final inventory = [
      ...selectedImplants.map((item) => {
            'product': item.id,
            'productModel': _toApiProductModel(
                item.productModel.isNotEmpty ? item.productModel : item.productType),
            'productType': 'inventory',
          }),
      ...selectedPoItems.map((item) => {
            'product': item.id,
            'productModel': _toApiProductModel(
                item.productModel.isNotEmpty ? item.productModel : item.productType),
            'productType': 'purchase',
          }),
    ];

    isSubmitting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      Map<String, dynamic> res;
      if (saleId == null) {
        res = await _repo.create(
          token,
          salesType:
              selectedSaleType.value == SaleType.sold ? 'sold' : 'consigned',
          physicianId: physicianId,
          facilityId: facilityId,
          procedureDate: apiDate,
          representatives: reps,
          inventoryProducts: inventory,
          vendorId: vendorId,
          purchaseOrderNumber: poNumberController.text.trim(),
          totalAmount: totalBill,
          vendorPayment: vendorPay,
          description: notes.isEmpty ? null : notes,
          isPackingSlipGenerated: generatePackingSlip.value,
          attachments: uploadedFiles.isEmpty ? null : uploadedFiles.toList(),
        );
      } else {
        res = await _repo.update(
          token,
          saleId,
          salesType:
              selectedSaleType.value == SaleType.sold ? 'sold' : 'consigned',
          physicianId: physicianId,
          facilityId: facilityId,
          procedureDate: apiDate,
          representatives: reps,
          inventoryProducts: inventory,
          vendorId: vendorId.isEmpty ? null : vendorId,
          purchaseOrderNumber: poNumberController.text.trim(),
          totalAmount: totalBill,
          vendorPayment: vendorPay,
          description: notes.isEmpty ? null : notes,
          attachments: uploadedFiles.isEmpty ? null : uploadedFiles.toList(),
        );
      }
      if (res['success'] == true) {
        clearForm();
        fetchSales();
        fetchOverview();
        return true;
      } else {
        // Parse validation errorMessages if present
        final errorMessages = res['errorMessages'];
        if (errorMessages is List && errorMessages.isNotEmpty) {
          final msgs = errorMessages
              .map((e) => (e as Map<String, dynamic>)['message']?.toString() ?? '')
              .where((m) => m.isNotEmpty)
              .join('\n');
          submitError.value = msgs;
          ToastMessageHelper.showToastMessage(msgs, title: 'Validation Error');
        } else {
          final msg = res['message']?.toString() ?? 'Failed to save sale';
          submitError.value = msg;
          ToastMessageHelper.showToastMessage(msg, title: 'Error');
        }
      }
    } on NoInternetException {
      submitError.value = 'No internet connection.';
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      submitError.value = e.message;
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isSubmitting.value = false;
    }
    return false;
  }
}
