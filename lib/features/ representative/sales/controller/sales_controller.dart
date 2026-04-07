import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/sales_model.dart';

class SaleController extends GetxController {
  final implantSales = 4.obs;
  final bioSales = 4.obs;
  final totalRevenue = 4.obs;
  final commission = 4.obs;

  final recentSales = <SaleModel>[
    SaleModel(
      id: '1',
      saleNumber: 'SL-90210',
      facility: 'City Otho Clinic',
      saleTypeLabel: 'Implant',
      surgeon: 'Dr. Robert Chen',
      totalBill: 12450.00,
      status: SaleStatus.approved,
    ),
    SaleModel(
      id: '2',
      saleNumber: 'SL-90211',
      facility: 'City Otho Clinic',
      saleTypeLabel: 'Biological',
      surgeon: 'Dr. Robert Chen',
      totalBill: 12450.00,
      status: SaleStatus.pending,
    ),
    SaleModel(
      id: '3',
      saleNumber: 'SL-90212',
      facility: 'City Otho Clinic',
      saleTypeLabel: 'Implant',
      surgeon: 'Dr. Robert Chen',
      totalBill: 12450.00,
      status: SaleStatus.pending,
    ),
  ].obs;

  final saleDetail = const SaleDetailModel(
    saleNumber: 'Sale #SL-90210',
    saleType: 'Consigned',
    physician: 'Dr. Sarah Jenkins',
    facility: 'Metropolitan General Hospital',
    procedureDate: '03/12/2026',
    serialNumbers: 'SN-002\nSN-001',
    vendor: 'Med-Tech',
    ppoNumber: '12345',
    inventoryItems: [
      InventoryItemModel(name: 'Tapered Stem - Size 4', serial: 'SN: 882918-A', tag: 'Implant'),
      InventoryItemModel(name: 'Acetabular Cup - 52mm', serial: 'SN: 771822-B', tag: 'Trays'),
    ],
    classification: 'Mixed (Sold/Consigned)',
    repSplits: [
      RepSplitModel(name: 'Marcus Aurelius', splitPercent: 70),
      RepSplitModel(name: 'Lucius Vorenus', splitPercent: 30),
    ],
    totalCommission: 1420.50,
    attachments: [
      AttachmentFileModel(fileName: 'PO_889_Final.pdf', size: '1.2 MB', date: 'FEB 15', isPdf: true),
      AttachmentFileModel(fileName: 'Implant_Serial_Photo.jpg', size: '3.4 MB', date: 'FEB 15', isPdf: false),
    ],
    note: 'Highly preferred for complex spinal fusions. Efficient with surgical time and maintains excellent patient outcomes. Follows up personally within 24 hours post-op.',
    auditTrail: [
      AuditTrailModel(title: 'Commission Calculated', subtitle: 'System automated process', dateTime: 'Oct 24, 2023 • 10:15 AM', type: AuditType.success),
      AuditTrailModel(title: 'Packing Slip Uploaded', subtitle: 'By David Miller', dateTime: 'Oct 24, 2023 • 09:45 AM', type: AuditType.info),
      AuditTrailModel(title: 'Sale Record Created', subtitle: 'By System Import', dateTime: 'Oct 23, 2023 • 04:30 PM', type: AuditType.warning),
    ],
  );

  // ── Create Sale form ─────────────────────────────────────────────────────
  final selectedSaleType = SaleType.sold.obs;
  final selectedPhysician = ''.obs;
  final selectedFacility = ''.obs;
  final procedureDate = ''.obs;
  final vendorController = TextEditingController();
  final poNumberController = TextEditingController();
  final totalBillController = TextEditingController();
  final vendorPaymentController = TextEditingController();
  final additionalNotesController = TextEditingController();
  final generatePackingSlip = true.obs;

