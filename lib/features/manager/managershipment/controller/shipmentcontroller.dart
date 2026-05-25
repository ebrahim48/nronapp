import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_shipment_repository.dart';
import '../model/shipment_model.dart';
import '../presentation/manager_track_shipment_screen.dart';

class ShipmentController extends GetxController {
  final _repo = ManagerShipmentRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Stats ─────────────────────────────────────────────────────────────────
  final isLoadingStats = true.obs;
  final pendingJobs = 0.obs;
  final drivers = 0.obs;
  final inTransit = 0.obs;
  final delivered = 0.obs;

  // ── Active shipments (from stats endpoint) ────────────────────────────────
  final activeShipments = <ShipmentModel>[].obs;

  // ── All shipments list ────────────────────────────────────────────────────
  final isLoadingList = true.obs;
  final allShipments = <ShipmentModel>[].obs;

  // ── Detail ────────────────────────────────────────────────────────────────
  final isLoadingDetail = false.obs;
  final selectedShipment = Rxn<ShipmentModel>();

  // ── Error ─────────────────────────────────────────────────────────────────
  final errorMessage = ''.obs;

  // ── Tracking search ───────────────────────────────────────────────────────
  final TextEditingController trackingTextController = TextEditingController();
  final isTrackingLoading = false.obs;
  final hasTrackingResult = false.obs;
  final trackedNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchStats();
    fetchAll();
  }

  @override
  void onClose() {
    trackingTextController.dispose();
    super.onClose();
  }

  // ── Fetch stats + active shipments ────────────────────────────────────────

  Future<void> _fetchStats() async {
    try {
      isLoadingStats.value = true;
      errorMessage.value = '';
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getStats(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};

      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      pendingJobs.value = (stats['pendingJobs'] as num?)?.toInt() ?? 0;
      inTransit.value = (stats['inTransit'] as num?)?.toInt() ?? 0;
      delivered.value = (stats['delivered'] as num?)?.toInt() ?? 0;

      final active = data['activeShipments'] as List? ?? [];
      activeShipments.assignAll(
        active
            .whereType<Map<String, dynamic>>()
            .map(ShipmentModel.fromJson)
            .toList(),
      );
      drivers.value = activeShipments
          .where((s) => s.driverName.isNotEmpty)
          .length;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingStats.value = false;
    }
  }


  Future<void> fetchAll({String? status}) async {
    try {
      isLoadingList.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getAll(token, status: status);
      final results = _asList(res['data']);
      allShipments.assignAll(
        results
            .whereType<Map<String, dynamic>>()
            .map(ShipmentModel.fromJson)
            .toList(),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load shipments');
    } finally {
      isLoadingList.value = false;
    }
  }


  Future<void> fetchDetail(String id) async {
    try {
      isLoadingDetail.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        selectedShipment.value = ShipmentModel.fromJson(data);
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load shipment details');
    } finally {
      isLoadingDetail.value = false;
    }
  }



  void assignDriver() {
    ToastMessageHelper.showSuccessMessage('Driver assignment screen');
  }

  void callDriver() {
    ToastMessageHelper.showSuccessMessage('Calling assigned driver...');
  }

  void sendCourierOrder() {
    ToastMessageHelper.showSuccessMessage('Courier order sent successfully');
  }

  void closeJob() {
    ToastMessageHelper.showSuccessMessage('Job has been closed');
  }

  void trackShipment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ManagerTrackShipmentScreen(),
      ),
    );
  }


  void searchTracking() {
    final query = trackingTextController.text.trim();
    if (query.isEmpty) return;
    isTrackingLoading.value = true;
    hasTrackingResult.value = false;
    Future.delayed(const Duration(milliseconds: 600), () {
      trackedNumber.value = query;
      isTrackingLoading.value = false;
      hasTrackingResult.value = true;
    });
  }


  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['results', 'items', 'list', 'data', 'docs']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }
}
