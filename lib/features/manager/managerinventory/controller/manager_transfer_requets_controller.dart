import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_inventory_repository.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class TransferRequestItem {
  final String id;
  final String serialNumber;
  final String systemType;
  final String from;
  final String to;
  final String reason;
  final String status;
  final String date;
  final String facilityName;

  const TransferRequestItem({
    required this.id,
    required this.serialNumber,
    required this.systemType,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
    required this.date,
    required this.facilityName,
  });

  factory TransferRequestItem.fromJson(Map<String, dynamic> e) {
    final implantMap = e['implant'] is Map
        ? e['implant'] as Map<String, dynamic>
        : <String, dynamic>{};
    final facilityMap = implantMap['facility'] is Map
        ? implantMap['facility'] as Map<String, dynamic>
        : <String, dynamic>{};

    return TransferRequestItem(
      id: e['_id']?.toString() ?? '',
      serialNumber: implantMap['serialNumber']?.toString() ?? '',
      systemType: implantMap['systemType']?.toString() ?? '',
      from: e['from']?.toString() ?? '',
      to: e['to']?.toString() ?? '',
      reason: e['reason']?.toString() ?? '',
      status: e['status']?.toString() ?? 'pending',
      date: e['createdAt']?.toString() ?? '',
      facilityName: facilityMap['facilityName']?.toString() ??
          facilityMap['name']?.toString() ?? '',
    );
  }
}

// ── Controller ────────────────────────────────────────────────────────────────

class ManagerTransferRequestsController extends GetxController {
  final _repo = ManagerInventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final filters = ['All', 'Pending', 'Approved', 'Rejected'];
  final selectedFilter = 'All'.obs;
  final isLoading = true.obs;
  final requests = <TransferRequestItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getTransferRequests(
        token,
        status: selectedFilter.value == 'All' ? null : selectedFilter.value,
      );
      final results = _asList(res['data']);
      requests.assignAll(
        results.map((e) => TransferRequestItem.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load transfer requests');
    } finally {
      isLoading.value = false;
    }
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

  List<TransferRequestItem> get filtered {
    if (selectedFilter.value == 'All') return requests;
    return requests
        .where((r) =>
            r.status.toLowerCase() == selectedFilter.value.toLowerCase())
        .toList();
  }

  void selectFilter(String f) {
    selectedFilter.value = f;
    fetchRequests();
  }

  void approve(String id) {
    ToastMessageHelper.showSuccessMessage('Approved');
    requests.removeWhere((r) => r.id == id);
  }

  void reject(String id) {
    ToastMessageHelper.showSuccessMessage('Rejected');
    requests.removeWhere((r) => r.id == id);
  }
}
