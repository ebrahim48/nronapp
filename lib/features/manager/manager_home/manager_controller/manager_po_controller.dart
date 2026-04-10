import 'package:get/get.dart';

import '../model/manager_po_model.dart';

class ManagerPOController extends GetxController {
  final searchQuery = ''.obs;
  final selectedFilter = ManagerPOStatus.all.obs;

  final allOrders = <ManagerPOModel>[
    ManagerPOModel(
      id: '1',
      date: 'Feb 15, 2026',
      serialNumber: 'SN: XYZ14324',
      doctor: 'Dr. Robert Smith',
      facility: 'City Hospital',
      typeLabel: 'Commission',
      commissionAmount: 630.00,
      totalAmount: 4200.00,
      status: ManagerPOStatus.complete,
    ),
    ManagerPOModel(
      id: '2',
      date: 'Mar 01, 2026',
      serialNumber: 'SN: ABC56789',
      doctor: 'Dr. Emily Johnson',
      facility: 'Greenwood Clinic',
      typeLabel: 'Consultation',
      commissionAmount: 450.00,
      totalAmount: 2250.00,
      status: ManagerPOStatus.open,
    ),
    ManagerPOModel(
      id: '3',
      date: 'Apr 15, 2026',
      serialNumber: 'SN: JKL67890',
      doctor: 'Dr. David Brown',
      facility: 'Sunrise Clinic',
      typeLabel: 'Commission',
      commissionAmount: 350.00,
      totalAmount: 1750.00,
      status: ManagerPOStatus.lost,
    ),
    ManagerPOModel(
      id: '4',
      date: 'Mar 15, 2026',
      serialNumber: 'SN: DEF98765',
      doctor: 'Dr. Michael Lee',
      facility: 'Downtown Medical Center',
      typeLabel: 'Surgery',
      commissionAmount: 1200.00,
      totalAmount: 7200.00,
      status: ManagerPOStatus.complete,
    ),
  ].obs;

  List<ManagerPOModel> get filteredOrders {
    List<ManagerPOModel> result = allOrders;
    if (selectedFilter.value != ManagerPOStatus.all) {
      result =
          result.where((o) => o.status == selectedFilter.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where((o) =>
      o.serialNumber.toLowerCase().contains(q) ||
          o.doctor.toLowerCase().contains(q) ||
          o.facility.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  void onSearchChanged(String v) => searchQuery.value = v;
  void onFilterSelected(ManagerPOStatus s) => selectedFilter.value = s;

  // ── Detail data ───────────────────────────────────────────────────────────
  final poDetail = const ManagerPODetailModel(
    poNumber: 'PO #88234',
    urgencyTag: 'Emergency',
    title: 'Urgent Surgical Supplies',
    patientId: '1002120JSC2254S',
    facility: 'City Hospital',
    facilityEmail: 'example@gmial.com',
    dateOfSurgery: 'Feb 14, 2024',
    surgeryTime: '08:30 AM EST',
    surgeon: 'Dr. Michael Lee',
    surgeonSpecialty: 'Orthopedic Surgery',
    vendor: 'MedTech Inc.',
    vendorEmail: 'example@gmi...',
    totalAmount: 4250.00,
    imageAsset: 'assets/images/review.png',
    products: [
      POProductItem(
          name: 'Bulk Quinoa', spec: '50kg × \$4.50', price: 225.00),
      POProductItem(
          name: 'Flax Seeds', spec: '20kg × \$3.20', price: 64.00),
    ],
    documents: [
      PODocumentItem(
          fileName: 'PO_889_Final.pdf',
          size: '1.2 MB',
          date: 'FEB 15',
          isPdf: true),
      PODocumentItem(
          fileName: 'Implant_Serial_Photo.jpg',
          size: '3.4 MB',
          date: 'FEB 15',
          isPdf: false),
    ],
    timeline: [
      POTimelineItem(
          title: 'Created',
          subtitle: 'Feb 15, 10:30 AM',
          status: POTimelineStatus.done),
      POTimelineItem(
          title: 'Submitted',
          subtitle: 'Feb 15, 10:30 AM',
          status: POTimelineStatus.done),
      POTimelineItem(
          title: 'PAID',
          subtitle: 'Pending',
          status: POTimelineStatus.inProgress),
      POTimelineItem(
          title: 'Commission Paid',
          subtitle: 'Feb 15, 10:30 AM',
          status: POTimelineStatus.pending),
    ],
    repName: 'Sarah Johnson',
    repAvatarAsset: 'assets/images/profile.jpg',
  );
}