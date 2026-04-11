import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/manager_commission_model.dart';

class ManagerCommissionController extends GetxController {
  final stats = <ManagerCommissionStat>[
    ManagerCommissionStat(
        label: 'Total Sales',
        value: '\$00',
        valueColor: Colors.white),
    ManagerCommissionStat(
        label: 'Total Commission',
        value: '\$00',
        valueColor: Colors.white),
    ManagerCommissionStat(
        label: 'Pending Payment',
        value: '\$20',
        valueColor: const Color(0xFFFFB516)),
    ManagerCommissionStat(
        label: 'Paid Commission',
        value: '\$00',
        valueColor: Colors.white),
  ];

  final trendPoints = <TrendDataPoint>[
    TrendDataPoint(month: 'Jan', value: 0),
    TrendDataPoint(month: 'Feb', value: 10),
    TrendDataPoint(month: 'Mar', value: 5),
    TrendDataPoint(month: 'Apr', value: 20),
    TrendDataPoint(month: 'May', value: 8),
    TrendDataPoint(month: 'Jun', value: 15),
    TrendDataPoint(month: 'Jul', value: 3),
  ].obs;

  final listSearchQuery = ''.obs;
  final selectedBillStatus = CommissionBillStatus.all.obs;
  final selectedPaymentStatus = CommissionPaymentStatus.all.obs;
  final selectedTerritory = ''.obs;

  final territories = [
    'Northeast', 'Southeast', 'West', 'Midwest', 'Southwest', 'Pacific'
  ];

  final repSearchQuery = ''.obs;
  final selectedReps = <String>[].obs;

  final allListItems = <CommissionListItem>[
    CommissionListItem(saleId: 'S-1023', repName: 'Jordan Smith', repInitials: 'JS', area: 'Northwest Region', billStatus: CommissionBillStatus.closed),
    CommissionListItem(saleId: 'S-1023', repName: 'Jordan Smith', repInitials: 'JS', area: 'Northwest Region', billStatus: CommissionBillStatus.open),
    CommissionListItem(saleId: 'S-1024', repName: 'Emma Martinez', repInitials: 'EM', area: 'Southwest Region', billStatus: CommissionBillStatus.closed),
    CommissionListItem(saleId: 'S-1028', repName: 'Maya Clark', repInitials: 'MC', area: 'Northwest Region', billStatus: CommissionBillStatus.open),
    CommissionListItem(saleId: 'S-1025', repName: 'Ryan Taylor', repInitials: 'RT', area: 'Northeast Region', billStatus: CommissionBillStatus.closed),
    CommissionListItem(saleId: 'S-1026', repName: 'Alicia Lee', repInitials: 'AL', area: 'Southeast Region', billStatus: CommissionBillStatus.open),
    CommissionListItem(saleId: 'S-1027', repName: 'Brandon Wong', repInitials: 'BW', area: 'Midwest Region', billStatus: CommissionBillStatus.closed),
    CommissionListItem(saleId: 'S-1028', repName: 'Maya Clark', repInitials: 'MC', area: 'Northwest Region', billStatus: CommissionBillStatus.open),
    CommissionListItem(saleId: 'S-1027', repName: 'Brandon Wong', repInitials: 'BW', area: 'Midwest Region', billStatus: CommissionBillStatus.closed),
    CommissionListItem(saleId: 'S-1028', repName: 'Maya Clark', repInitials: 'MC', area: 'Northwest Region', billStatus: CommissionBillStatus.open),
    CommissionListItem(saleId: 'S-1028', repName: 'Maya Clark', repInitials: 'MC', area: 'Northwest Region', billStatus: CommissionBillStatus.open),
    CommissionListItem(saleId: 'S-1027', repName: 'Brandon Wong', repInitials: 'BW', area: 'Midwest Region', billStatus: CommissionBillStatus.closed),
    CommissionListItem(saleId: 'S-1029', repName: 'David Dunn', repInitials: 'DD', area: 'Southwest Region', billStatus: CommissionBillStatus.open),
  ].obs;

  List<CommissionListItem> get filteredItems => allListItems;

  int get totalEntries => allListItems.length;

  void downloadCSV() {
    Get.snackbar('Downloaded', 'CSV file downloaded successfully', snackPosition: SnackPosition.BOTTOM);
  }

  void applyFilters() => Get.back();
  void resetFilters() {
    selectedBillStatus.value = CommissionBillStatus.all;
    selectedPaymentStatus.value = CommissionPaymentStatus.all;
    selectedTerritory.value = '';
    repSearchQuery.value = '';
    selectedReps.clear();
  }

