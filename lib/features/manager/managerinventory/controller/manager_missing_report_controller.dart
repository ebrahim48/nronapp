import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';

class MissingReportItem {
  final String id;
  final String trayId;
  final String status;
  final String facility;
  final String reporter;
  final String date;
  final String reporterImage;

  const MissingReportItem({
    required this.id,
    required this.trayId,
    required this.status,
    required this.facility,
    required this.reporter,
    required this.date,
    required this.reporterImage,
  });
}

class ManagerMissingReportController extends GetxController {
  final searchQuery = ''.obs;
  final total = 124.obs;
  final missing = 42.obs;

  final reports = <MissingReportItem>[
    MissingReportItem(id: '1', trayId: 'TR-102', status: 'Missing',  facility: 'City Hospital', reporter: 'Sarah', date: 'Feb 20, 2026', reporterImage: 'assets/images/profile.jpg'),
    MissingReportItem(id: '2', trayId: 'TR-102', status: 'Damaged',  facility: 'City Hospital', reporter: 'Sarah', date: 'Feb 20, 2026', reporterImage: 'assets/images/profile.jpg'),
  ].obs;

  List<MissingReportItem> get filtered {
    if (searchQuery.value.isEmpty) return reports;
    return reports.where((r) =>
    r.trayId.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        r.facility.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  void onSearch(String v) => searchQuery.value = v;
  void openFilter() {}
  void openReport(MissingReportItem item) =>
      Get.context!.push(AppRoutes.managerReportDetailsScreen, extra: item);
}