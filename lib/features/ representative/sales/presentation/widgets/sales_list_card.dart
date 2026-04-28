import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/sales_model.dart';

class SaleListCard extends StatelessWidget {
  final SaleModel sale;
  final VoidCallback? onTap;

  const SaleListCard({super.key, required this.sale, this.onTap});

  Color _statusColor(SaleStatus s) {
    switch (s) {
      case SaleStatus.approved:
        return const Color(0xFF1DB954);
      case SaleStatus.pending:
        return AppColors.warningColor;
      case SaleStatus.rejected:
        return AppColors.redColorFF1D1D;
    }
  }

  String _statusLabel(SaleStatus s) {
    switch (s) {
      case SaleStatus.approved:
        return 'Approved';
      case SaleStatus.pending:
        return 'Pending';
      case SaleStatus.rejected:
        return 'Rejected';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: sale.facility,
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _statusColor(sale.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _statusLabel(sale.status),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: _statusColor(sale.status),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            CustomText(
              text: sale.saleTypeLabel,
              fontsize: 12.sp,
              color: AppColors.primaryColor,
              textAlign: TextAlign.start,
            ),
            Divider(
                color: const Color(0xFF3A3A3A), height: 16.h, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Surgeon',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: sale.surgeon,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: 'Total Bill',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text:
                      '\$${sale.totalBill.toStringAsFixed(2)}',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}