  void toggleTerritory(String t) {
    selectedTerritory.value = selectedTerritory.value == t ? '' : t;
  }

  // ── Commission detail ─────────────────────────────────────────────────────
  final commissionDetail = const CommissionDetailModel(
    repName: 'Sarah Johnson',
    repRole: 'Senior Sales Representative',
    repAvatarAsset: 'assets/images/profile.jpg',
    paymentStatus: CommissionPaymentStatus.unpaid,
    totalCommissionDue: 420.00,
    saleAmount: 4200.00,
    rate: 10.0,
    date: 'Oct 24,2023',
    saleId: '#S1024',
    facility: 'City Hospital',
    territory: 'Northwest Region',
    bills: [
      CommissionBillItem(billId: '#INV-2356', date: 'Oct 12,2026', amount: 2400.00, status: 'PAID'),
      CommissionBillItem(billId: '#INV-2356', date: 'Oct 12,2026', amount: 2400.00, status: 'PAID'),
    ],
    splits: [
      CommissionSplitItem(name: 'Marcus Aurelius', splitPercent: 70),
      CommissionSplitItem(name: 'Lucius Vorenus', splitPercent: 30),
    ],
    totalCommissionPool: 1420.50,
  );

  // Detail variant with calculated commission (Image 9)
  final commissionDetailCalc = const CommissionDetailModel(
    repName: 'Sarah Johnson',
    repRole: 'Senior Sales Representative',
    repAvatarAsset: 'assets/images/profile.jpg',
    paymentStatus: CommissionPaymentStatus.unpaid,
    totalCommissionDue: 420.00,
    saleAmount: 4200.00,
    rate: 10.0,
    date: 'Oct 24,2023',
    saleId: '#S1024',
    facility: 'City Hospital',
    territory: 'Northwest Region',
    bills: [],
    splits: [
      CommissionSplitItem(name: 'Sarah Johnson (Primary)', splitPercent: 70, splitAmount: 294.00, role: 'Primary'),
      CommissionSplitItem(name: 'Sarah Johnson (Assist)', splitPercent: 30, splitAmount: 126.00, role: 'Assist'),
    ],
    totalCommissionPool: 420.00,
  );

  // ── Transaction detail ────────────────────────────────────────────────────
  final transactionDetail = const TransactionDetailModel(
    amount: 420.00,
    isPaid: true,
    date: 'Oct 24, 2023',
    transactionId: 'TX-992834',
    invoiceLink: '#INV-2023-1024',
    expenseLink: '#EXP-4402',
    paymentMethod: 'Bank Transfer (Chase Bank ....4321)',
    payoutSchedule: 'Standard Net-30',
    relatedSaleId: '#S1024',
    surgeon: 'Dr. Lee',
    facility: 'City Hospital',
  );

  // ── Commission Management ─────────────────────────────────────────────────
  final avgCommission = 9.2.obs;
  final totalReps = 12.obs;
  final newRateController = TextEditingController();

  final repRates = <CommissionRepRate>[
    CommissionRepRate(name: 'Sarah Johnson', role: 'Senior Rep', avatarAsset: 'assets/images/profile.jpg', updatedDate: 'Feb 15', currentRate: 10.0),
    CommissionRepRate(name: 'Sarah Johnson', role: 'Senior Rep', avatarAsset: 'assets/images/profile.jpg', updatedDate: 'Feb 15', currentRate: 10.0),
    CommissionRepRate(name: 'Sarah Johnson', role: 'Senior Rep', avatarAsset: 'assets/images/profile.jpg', updatedDate: 'Feb 15', currentRate: 10.0),
    CommissionRepRate(name: 'Sarah Johnson', role: 'Senior Rep', avatarAsset: 'assets/images/profile.jpg', updatedDate: 'Feb 15', currentRate: 10.0),
  ].obs;

  void updateRate(int index) {
    Get.snackbar('Updated', 'Commission rate updated', snackPosition: SnackPosition.BOTTOM);
  }

  void markPaid() {
    Get.snackbar('Marked Paid', 'Commission marked as paid', snackPosition: SnackPosition.BOTTOM);
  }

  void viewTransaction(BuildContext context) {
    // Navigate to transaction detail
  }

  @override
  void onClose() {
    newRateController.dispose();
    super.onClose();
  }
}