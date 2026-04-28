import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/approve_dialog.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/expense-attachment_tile.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/reject-dialog.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_expense_controller.dart';
import 'widgets/expense_rep_card.dart';
import 'widgets/expense_total_amount_card.dart';
import 'widgets/expense_detail_table.dart';
import 'widgets/expense_description_box.dart';
import 'widgets/expense_action_buttons.dart';

class ManagerExpenseDetailScreen extends StatelessWidget {
  const ManagerExpenseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerExpenseController>();
    final d = c.expenseDetail;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Expense Details',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rep card
                  ExpenseRepCard(detail: d),

                  SizedBox(height: 12.h),

                  // Total amount card
                  ExpenseTotalAmountCard(
                      amount: d.totalAmount, status: d.status),

                  SizedBox(height: 20.h),

                  // Expense Details section
                  CustomText(
                    text: 'Expense Details',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 10.h),

                  ExpenseDetailTable(rows: [
                    ExpenseDetailRow('Physician / Client', d.physicianClient),
                    ExpenseDetailRow('Category', d.category),
                    ExpenseDetailRow('Date of Expense', d.dateOfExpense),
                    ExpenseDetailRow('Paid Status', d.paidStatus),
                  ]),

                  SizedBox(height: 20.h),

                  // Description section
                  CustomText(
                    text: 'Expense Details',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 10.h),

                  ExpenseDescriptionBox(description: d.description),

                  SizedBox(height: 20.h),

                  // Attachments section
                  CustomText(
                    text: 'Attachments',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 10.h),

                  ...d.attachments.map(
                        (att) => ExpenseAttachmentTile(attachment: att),
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2427),
              border: Border(
                top: BorderSide(
                    color: const Color(0xFF3A3A3A), width: 0.5),
              ),
            ),
            child: ExpenseActionButtons(
              onReject: () => RejectDialog.show(
                context,
                onSubmit: c.rejectExpense,
              ),
              onApprove: () => ApproveDialog.show(
                context,
                onConfirm: c.approveExpense,
              ),
            ),
          ),
        ],
      ),
    );
  }
}