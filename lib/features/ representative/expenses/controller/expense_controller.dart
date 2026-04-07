import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/expense_model.dart';

class ExpenseController extends GetxController {
  final searchQuery = ''.obs;
  final selectedFilter = ExpenseStatus.all.obs;

  final TextEditingController representativeNameController = TextEditingController(text: 'Alex Johnson');
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController expenseDateController = TextEditingController();
  final RxString selectedPhysician = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedYear = '2026'.obs;
  final RxString selectedMonth = 'MARCH'.obs;
  final RxBool isPaid = true.obs;
  final uploadedFiles = <File>[].obs;
  final isPickingFile = false.obs;

  final years = ['2024', '2025', '2026', '2027'];
  final months = [
    'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL',
    'MAY', 'JUNE', 'JULY', 'AUGUST',
    'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
  ];
  final physicians = ['Dr. Smith', 'Dr. Robert', 'Dr. Alex', 'Dr. Sarah'];
  final categories = ['Business Meal', 'Travel', 'Medical Supply', 'Office'];

  final allExpenses = <ExpenseModel>[
    ExpenseModel(
      id: '1',
      title: 'Renewal Fee',
      doctor: 'Dr. Sarah',
      date: 'June 15, 2024',
      amount: 150.00,
      status: ExpenseStatus.approved,
      physicianClient: 'Dr. Smith',
      category: 'Business Meal',
      dateOfExpense: 'Oct 10, 2023',
      paidStatus: 'Corporate Card',
      description:
      'Lunch meeting with Dr. Smith to discuss the new pharmaceutical lineup and distribution schedule for the downtown clinic.',
      attachments: [
        ExpenseAttachment(
          fileName: 'PO_889_Final.pdf',
          size: '1.2 MB',
          date: 'FEB 15',
          isPdf: true,
        ),
        ExpenseAttachment(
          fileName: 'Implant_Serial_Photo.jpg',
          size: '3.4 MB',
          date: 'FEB 15',
          isPdf: false,
        ),
      ],
    ),
    ExpenseModel(
      id: '2',
      title: 'Late Fee',
      doctor: 'Dr. Alex',
      date: 'August 10, 2024',
      amount: 50.00,
      status: ExpenseStatus.rejected,
      physicianClient: 'Dr. Alex',
      category: 'Travel',
      dateOfExpense: 'Aug 10, 2024',
      paidStatus: 'Personal Card',
      description: 'Late fee for overdue invoice.',
      attachments: [],
    ),
    ExpenseModel(
      id: '3',
      title: 'Renewal Fee',
      doctor: 'Dr. Sarah',
      date: 'June 15, 2024',
      amount: 150.00,
      status: ExpenseStatus.approved,
      physicianClient: 'Dr. Smith',
      category: 'Business Meal',
      dateOfExpense: 'Oct 10, 2023',
      paidStatus: 'Corporate Card',
      description: 'Renewal fee for annual subscription.',
      attachments: [],
    ),
    ExpenseModel(
      id: '4',
      title: 'Late Fee',
      doctor: 'Dr. Alex',
      date: 'August 10, 2024',
      amount: 50.00,
      status: ExpenseStatus.rejected,
      physicianClient: 'Dr. Alex',
      category: 'Travel',
      dateOfExpense: 'Aug 10, 2024',
      paidStatus: 'Personal Card',
      description: 'Late fee for overdue invoice.',
      attachments: [],
    ),
  ].obs;

  List<ExpenseModel> get filteredExpenses {
    List<ExpenseModel> result = allExpenses;

    if (selectedFilter.value != ExpenseStatus.all) {
      result =
          result.where((e) => e.status == selectedFilter.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where((e) =>
      e.title.toLowerCase().contains(q) ||
          e.doctor.toLowerCase().contains(q))
          .toList();
    }

    return result;
  }

  void onSearchChanged(String value) => searchQuery.value = value;
  void onFilterSelected(ExpenseStatus status) =>
      selectedFilter.value = status;

  void submitExpense() {
    // Submit logic here
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark(),
        child: child!,
      ),
    );
    if (picked != null) {
      expenseDateController.text =
      '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> attachFile() async {
    try {
      isPickingFile.value = true;

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'gif'],
        allowMultiple: true,
        withData: false,
      );

      if (result != null && result.files.isNotEmpty) {
        for (final file in result.files) {
          if (file.path != null) {
            uploadedFiles.add(File(file.path!));
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    } finally {
      isPickingFile.value = false;
    }
  }

  void removeFile(int index) {
    uploadedFiles.removeAt(index);
  }

  @override
  void onClose() {
    representativeNameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    expenseDateController.dispose();
    super.onClose();
  }
}