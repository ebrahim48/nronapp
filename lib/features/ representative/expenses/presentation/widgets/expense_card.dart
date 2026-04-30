import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback? onTap;

  const ExpenseCard({super.key, required this.expense, this.onTap});

  Color _statusColor(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.approved:
        return const Color(0xFF1DB954);
      case ExpenseStatus.rejected:
        return const Color(0xFFFF6B6B);
      case ExpenseStatus.pending:
        return AppColors.warningColor;
      default:
        return Colors.grey;
    }
  }

  Widget _receiptIcon() => Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.receipt_long,
            color: AppColors.secondaryTextColor, size: 22.r),
      );

  String _statusLabel(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.approved:
        return 'Approved';
      case ExpenseStatus.rejected:
        return 'Rejected';
      case ExpenseStatus.pending:
        return 'Pending';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: expense.title,
                        fontsize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        text:
                        '\$${expense.amount.toStringAsFixed(2)}',
                        fontsize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Doctor • Date
                  CustomText(
                    text: '${expense.doctor} • ${expense.date}',
                    fontsize: 12.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 8.h),

                  // Status Badge
                  if (expense.status != ExpenseStatus.all)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: _statusColor(expense.status)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: _statusColor(expense.status)
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        _statusLabel(expense.status),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: _statusColor(expense.status),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 10.w),

            // Thumbnail
            if (expense.thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  expense.thumbnailUrl!,
                  width: 48.r,
                  height: 48.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _receiptIcon(),
                ),
              )
            else
              _receiptIcon(),
          ],
        ),
      ),
    );
  }
}