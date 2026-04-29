import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/physician_repository.dart';
import '../domain/model/physician_model.dart';

class PhysiciansController extends GetxController {
  final _repo = PhysicianRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final physicians = <PhysicianModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final searchQuery = ''.obs;
  final scrollController = ScrollController();

  int _currentPage = 1;
  int _totalPage = 1;
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    fetchPhysicians();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> fetchPhysicians({bool reset = true}) async {
    if (reset) {
      _currentPage = 1;
      physicians.clear();
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
            .map((e) => PhysicianModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _totalPage = (meta['totalPage'] as num?)?.toInt() ?? 1;
        physicians.addAll(results);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to load physicians.',
          title: 'Error');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void onSearch(String v) {
    searchQuery.value = v;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchPhysicians();
    });
  }

  bool get canLoadMore =>
      _currentPage < _totalPage &&
      !isLoadingMore.value &&
      !isLoading.value;

  void loadMore() {
    if (!canLoadMore) return;
    _currentPage++;
    fetchPhysicians(reset: false);
  }

  Future<void> deletePhysician(String id) async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.delete(token, id);
      if (res['success'] == true) {
        physicians.removeWhere((p) => p.id == id);
        ToastMessageHelper.showToastMessage(
            'Physician deleted successfully.',
            title: 'Success');
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to delete physician.',
          title: 'Error');
    }
  }

  Future<void> refresh() => fetchPhysicians();
}