  final physicians = ['Dr. Jane Smith', 'Dr. Sarah Jenkins', 'Dr. Robert Chen'];
  final facilities = ['City Hospital', 'Metropolitan General Hospital', 'Advanced Care Clinic'];

  final addedRepresentatives = <RepresentativeModel>[
    RepresentativeModel(name: 'Jordan Dixon', role: 'Primary', commissionPercent: 10),
    RepresentativeModel(name: 'Asd Dixon', role: 'Assist', commissionPercent: 30),
  ].obs;

  final selectedImplants = <ImplantItem>[].obs;

  final uploadedAttachments = <AttachmentFileModel>[
    AttachmentFileModel(fileName: 'Doctor_Sheet_v4_Signed.pdf', size: '2.4 MB', date: 'OCT 24, 2023', isPdf: true),
    AttachmentFileModel(fileName: 'Surgical_Report_Jenkins.pdf', size: '1.1 MB', date: '', isPdf: true),
    AttachmentFileModel(fileName: 'Facility_Auth_Letter.docx', size: '842 KB', date: '', isPdf: false),
  ].obs;

  // ── Implants list ────────────────────────────────────────────────────────
  final implantSearchQuery = ''.obs;

  final allImplants = <ImplantItem>[
    ImplantItem(name: 'Shoulder Implant', serial: '#SNO456', material: 'Polyethylene', location: 'Advanced Care Clinic', availability: ImplantAvailability.available, isSelected: true),
    ImplantItem(name: 'Knee Replacement', serial: '#KNR789', material: 'Titanium Alloy', location: 'Ortho Solutions Center', availability: ImplantAvailability.inStock),
    ImplantItem(name: 'Hip Prosthesis', serial: '#HPP321', material: 'Ceramic Composite', location: 'Joint Health Institute', availability: ImplantAvailability.backordered, isSelected: true),
    ImplantItem(name: 'Elbow Joint Fixator', serial: '#EJF654', material: 'Stainless Steel', location: 'Precision Orthopedics', availability: ImplantAvailability.available),
  ].obs;

  List<ImplantItem> get filteredImplants {
    if (implantSearchQuery.value.isEmpty) return allImplants;
    final q = implantSearchQuery.value.toLowerCase();
    return allImplants.where((i) =>
    i.name.toLowerCase().contains(q) ||
        i.serial.toLowerCase().contains(q)).toList();
  }

  int get selectedImplantCount =>
      allImplants.where((i) => i.isSelected).length;

  void toggleImplant(int index) {
    allImplants[index].isSelected = !allImplants[index].isSelected;
    allImplants.refresh();
  }

  void confirmSelectedImplants() {
    selectedImplants.assignAll(allImplants.where((i) => i.isSelected));
  }

  void removeRepresentative(int index) {
    addedRepresentatives.removeAt(index);
  }

  void addRepresentative(RepresentativeModel rep) {
    addedRepresentatives.add(rep);
  }

  int get totalCommissionPercent =>
      addedRepresentatives.fold(0, (sum, r) => sum + r.commissionPercent);

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(data: ThemeData.dark(), child: child!),
    );
    if (picked != null) {
      procedureDate.value =
      '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  // ── Packing slip ─────────────────────────────────────────────────────────
  final packingSlipItems = const <PackingSlipItem>[
    PackingSlipItem(product: 'Neural Link Hub V2', serial: 'NL-882-991-A', qty: 1, price: 1250.00),
    PackingSlipItem(product: 'Titanium Mounting Kit', serial: 'TM-KIT-002', qty: 2, price: 45.00),
    PackingSlipItem(product: 'Fiber Optic Cable (5m)', serial: 'FO-5M-X9', qty: 5, price: 12.50),
  ];

  double get packingSlipSubtotal =>
      packingSlipItems.fold(0, (s, i) => s + i.price);

  @override
  void onClose() {
    vendorController.dispose();
    poNumberController.dispose();
    totalBillController.dispose();
    vendorPaymentController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}