import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_po_model.dart';

class ManagerPOCard extends StatelessWidget {
  final ManagerPOModel order;
  final VoidCallback? onTap;

  const ManagerPOCard({super.key, required this.order, this.onTap});

  Color _statusColor(ManagerPOStatus s) {
    switch (s) {
      case ManagerPOStatus.complete:
        return const Color(0xFF1DB954);
      case ManagerPOStatus.open:
        return AppColors.warningColor;
      case ManagerPOStatus.lost:
        return AppColors.redColorFF1D1D;
      default:
        return AppColors.secondaryTextColor;
    }
  }

  String _statusLabel(ManagerPOStatus s) {
    switch (s) {
      case ManagerPOStatus.complete:
        return 'Complete';
      case ManagerPOStatus.open:
        return 'Open';
      case ManagerPOStatus.lost:
        return 'Lost';
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor(order.status);

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
            // Date + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: order.date,
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: sc.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _statusLabel(order.status),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: sc,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Serial Number
            CustomText(
              text: order.serialNumber,
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 4.h),

            // Doctor • Facility
            Row(
              children: [
                CustomText(
                  text: order.doctor,
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Container(
                    width: 4.r,
                    height: 4.r,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomText(
                    text: order.facility,
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                    maxline: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            Divider(
                color: const Color(0xFF3A3A3A),
                height: 14.h,
                thickness: 0.5),

            // Type + Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: order.typeLabel,
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text:
                      '\$${order.commissionAmount.toStringAsFixed(2)}',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                CustomText(
                  text:
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
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