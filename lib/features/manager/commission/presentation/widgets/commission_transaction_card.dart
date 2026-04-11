import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class CommissionTransactionCard extends StatelessWidget {
  final double totalCommissionDue;
  final double saleAmount;
  final double rate;
  final String date;
  final CommissionPaymentStatus status;

  const CommissionTransactionCard({
    super.key,
    required this.totalCommissionDue,
    required this.saleAmount,
    required this.rate,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1A2A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF1A3A5A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Total Commission Due',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.redColorFF1D1D.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.redColorFF1D1D.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(width: 6.r, height: 6.r, decoration: const BoxDecoration(color: AppColors.redColorFF1D1D, shape: BoxShape.circle)),
                    SizedBox(width: 4.w),
                    Text(
                      status == CommissionPaymentStatus.paid ? 'PAID' : 'UNPAID',
                      style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: AppColors.redColorFF1D1D),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            '\$${totalCommissionDue.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 28.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: AppColors.primaryColor),
          ),
          SizedBox(height: 10.h),
          Divider(height: 1, color: const Color(0xFF1A3A5A), thickness: 0.5),
          SizedBox(height: 10.h),
          Row(
            children: [
              _MiniStat(label: 'Sale Amount', value: '\$${saleAmount.toStringAsFixed(2)}'),
              SizedBox(width: 20.w),
              _MiniStat(label: 'Rate', value: '${rate.toStringAsFixed(2)}%', valueColor: AppColors.primaryColor),
              SizedBox(width: 20.w),
              _MiniStat(label: 'Date', value: date),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MiniStat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', color: AppColors.secondaryTextColor)),
        SizedBox(height: 2.h),
        Text(value, style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: valueColor ?? AppColors.primaryTextColor)),
      ],
    );
  }
}