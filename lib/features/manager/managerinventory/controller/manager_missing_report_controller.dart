import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/manager_inventory_repository.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class MissingReportItem {
  final String id;
  final String trayId;
  final String facilityName;
  final String issueType;
  final String instrumentName;
  final String user;
  final String email;
  final String profileUrl;
  final String date;

  // Detail fields (populated when detail is loaded)
  final String? trayTitle;
  final String? vendorName;
  final String? vendorEmail;
  final String? vendorPhone;
  final String? vendorProfileUrl;
  final String? descriptionAndNotes;
  final List<String> files;
  final bool isSentToVendor;

  const MissingReportItem({
    required this.id,
    required this.trayId,
    required this.facilityName,
    required this.issueType,
    required this.instrumentName,
    required this.user,
    required this.email,
    required this.profileUrl,
    required this.date,
    this.trayTitle,
    this.vendorName,
    this.vendorEmail,
    this.vendorPhone,
    this.vendorProfileUrl,
    this.descriptionAndNotes,
    this.files = const [],
    this.isSentToVendor = false,
  });

  factory MissingReportItem.fromListJson(Map<String, dynamic> e) {
    return MissingReportItem(
      id: e['id']?.toString() ?? '',
      trayId: e['trayCode']?.toString() ?? '',
      facilityName: e['facilityName']?.toString() ?? '',
      issueType: e['issueType']?.toString() ?? '',
      instrumentName: e['instrumentName']?.toString() ?? '',
      user: e['user']?.toString() ?? '',
      email: e['email']?.toString() ?? '',
      profileUrl: e['profileUrl']?.toString() ?? '',
      date: e['date']?.toString() ?? '',
    );
  }

  factory MissingReportItem.fromDetailJson(Map<String, dynamic> e) {
    final trayMap = e['tray'] is Map ? e['tray'] as Map<String, dynamic> : <String, dynamic>{};
    final createdByMap = e['createdBy'] is Map ? e['createdBy'] as Map<String, dynamic> : <String, dynamic>{};
    final vendorMap = e['vendor'] is Map ? e['vendor'] as Map<String, dynamic> : <String, dynamic>{};
    final filesList = e['files'] is List
        ? (e['files'] as List).map((f) => f.toString()).toList()
        : <String>[];

    return MissingReportItem(
      id: e['_id']?.toString() ?? '',
      trayId: trayMap['title']?.toString() ?? '',
      facilityName: '',
      issueType: e['issueType']?.toString() ?? '',
      instrumentName: e['instrumentName']?.toString() ?? '',
      user: createdByMap['fullName']?.toString() ?? '',
      email: createdByMap['email']?.toString() ?? '',
      profileUrl: createdByMap['profileUrl']?.toString() ?? '',
      date: e['createdAt']?.toString() ?? '',
      trayTitle: trayMap['title']?.toString(),
      vendorName: vendorMap['name']?.toString(),
      vendorEmail: vendorMap['email']?.toString(),
      vendorPhone: vendorMap['phoneNumber']?.toString(),
      vendorProfileUrl: vendorMap['profileUrl']?.toString(),
      descriptionAndNotes: e['descriptionAndNotes']?.toString(),
      files: filesList,
      isSentToVendor: e['isSentToVendor'] as bool? ?? false,
    );
  }
}

// ── Controller ────────────────────────────────────────────────────────────────

class ManagerMissingReportController extends GetxController {
  final _repo = ManagerInventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final isSendingMail = false.obs;
  final searchQuery = ''.obs;
  final total = 0.obs;
  final missing = 0.obs;
  final reports = <MissingReportItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchOverview();
    fetchReports();
  }

  Future<void> _fetchOverview() async {
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getMissingInstrumentOverview(token);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      total.value = (data['total'] as num?)?.toInt() ?? 0;
      missing.value = (data['missing'] as num?)?.toInt() ?? 0;
    } catch (_) {}
  }

  Future<void> fetchReports({String? search}) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getMissingInstrumentReport(token, search: search);
      final results = _asList(res['data']);
      reports.assignAll(
        results.map((e) => MissingReportItem.fromListJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load reports');
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

  List<MissingReportItem> get filtered {
    if (searchQuery.value.isEmpty) return reports;
    final q = searchQuery.value.toLowerCase();
    return reports.where((r) =>
        r.trayId.toLowerCase().contains(q) ||
        r.facilityName.toLowerCase().contains(q)).toList();
  }

  void onSearch(String v) {
    searchQuery.value = v;
    fetchReports(search: v.isNotEmpty ? v : null);
  }

  Future<void> sendVendorMail(String id) async {
    try {
      isSendingMail.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.sendVendorMail(token, id);
      ToastMessageHelper.showSuccessMessage('Report sent to vendor successfully');
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to send vendor mail');
    } finally {
      isSendingMail.value = false;
    }
  }
}
