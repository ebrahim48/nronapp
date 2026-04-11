import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/manager_sales_model.dart';

class ManagerSaleController extends GetxController {
  final searchQuery = ''.obs;
  final selectedFilter = ManagerSaleStatus.allSales.obs;
  final billVerification = true.obs;
  final feedbackController = TextEditingController();

  final allSales = <ManagerSaleModel>[
    ManagerSaleModel(
      id: '1',
      facility: 'City Otho Clinic',
      saleTypeLabel: 'Implant',
      surgeon: 'Dr. Robert Chen',
      totalBill: 12450.00,
      status: ManagerSaleStatus.paid,
    ),
    ManagerSaleModel(
      id: '2',
      facility: 'City Otho Clinic',
      saleTypeLabel: 'Biological',
      surgeon: 'Dr. Robert Chen',
      totalBill: 12450.00,
      status: ManagerSaleStatus.pending,
    ),
    ManagerSaleModel(
      id: '3',
      facility: 'City Otho Clinic',
      saleTypeLabel: 'Implant',
      surgeon: 'Dr. Robert Chen',
      totalBill: 12450.00,
      status: ManagerSaleStatus.pending,
    ),
  ].obs;

  List<ManagerSaleModel> get filteredSales {
    List<ManagerSaleModel> result = allSales;
    if (selectedFilter.value != ManagerSaleStatus.allSales) {
      result =
          result.where((s) => s.status == selectedFilter.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where((s) =>
      s.facility.toLowerCase().contains(q) ||
          s.surgeon.toLowerCase().contains(q) ||
          s.saleTypeLabel.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  void onFilterSelected(ManagerSaleStatus status) =>
      selectedFilter.value = status;
  void onSearchChanged(String v) => searchQuery.value = v;

  void toggleBillVerification() => billVerification.toggle();

  void sendFeedback() {
    if (feedbackController.text.trim().isEmpty) return;
    Get.snackbar(
      'Sent',
      'Feedback sent to rep',
      snackPosition: SnackPosition.BOTTOM,
    );
    feedbackController.clear();
  }

  void saveNote(String text) {
    if (text.isEmpty) return;
    Get.snackbar(
      'Note Saved',
      'Your note has been saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void approveCommission() {
    Get.snackbar(
      'Approved',
      'Commission approved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1DB954).withValues(alpha: 0.9),
    );
  }

  final saleDetail = const ManagerSaleDetailModel(
    saleNumber: 'Sale #S-101',
    repName: 'Sarah Johnson',
    transactionStatus: 'Sold',
    saleType: 'Consigned',
    doctor: 'Dr. Sarah Jenkins',
    facility: 'Metropolitan General Hospital',
    procedureDate: '03/12/2026',
    vendor: 'Med-Tech',
    poNumber: '12345',
    totalBill: 14400.00,
    commission: 1152.00,
    commissionPercent: 10,
    inventoryItems: [
      SaleInventoryItem(
          name: 'Tapered Stem - Size 4',
          serial: 'SN: 882918-A',
          tag: 'Consigned'),
      SaleInventoryItem(
          name: 'Acetabular Cup - 52mm',
          serial: 'SN: 771822-B',
          tag: 'Sold'),
    ],
    repSplits: [
      SaleRepSplit(name: 'Marcus Aurelius', splitPercent: 70),
      SaleRepSplit(name: 'Lucius Vorenus', splitPercent: 30),
    ],
    totalCommissionPool: 1420.50,
    attachments: [
      SaleAttachmentItem(
          fileName: 'PO_889_Final.pdf',
          size: '1.2 MB',
          date: 'FEB 15',
          isPdf: true),
      SaleAttachmentItem(
          fileName: 'Implant_Serial_Photo.jpg',
          size: '3.4 MB',
          date: 'FEB 15',
          isPdf: false),
    ],
    billVerificationStatus: true,
    note:
    'Lunch meeting with Dr. Smith to discuss the new pharmaceutical lineup and distribution schedule for the downtown clinic.',
  );

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}