import 'package:get/get.dart';

import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../data/driver_job_repository.dart';
import '../model/driver_job_model.dart';

class DriverJobController extends GetxController {
  final _repo = DriverJobRepository();

  final selectedTab = DriverJobTab.newJobs.obs;
  final selectedPeriod = CompletedPeriod.today.obs;

  final isLoading = false.obs;
  final isDetailLoading = false.obs;

  final newJobs = <NewJobModel>[].obs;
  final activeJobs = <ActiveJobModel>[].obs;
  final completedJobs = <CompletedJobModel>[].obs;

  final selectedJobDetail = Rxn<JobDetailFullModel>();

  @override
  void onInit() {
    super.onInit();
    fetchNewJobs();
  }

  void onTabSelected(DriverJobTab tab) {
    selectedTab.value = tab;
    // Fetch data for the selected tab on demand
    switch (tab) {
      case DriverJobTab.newJobs:
        fetchNewJobs();
        break;
      case DriverJobTab.active:
        fetchActiveJobs();
        break;
      case DriverJobTab.completed:
        fetchCompletedJobs();
        break;
    }
  }

  void onPeriodSelected(CompletedPeriod period) =>
      selectedPeriod.value = period;

  int get newJobCount => newJobs.length;
  int get activeJobCount => activeJobs.length;

  // ── Fetch new jobs (pending_approval / no status filter) ─────────────────

  Future<void> fetchNewJobs() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final response = await _repo.getAllJobs(token);
      final results = _parseResults(response);
      newJobs.assignAll(
        results
            .where((json) {
              final s = ShipmentStatusX.fromString(
                  _effectiveStatus(json));
              return s.isNew;
            })
            .map((json) => NewJobModel.fromJson(json))
            .toList(),
      );
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch active jobs ─────────────────────────────────────────────────────

  Future<void> fetchActiveJobs() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final response = await _repo.getAllJobs(token, status: 'active');
      final results = _parseResults(response);
      activeJobs.assignAll(
        results.map((json) => ActiveJobModel.fromJson(json)).toList(),
      );
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch completed jobs ──────────────────────────────────────────────────

  Future<void> fetchCompletedJobs() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final response = await _repo.getAllJobs(token, status: 'completed');
      final results = _parseResults(response);
      completedJobs.assignAll(
        results.map((json) => CompletedJobModel.fromJson(json)).toList(),
      );
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Refresh current tab ───────────────────────────────────────────────────

  Future<void> fetchJobs() async {
    switch (selectedTab.value) {
      case DriverJobTab.newJobs:
        await fetchNewJobs();
        break;
      case DriverJobTab.active:
        await fetchActiveJobs();
        break;
      case DriverJobTab.completed:
        await fetchCompletedJobs();
        break;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _parseResults(Map<String, dynamic> response) {
    final raw = response['data']?['results'];
    if (raw is List) {
      return raw.cast<Map<String, dynamic>>();
    }
    return [];
  }

  String _effectiveStatus(Map<String, dynamic> json) {
    final shipmentStatus = json['shipmentStatus']?.toString() ?? '';
    if (shipmentStatus.isNotEmpty) return shipmentStatus;
    // fallback to `status` field
    switch ((json['status'] ?? '').toString().toLowerCase()) {
      case 'active':    return 'accepted';
      case 'completed': return 'delivered';
      case 'pending':   return 'pending_approval';
      default:          return '';
    }
  }

  Future<void> fetchJobDetail(String id) async {
    try {
      isDetailLoading.value = true;
      selectedJobDetail.value = null;
      final token = await PrefsHelper.getString('auth_token');
      final response = await _repo.getSingleJob(token, id);
      final data = response['data'] as Map<String, dynamic>?;
      if (data != null) {
        selectedJobDetail.value = JobDetailFullModel.fromJson(data);
      }
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> acceptJob(String id) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.acceptJob(token, id);
      ToastMessageHelper.showSuccessMessage('Job accepted successfully');
      await fetchJobs();
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeStatus(String id, String status) async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      await _repo.changeStatus(token, id, status);
      await fetchJobs();
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    }
  }

  void navigateJob() {
    // Navigation is handled in the screen using go_router with context
    // This is kept for backward compatibility with ActiveJobCard's onNavigate
  }
}
