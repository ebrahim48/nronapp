import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/commission_model.dart';

class CommissionCard extends StatelessWidget {
  final CommissionModel commission;
  final VoidCallback? onTap;

  const CommissionCard({super.key, required this.commission, this.onTap});

  Color _statusColor(CommissionStatus s) {
    switch (s) {
      case CommissionStatus.pending:
        return AppColors.warningColor;
      case CommissionStatus.paid:
        return const Color(0xFF1DB954);
      case CommissionStatus.overdue:
        return AppColors.redColorFF1D1D;
      case CommissionStatus.approved:
        return const Color(0xFF1DB954);
    }
  }

  String _statusLabel(CommissionStatus s) {
    switch (s) {
      case CommissionStatus.pending:
        return 'PENDING';
      case CommissionStatus.paid:
        return 'PAID';
      case CommissionStatus.overdue:
        return 'OVERDUE';
      case CommissionStatus.approved:
        return 'Approveed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(commission.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: AppColors.redColorFF1D1D.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: AppColors.redColorFF1D1D,
                size: 20.r,
              ),
            ),

            SizedBox(width: 10.w),

            // Sale ID + Facility
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: commission.saleId,
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(width: 8.w),
                      // Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                              color: statusColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          _statusLabel(commission.status),
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: commission.facility,
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),

            // Amount + Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: '\$${commission.amount.toStringAsFixed(2)}',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: commission.dateLabel,
                  fontsize: 10.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}