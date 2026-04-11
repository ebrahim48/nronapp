import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_sales_model.dart';

class ManagerSaleCard extends StatelessWidget {
  final ManagerSaleModel sale;
  final VoidCallback? onTap;

  const ManagerSaleCard({super.key, required this.sale, this.onTap});

  Color _statusBg(ManagerSaleStatus s) {
    switch (s) {
      case ManagerSaleStatus.paid:
        return const Color(0xFF006500);
      case ManagerSaleStatus.pending:
        return const Color(0xFFFFB516);
      default:
        return AppColors.primaryColor;
    }
  }

  Color _statusTextColor(ManagerSaleStatus s) {
    switch (s) {
      case ManagerSaleStatus.paid:
        return AppColors.primaryTextColor;
      case ManagerSaleStatus.pending:
        return AppColors.primaryTextColor;
      default:
        return AppColors.blackColor;
    }
  }

  String _statusLabel(ManagerSaleStatus s) {
    switch (s) {
      case ManagerSaleStatus.paid:
        return 'Paid';
      case ManagerSaleStatus.pending:
        return 'Pending';
      default:
        return 'All';
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
          color: const Color(0xFF1E2121),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: _statusBg(sale.status),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _statusLabel(sale.status),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: _statusTextColor(sale.status),
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
                color: const Color(0xFF3A3A3A),
                height: 14.h,
                thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Surgeon',
                      fontsize: 10.sp,
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
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text:
                      '\$${sale.totalBill.toStringAsFixed(2)}',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
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