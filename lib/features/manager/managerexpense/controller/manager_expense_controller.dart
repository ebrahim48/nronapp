import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/manager_expense_model.dart';

class ManagerExpenseController extends GetxController {
  final selectedFilter = ManagerExpenseStatus.all.obs;

  final syncCount = 5.obs;
  final isSyncing = false.obs;

  final allExpenses = <ManagerExpenseModel>[
    ManagerExpenseModel(
      id: '1',
      title: 'Lunch w/ Dr. Smith',
      categoryTag: 'MEDICAL',
      typeTag: 'PHYSICIAN',
      date: 'Oct 24, 2023',
      amount: 124.50,
      status: ManagerExpenseStatus.pending,
      repInitials: 'JT',
      repName: 'James Taylor',
    ),
    ManagerExpenseModel(
      id: '2',
      title: 'Lunch w/ Dr. Smith',
      categoryTag: 'MEDICAL',
      typeTag: 'PHYSICIAN',
      date: 'Oct 24, 2023',
      amount: 124.50,
      status: ManagerExpenseStatus.pending,
      repInitials: 'JT',
      repName: 'James Taylor',
    ),
    ManagerExpenseModel(
      id: '3',
      title: 'Lunch w/ Dr. Smith',
      categoryTag: 'MEDICAL',
      typeTag: 'PHYSICIAN',
      date: 'Oct 24, 2023',
      amount: 124.50,
      status: ManagerExpenseStatus.pending,
      repInitials: 'JT',
      repName: 'James Taylor',
    ),
    ManagerExpenseModel(
      id: '4',
      title: 'Lunch w/ Dr. Smith',
      categoryTag: 'MEDICAL',
      typeTag: 'PHYSICIAN',
      date: 'Oct 24, 2023',
      amount: 124.50,
      status: ManagerExpenseStatus.pending,
      repInitials: 'JT',
      repName: 'James Taylor',
    ),
  ].obs;

  List<ManagerExpenseModel> get filteredExpenses {
    if (selectedFilter.value == ManagerExpenseStatus.all) {
      return allExpenses;
    }
    return allExpenses
        .where((e) => e.status == selectedFilter.value)
        .toList();
  }

  int get totalItems => filteredExpenses.length;

  void onFilterSelected(ManagerExpenseStatus status) {
    selectedFilter.value = status;
  }

  Future<void> syncToQB() async {
    isSyncing.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSyncing.value = false;
    Get.snackbar(
      'Synced',
      '${syncCount.value} items synced to QuickBooks',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ── Detail data ───────────────────────────────────────────────────────────
  final expenseDetail = const ManagerExpenseDetailModel(
    repName: 'Alex Johnson',
    repRole: 'Sales Representative',
    submittedDate: 'Submitted: Oct 12, 2023 • 09:45 AM',
    repAvatarAsset: 'assets/images/profile.jpg',
    totalAmount: 145.20,
    status: ManagerExpenseStatus.pending,
    physicianClient: 'Dr. Smith',
    category: 'Business Meal',
    dateOfExpense: 'Oct 10, 2023',
    paidStatus: 'Corporate Card',
    description:
    'Lunch meeting with Dr. Smith to discuss the new pharmaceutical lineup and distribution schedule for the downtown clinic.',
    attachments: [
      ExpenseDetailAttachment(
        fileName: 'PO_889_Final.pdf',
        size: '1.2 MB',
        date: 'FEB 15',
        isPdf: true,
      ),
      ExpenseDetailAttachment(
        fileName: 'Implant_Serial_Photo.jpg',
        size: '3.4 MB',
        date: 'FEB 15',
        isPdf: false,
      ),
    ],
  );

  // ── Reject form ───────────────────────────────────────────────────────────
  final rejectCommentController = TextEditingController();

  void approveExpense() {
    Get.back(); // close dialog
    Get.snackbar(
      'Approved',
      'Expense approved and synced with QuickBooks',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1DB954).withValues(alpha: 0.9),
    );
  }

  void rejectExpense() {
    Get.back(); // close dialog
    Get.snackbar(
      'Rejected',
      'Expense has been rejected',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFF4444).withValues(alpha: 0.9),
    );
  }

  @override
  void onClose() {
    rejectCommentController.dispose();
    super.onClose();
  }
}