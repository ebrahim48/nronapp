import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/driver_home_repository.dart';
import '../model/driver_home_model.dart';

class DriverHomeController extends GetxController {
  final _repo = DriverHomeRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── State ─────────────────────────────────────────────────────────────────
  final isLoading = true.obs;
  final driverName = ''.obs;
  final isOnline = true.obs;
  final showLocationPrompt = false.obs;
  final homeData = DriverHomeData.empty.obs;

  // ── Selected job for detail screen ────────────────────────────────────────
  final selectedJob = Rxn<JobRequestModel>();

  // ── Stat cards ────────────────────────────────────────────────────────────
  List<DriverStatModel> get stats => [
        DriverStatModel(
          iconPath: 'assets/icons/pendingpickups.svg',
          value: '${homeData.value.newJobs}',
          label: 'New Jobs',
        ),
        DriverStatModel(
          iconPath: 'assets/icons/activedeliveries.svg',
          value: '${homeData.value.active}',
          label: 'Active Deliveries',
        ),
        DriverStatModel(
          iconPath: 'assets/icons/completedtoday.svg',
          value: '${homeData.value.completed}',
          label: 'Completed Today',
        ),
        DriverStatModel(
          iconPath: 'assets/icons/todayearnings.svg',
          value: '\$${homeData.value.todayEarnings.toStringAsFixed(0)}',
          label: 'Today Earnings',
        ),
      ];

  int get availableJobs => homeData.value.newJobRequests.length;

  @override
  void onInit() {
    super.onInit();
    _loadDriverName();
    fetchHome();
  }

  Future<void> _loadDriverName() async {
    final name = await PrefsHelper.getString('user_name');
    driverName.value = name.isNotEmpty ? name : 'Driver';
  }

  // ── Fetch home data ───────────────────────────────────────────────────────

  Future<void> fetchHome() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDriverHome(token);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        homeData.value = DriverHomeData.fromJson(data);
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load home data');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Job detail ────────────────────────────────────────────────────────────

  JobDetailModel? get jobDetail {
    final job = selectedJob.value;
    if (job == null) return null;
    return JobDetailModel.fromJobRequest(job);
  }

  void selectJob(JobRequestModel job) {
    selectedJob.value = job;
  }

  // ── Online toggle ─────────────────────────────────────────────────────────

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
    if (!isOnline.value) {
      showLocationPrompt.value = true;
    }
  }

  void useMyLocation() {
    showLocationPrompt.value = false;
    isOnline.value = true;
  }

  void skipLocation() {
    showLocationPrompt.value = false;
  }

  // ── Job actions ───────────────────────────────────────────────────────────

  void acceptJob() {
    Get.snackbar('Accepted', 'Job accepted successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  void declineJob() {
    Get.back();
  }

  void onNavTap(int index) {}
}
