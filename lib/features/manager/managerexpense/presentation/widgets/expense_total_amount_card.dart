import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_expense_model.dart';

class ExpenseTotalAmountCard extends StatelessWidget {
  final double amount;
  final ManagerExpenseStatus status;

  const ExpenseTotalAmountCard({
    super.key,
    required this.amount,
    required this.status,
  });

  Color _statusColor() {
    switch (status) {
      case ManagerExpenseStatus.pending:
        return AppColors.warningColor;
      case ManagerExpenseStatus.approved:
        return const Color(0xFF1DB954);
      case ManagerExpenseStatus.rejected:
        return AppColors.redColorFF1D1D;
      default:
        return AppColors.secondaryTextColor;
    }
  }

  String _statusLabel() {
    switch (status) {
      case ManagerExpenseStatus.pending:
        return 'PENDING';
      case ManagerExpenseStatus.approved:
        return 'APPROVED';
      case ManagerExpenseStatus.rejected:
        return 'REJECTED';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2137),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF1A3A5A), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL AMOUNT',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ],
          ),
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: sc.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: sc.withValues(alpha: 0.4)),
            ),
            child: Text(
              _statusLabel(),
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: sc,
              ),
            ),
          ),
        ],
      ),
    );
  }
}