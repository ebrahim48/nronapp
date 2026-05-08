import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/manager_expense_model.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class ExpenseReviewCard extends StatelessWidget {
  final ManagerExpenseModel expense;
  final VoidCallback? onTap;

  const ExpenseReviewCard({
    super.key,
    required this.expense,
    this.onTap,
  });

  Color _statusColor(ManagerExpenseStatus s) {
    switch (s) {
      case ManagerExpenseStatus.pending:  return AppColors.warningColor;
      case ManagerExpenseStatus.approved: return const Color(0xFF1DB954);
      case ManagerExpenseStatus.rejected: return AppColors.redColorFF1D1D;
      default: return AppColors.secondaryTextColor;
    }
  }

  String _statusLabel(ManagerExpenseStatus s) {
    switch (s) {
      case ManagerExpenseStatus.pending:  return 'PENDING';
      case ManagerExpenseStatus.approved: return 'APPROVED';
      case ManagerExpenseStatus.rejected: return 'REJECTED';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar — always show initials
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: _InitialsAvatar(initials: expense.repInitials),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: expense.title.isNotEmpty
                              ? expense.title
                              : expense.repName,
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                          maxline: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: '\$${expense.amount.toStringAsFixed(2)}',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Category tags
                  Row(
                    children: [
                      Text(
                        expense.categoryTag,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                      Text(' • ',
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.secondaryTextColor)),
                      Text(
                        expense.typeTag,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Date + status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              color: AppColors.secondaryTextColor,
                              size: 11.r),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: expense.date,
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: _statusColor(expense.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _statusLabel(expense.status),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: _statusColor(expense.status),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  const _InitialsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      color: const Color(0xFF1A3A5C),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
