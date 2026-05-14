import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
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

  final isLoading = true.obs;
  final driverName = ''.obs;
  final isOnline = true.obs;
  final showLocationPrompt = false.obs;
  final homeData = DriverHomeData.empty.obs;

  final selectedJob = Rxn<JobRequestModel>();
  final isAccepting = false.obs;


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


  JobDetailModel? get jobDetail {
    final job = selectedJob.value;
    if (job == null) return null;
    return JobDetailModel.fromJobRequest(job);
  }

  void selectJob(JobRequestModel job) {
    selectedJob.value = job;
  }


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



  Future<void> acceptJob() async {
    final job = selectedJob.value;
    if (job == null || isAccepting.value) return;

    try {
      isAccepting.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.acceptJob(job.id, token);
      if (res['success'] == true) {
        Get.back();
        fetchHome();
        ToastMessageHelper.showSuccessMessage('Job accepted successfully');
      } else {
        ToastMessageHelper.showErrorMessage(
            res['message']?.toString() ?? 'Failed to accept job');
      }
    } catch (e) {
      final msg = e is ServerException ? e.message : 'Failed to accept job';
      ToastMessageHelper.showErrorMessage(msg);
    } finally {
      isAccepting.value = false;
    }
  }

  void declineJob() {
    Get.back();
  }

  void onNavTap(int index) {

  }
}
