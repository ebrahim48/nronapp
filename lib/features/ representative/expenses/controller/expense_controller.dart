import 'dart:async';
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
import '../../physicions/data/repositories/physician_repository.dart';
import '../../physicions/domain/model/physician_model.dart';
import '../data/repositories/expense_repository.dart';
import '../domain/model/expense_model.dart';

class ExpenseController extends GetxController {
  final _repo = ExpenseRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );
  final _physicianRepo = PhysicianRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── List ──────────────────────────────────────────────────────────────────
  final allExpenses = <ExpenseModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final searchQuery = ''.obs;
  final selectedFilter = ExpenseStatus.all.obs;
  final scrollController = ScrollController();
  int _currentPage = 1;
  int _totalPage = 1;
  Timer? _searchDebounce;

  // ── Detail ────────────────────────────────────────────────────────────────
  final detailObs = Rxn<ExpenseDetailModel>();
  final isLoadingDetail = false.obs;

  // ── Delete ────────────────────────────────────────────────────────────────
  final isDeleting = false.obs;

  // ── Dropdowns data ────────────────────────────────────────────────────────
  final representatives = <RepresentativeModel>[].obs;
  final isLoadingRepresentatives = false.obs;
  final physicianList = <PhysicianModel>[].obs;
  final isLoadingPhysicians = false.obs;

  // ── Form ──────────────────────────────────────────────────────────────────
  final selectedRepresentativeId = ''.obs;
  final selectedRepresentativeName = ''.obs;
  final selectedPhysicianId = ''.obs;
  final selectedPhysicianName = ''.obs;
  final selectedCategory = ''.obs;
  final selectedYear = ''.obs;
  final selectedMonth = ''.obs;
  final isPaid = true.obs;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final expenseDateController = TextEditingController();
  final uploadedFiles = <File>[].obs;
  final isSubmitting = false.obs;
  final isPickingFile = false.obs;
  final lastCreatedId = ''.obs;

  // ── Static data ───────────────────────────────────────────────────────────
  final years = List.generate(
    DateTime.now().year - 2019 + 5,
    (i) => (2020 + i).toString(),
  );
  final months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  final categories = [
    'Meals', 'Travel', 'Medical Supply', 'Office', 'Entertainment', 'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    _setCurrentYearMonth();
    fetchExpenses();
    fetchRepresentatives();
    fetchPhysiciansForDropdown();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    expenseDateController.dispose();
    super.onClose();
  }

  void _setCurrentYearMonth() {
    final now = DateTime.now();
    selectedYear.value = now.year.toString();
    selectedMonth.value = DateFormat('MMMM').format(now);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  // ── Fetch list ────────────────────────────────────────────────────────────
  Future<void> fetchExpenses({bool reset = true}) async {
    if (reset) {
      _currentPage = 1;
      allExpenses.clear();
      isLoading.value = true;
    } else {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      final statusParam = selectedFilter.value == ExpenseStatus.all
          ? null
          : selectedFilter.value.name;
      final res = await _repo.getAll(
        token,
        page: _currentPage,
        limit: 10,
        searchTerm: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: statusParam,
      );
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final meta = data['meta'] as Map<String, dynamic>;
        _totalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;
        final results = (data['results'] as List<dynamic>)
            .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
            .toList();
        allExpenses.addAll(results);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  bool get canLoadMore =>
      _currentPage < _totalPage &&
      !isLoadingMore.value &&
      !isLoading.value;

  void _loadMore() {
    if (!canLoadMore) return;
    _currentPage++;
    fetchExpenses(reset: false);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce =
        Timer(const Duration(milliseconds: 500), () => fetchExpenses());
  }

  void onFilterSelected(ExpenseStatus status) {
    selectedFilter.value = status;
    fetchExpenses();
  }

  Future<void> refresh() => fetchExpenses();

  List<ExpenseModel> get filteredExpenses => allExpenses;

  // ── Fetch detail ──────────────────────────────────────────────────────────
  Future<void> fetchDetail(String id) async {
    isLoadingDetail.value = true;
    detailObs.value = null;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      if (res['success'] == true) {
        detailObs.value = ExpenseDetailModel.fromJson(
            res['data'] as Map<String, dynamic>);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  Future<bool> deleteExpense(String id) async {
    isDeleting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.delete(token, id);
      if (res['success'] == true) {
        allExpenses.removeWhere((e) => e.id == id);
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

  // ── Representatives dropdown ──────────────────────────────────────────────
  Future<void> fetchRepresentatives() async {
    isLoadingRepresentatives.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getRepresentatives(token);
      debugPrint('[ExpenseCtrl] representatives raw: $res');
      final success = res['success'];
      if (success == true || success == 'true') {
        final data = res['data'];
        List<dynamic> rawList;
        if (data is List) {
          rawList = data;
        } else if (data is Map) {
          rawList = (data['results'] ?? data['data'] ?? []) as List<dynamic>;
        } else {
          rawList = [];
        }
        debugPrint('[ExpenseCtrl] representatives count: ${rawList.length}');
        final list = rawList
            .map((e) =>
                RepresentativeModel.fromJson(e as Map<String, dynamic>))
            .toList();
        representatives.assignAll(list);
        _resolveRepresentativeName();
      } else {
        debugPrint('[ExpenseCtrl] fetchRepresentatives: success != true → $success');
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      debugPrint('[ExpenseCtrl] fetchRepresentatives ServerException: ${e.message}');
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (e, st) {
      debugPrint('[ExpenseCtrl] fetchRepresentatives error: $e\n$st');
      ToastMessageHelper.showToastMessage('Failed to load representatives.',
          title: 'Error');
    } finally {
      isLoadingRepresentatives.value = false;
    }
  }

  void _resolveRepresentativeName() {
    if (selectedRepresentativeId.value.isNotEmpty &&
        selectedRepresentativeName.value.isEmpty) {
      final rep = representatives.firstWhereOrNull(
          (r) => r.id == selectedRepresentativeId.value);
      if (rep != null) selectedRepresentativeName.value = rep.fullName;
    }
  }

  // ── Physicians dropdown ───────────────────────────────────────────────────
  Future<void> fetchPhysiciansForDropdown() async {
    isLoadingPhysicians.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _physicianRepo.getAll(token, page: 1, limit: 100);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final results = (data['results'] as List<dynamic>)
            .map((e) =>
                PhysicianModel.fromJson(e as Map<String, dynamic>))
            .toList();
        physicianList.assignAll(results);
        _resolvePhysicianName();
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isLoadingPhysicians.value = false;
    }
  }

  void _resolvePhysicianName() {
    if (selectedPhysicianId.value.isNotEmpty &&
        selectedPhysicianName.value.isEmpty) {
      final ph = physicianList
          .firstWhereOrNull((p) => p.id == selectedPhysicianId.value);
      if (ph != null) selectedPhysicianName.value = ph.fullName;
    }
  }

  void selectRepresentative(String id, String name) {
    selectedRepresentativeId.value = id;
    selectedRepresentativeName.value = name;
  }

  void selectPhysician(String id, String name) {
    selectedPhysicianId.value = id;
    selectedPhysicianName.value = name;
  }

  // ── Prefill for edit ──────────────────────────────────────────────────────
  void prefillForEdit(ExpenseDetailModel d) {
    selectedRepresentativeId.value = d.representativeId ?? '';
    selectedRepresentativeName.value = d.representative?.fullName ?? '';
    selectedPhysicianId.value = d.physicianId ?? '';
    selectedPhysicianName.value = '';
    _resolvePhysicianName();
    selectedCategory.value = d.category ?? '';
    selectedYear.value = d.year.isNotEmpty ? d.year : selectedYear.value;
    selectedMonth.value = d.month.isNotEmpty ? d.month : selectedMonth.value;
    isPaid.value = d.isPaid ?? true;
    amountController.text =
        d.amount > 0 ? d.amount.toStringAsFixed(0) : '';
    descriptionController.text = d.description ?? '';
    expenseDateController.text = d.dateOfExpense ?? '';
    uploadedFiles.clear();
  }

  void clearForm() {
    selectedRepresentativeId.value = '';
    selectedRepresentativeName.value = '';
    selectedPhysicianId.value = '';
    selectedPhysicianName.value = '';
    selectedCategory.value = '';
    _setCurrentYearMonth();
    isPaid.value = true;
    amountController.clear();
    descriptionController.clear();
    expenseDateController.clear();
    uploadedFiles.clear();
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<bool> submitExpense(BuildContext context,
      {String? expenseId}) async {
    final repId = selectedRepresentativeId.value;
    final category = selectedCategory.value;
    final amount =
        double.tryParse(amountController.text.trim()) ?? 0;
    final description = descriptionController.text.trim();
    final dateStr = expenseDateController.text.trim();

    if (repId.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a representative.',
          title: 'Required');
      return false;
    }
    if (category.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select a category.',
          title: 'Required');
      return false;
    }
    if (dateStr.isEmpty) {
      ToastMessageHelper.showToastMessage('Please select an expense date.',
          title: 'Required');
      return false;
    }
    if (amount <= 0) {
      ToastMessageHelper.showToastMessage('Please enter a valid amount.',
          title: 'Required');
      return false;
    }
    if (description.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter a description.',
          title: 'Required');
      return false;
    }

    String apiDate = dateStr;
    try {
      final dt = DateFormat('MM/dd/yyyy').parse(dateStr);
      apiDate = dt.toUtc().toIso8601String();
    } catch (_) {}

    isSubmitting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      Map<String, dynamic> res;
      if (expenseId == null) {
        res = await _repo.create(
          token,
          representativeId: repId,
          physicianId: selectedPhysicianId.value.isNotEmpty
              ? selectedPhysicianId.value
              : null,
          category: category,
          date: apiDate,
          year: selectedYear.value,
          month: selectedMonth.value,
          totalAmount: amount,
          isPaid: isPaid.value,
          description: description,
          files: uploadedFiles.isEmpty ? null : uploadedFiles.toList(),
        );
      } else {
        res = await _repo.update(
          token,
          expenseId,
          representativeId: repId,
          physicianId: selectedPhysicianId.value.isNotEmpty
              ? selectedPhysicianId.value
              : null,
          category: category,
          date: apiDate,
          year: selectedYear.value,
          month: selectedMonth.value,
          totalAmount: amount,
          isPaid: isPaid.value,
          description: description,
          files: uploadedFiles.isEmpty ? null : uploadedFiles.toList(),
        );
      }
      if (res['success'] == true) {
        lastCreatedId.value =
            (res['data'] as Map<String, dynamic>?)?['_id']?.toString() ?? '';
        clearForm();
        return true;
      }
    } on NoInternetException {
    } on ServerException catch (_) {
    } catch (_) {
    } finally {
      isSubmitting.value = false;
    }
    return false;
  }

  // ── Date picker ───────────────────────────────────────────────────────────
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
      expenseDateController.text = DateFormat('MM/dd/yyyy').format(picked);
      selectedYear.value = picked.year.toString();
      selectedMonth.value = DateFormat('MMMM').format(picked);
    }
  }

  // ── File picker ───────────────────────────────────────────────────────────
  Future<void> attachFile() async {
    try {
      isPickingFile.value = true;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'gif'],
        allowMultiple: true,
        withData: false,
      );
      if (result != null && result.files.isNotEmpty) {
        for (final file in result.files) {
          if (file.path != null) uploadedFiles.add(File(file.path!));
        }
      }
    } catch (_) {
    } finally {
      isPickingFile.value = false;
    }
  }

  void removeFile(int index) => uploadedFiles.removeAt(index);
}
