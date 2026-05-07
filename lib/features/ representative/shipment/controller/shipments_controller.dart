import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/shipment_repository.dart';
import '../model/shipment_model.dart';

class ShipmentsController extends GetxController {
  final _repo = ShipmentRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final activeJobsCount = 0.obs;
  final pendingPickupCount = 0.obs;
  final inTransitCount = 0.obs;
  final deliveredCount = 0.obs;
  final activeShipments = <ShipmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHome();
  }

  Future<void> fetchHome() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');

      // Run both requests in parallel
      final results = await Future.wait([
        _repo.getHome(token),
        _repo.getList(token, page: 1, limit: 10),
      ]);

      // ── Stats from home endpoint ──
      final homeData = results[0]['data'] as Map<String, dynamic>? ?? {};
      final overview = homeData['overview'] as Map<String, dynamic>?
          ?? homeData['summary'] as Map<String, dynamic>?
          ?? homeData;

      activeJobsCount.value   = _parseInt(overview['activeJobs']    ?? overview['active_jobs']    ?? homeData['activeJobs']    ?? 0);
      pendingPickupCount.value = _parseInt(overview['pendingPickup'] ?? overview['pending_pickup'] ?? homeData['pendingPickup'] ?? 0);
      inTransitCount.value    = _parseInt(overview['inTransit']     ?? overview['in_transit']     ?? homeData['inTransit']     ?? 0);
      deliveredCount.value    = _parseInt(overview['delivered']     ?? homeData['delivered']      ?? 0);

      // ── Active shipments from /shipment/get-my ──
      final listData = results[1]['data'] as Map<String, dynamic>? ?? {};
      final docs = listData['results'] as List?
          ?? listData['docs'] as List?
          ?? listData['shipments'] as List?
          ?? [];
      activeShipments.assignAll(
        docs.whereType<Map<String, dynamic>>()
            .map(ShipmentModel.fromJson)
            .toList(),
      );
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to load shipments';
      ToastMessageHelper.showErrorMessage(msg);
    } finally {
      isLoading.value = false;
    }
  }

  int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
