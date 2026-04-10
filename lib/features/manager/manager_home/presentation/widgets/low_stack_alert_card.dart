import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/custom_widgets/custom_button.dart';

class LowStockAlertCard extends StatelessWidget {
  final int itemCount;
  final VoidCallback onViewInventory;

  const LowStockAlertCard({
    super.key,
    required this.itemCount,
    required this.onViewInventory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: AppColors.warningColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Low Stock Alerts',
            fontsize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: '$itemCount items are below 25% stock',
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: 150.w,
            child: CustomButton(
              title: 'View Inventory',
              onpress: onViewInventory,
              height: 38.h,
              color: Colors.transparent,
              borderColor: AppColors.warningColor,
              titlecolor: AppColors.warningColor,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}