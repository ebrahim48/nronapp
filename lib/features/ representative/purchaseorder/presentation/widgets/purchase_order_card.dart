import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/purchase_order_model.dart';


class PoCard extends StatelessWidget {
  final PurchaseOrderModel order;

  const PoCard({super.key, required this.order});

  Color _statusBgColor(POStatus status) {
    switch (status) {
      case POStatus.complete:
        return AppColors.successColor;
      case POStatus.sent:
        return const Color(0xFF3A3A8A);
      case POStatus.open:
        return AppColors.warningColor.withOpacity(0.85);
      case POStatus.lost:
        return AppColors.redColorFF1D1D.withOpacity(0.8);
      default:
        return Colors.grey.withOpacity(0.4);
    }
  }

  String _statusLabel(POStatus status) {
    switch (status) {
      case POStatus.complete:
        return 'Complete';
      case POStatus.sent:
        return 'Sent';
      case POStatus.open:
        return 'Open';
      case POStatus.lost:
        return 'Lost';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date + Status Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: order.date,
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
              ),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _statusBgColor(order.status),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  _statusLabel(order.status),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          // PO Number
          CustomText(
            text: order.poNumber,
            fontsize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 4.h),

          // Surgeon • Facility
          Row(
            children: [
              CustomText(
                text: order.surgeon,
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Container(
                  width: 5.r,
                  height: 5.r,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              CustomText(
                text: order.facility,
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(color: const Color(0xFF3A3A3A), height: 1.h),

          SizedBox(height: 10.h),

          // Total Amount Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'TOTAL AMOUNT',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text:
                '\$${order.totalAmount.toStringAsFixed(2)}',
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}