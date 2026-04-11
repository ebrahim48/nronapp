import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class CloseBillsTable extends StatelessWidget {
  final List<CommissionBillItem> bills;

  const CloseBillsTable({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Icon(Icons.receipt_long_outlined, color: AppColors.redColorFF1D1D, size: 14.r),
                SizedBox(width: 6.w),
                CustomText(
                  text: 'Close Bills (${bills.length})',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(child: CustomText(text: 'Bill ID', fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start)),
                SizedBox(width: 70.w, child: CustomText(text: 'Amount', fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start)),
                SizedBox(width: 50.w, child: CustomText(text: 'Status', fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.end)),
              ],
            ),
          ),
          ...bills.map((bill) => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: bill.billId, fontsize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                          CustomText(text: bill.date, fontsize: 9.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 70.w,
                      child: CustomText(text: '\$${bill.amount.toStringAsFixed(2)}', fontsize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: CustomText(text: bill.status, fontsize: 11.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1DB954), textAlign: TextAlign.end),
                    ),
                  ],
                ),
              ),
              if (bill != bills.last)
                Divider(height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
            ],
          )),
        ],
      ),
    );
  }
}