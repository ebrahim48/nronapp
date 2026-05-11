import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/approve_dialog.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/expense-attachment_tile.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/reject-dialog.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_expense_controller.dart';
import '../model/manager_expense_model.dart';
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
      body: Obx(() {
        // ── Shimmer while loading ──────────────────────────────────────
        if (c.isLoadingDetail.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                children: [
                  // Rep card shimmer
                  Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Amount card shimmer
                  Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Table shimmer
                  Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Description shimmer
                  Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final d = c.expenseDetail.value;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 14.h),
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
                      ExpenseDetailRow(
                          'Physician / Client',
                          d.physicianClient.isNotEmpty
                              ? d.physicianClient
                              : '—'),
                      ExpenseDetailRow('Category',
                          d.category.isNotEmpty ? d.category : '—'),
                      ExpenseDetailRow('Date of Expense',
                          d.dateOfExpense.isNotEmpty
                              ? d.dateOfExpense
                              : '—'),
                      ExpenseDetailRow('Paid Status',
                          d.paidStatus.isNotEmpty ? d.paidStatus : '—'),
                    ]),

                    SizedBox(height: 20.h),

                    // Description section
                    CustomText(
                      text: 'Description',
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),

                    SizedBox(height: 10.h),

                    ExpenseDescriptionBox(
                        description: d.description.isNotEmpty
                            ? d.description
                            : 'No description provided.'),

                    SizedBox(height: 20.h),

                    // Attachments section
                    if (d.attachments.isNotEmpty) ...[
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
                    ],

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // Bottom action buttons — only shown for pending expenses
            Obx(() {
              final status = c.expenseDetail.value.status;
              final isPending = status == ManagerExpenseStatus.pending;
              final isUpdating = c.isUpdatingStatus.value;

              if (!isPending) return const SizedBox.shrink();

              return Container(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2427),
                  border: Border(
                    top: BorderSide(
                        color: const Color(0xFF3A3A3A), width: 0.5),
                  ),
                ),
                child: isUpdating
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : ExpenseActionButtons(
                        onReject: () => RejectDialog.show(
                          context,
                          onSubmit: () => c.rejectExpense(context),
                        ),
                        onApprove: () => ApproveDialog.show(
                          context,
                          onConfirm: () => c.approveExpense(context),
                        ),
                      ),
              );
            }),
          ],
        );
      }),
    );
  }
}
