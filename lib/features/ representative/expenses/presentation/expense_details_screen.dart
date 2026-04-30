import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/helpers/pdf_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/expense_controller.dart';
import '../domain/model/expense_model.dart';
import 'create_expense_screen.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final String expenseId;

  const ExpenseDetailScreen({super.key, required this.expenseId});

  Color _statusColor(ExpenseStatus s) {
    switch (s) {
      case ExpenseStatus.approved:
        return const Color(0xFF1DB954);
      case ExpenseStatus.rejected:
        return AppColors.redColorFF1D1D;
      default:
        return AppColors.warningColor;
    }
  }

  String _statusLabel(ExpenseStatus s) {
    switch (s) {
      case ExpenseStatus.approved:
        return 'Approved';
      case ExpenseStatus.rejected:
        return 'Rejected';
      default:
        return 'Pending Approval';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseController>();

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
        centerTitle: false,
        title: CustomText(
          text: 'Expense Details',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return _ExpenseDetailShimmer();
        }

        final expense = controller.detailObs.value;
        if (expense == null) {
          return Center(
            child: CustomText(
              text: 'Failed to load expense',
              fontsize: 14.sp,
              color: AppColors.secondaryTextColor,
            ),
          );
        }

        final statusColor = _statusColor(expense.status);

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          _statusLabel(expense.status),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Submitted on ${expense.date}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () {
                        controller.prefillForEdit(expense);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateExpenseScreen(
                                expenseId: expense.id),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          'Edit Details',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                'Expense Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),

              SizedBox(height: 10.h),

              _DetailTable(
                rows: [
                  _DetailRow('Representative',
                      (expense as ExpenseDetailModel).representativeName.isNotEmpty
                          ? expense.representativeName
                          : '-'),
                  _DetailRow('Category', expense.category ?? '-'),
                  _DetailRow('Date of Expense', expense.dateOfExpense ?? '-'),
                  _DetailRow('Paid Status',
                      expense.isPaid == true ? 'Paid' : 'Unpaid'),
                ],
              ),

              SizedBox(height: 20.h),

              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),

              SizedBox(height: 10.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Text(
                  expense.description ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.secondaryTextColor,
                    height: 1.6,
                  ),
                ),
              ),

              if (expense.attachments.isNotEmpty) ...[
                SizedBox(height: 20.h),
                Text(
                  'Attachments',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 10.h),
                ...expense.attachments
                    .map((att) => _AttachmentTile(attachment: att)),
              ],

              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);
}

class _DetailTable extends StatelessWidget {
  final List<_DetailRow> rows;
  const _DetailTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final isLast = i == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 13.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rows[i].label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    Text(
                      rows[i].value,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: const Color(0xFF3A3A3A)),
            ],
          );
        }),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final ExpenseAttachment attachment;
  const _AttachmentTile({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (attachment.url != null && attachment.url!.isNotEmpty) {
          PdfHelper.downloadAndShare(attachment.url!);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: attachment.isPdf
                    ? const Color(0xFFFF4444).withValues(alpha: 0.15)
                    : const Color(0xFF1A6EFF).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                attachment.isPdf
                    ? Icons.picture_as_pdf_outlined
                    : Icons.image_outlined,
                color: attachment.isPdf
                    ? const Color(0xFFFF4444)
                    : const Color(0xFF1A6EFF),
                size: 18.r,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                attachment.fileName,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.download_outlined,
              color: AppColors.primaryColor,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Box(width: double.infinity, height: 100.h, radius: 12.r),
            SizedBox(height: 20.h),
            _Box(width: 140.w, height: 18.h, radius: 4.r),
            SizedBox(height: 10.h),
            _Box(width: double.infinity, height: 160.h, radius: 10.r),
            SizedBox(height: 20.h),
            _Box(width: 120.w, height: 18.h, radius: 4.r),
            SizedBox(height: 10.h),
            _Box(width: double.infinity, height: 100.h, radius: 10.r),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _Box(
      {required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
