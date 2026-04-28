import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class SplitCommissionSection extends StatelessWidget {
  final List<CommissionSplitItem> splits;
  final double totalCommissionPool;
  final bool showProgressBar;
  final bool showAmounts;

  const SplitCommissionSection({
    super.key,
    required this.splits,
    required this.totalCommissionPool,
    this.showProgressBar = false,
    this.showAmounts = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Split Commission',
            fontsize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          ...splits.map((split) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.person_outline, color: AppColors.secondaryTextColor, size: 14.r),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: split.name, fontsize: 12.sp, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                      CustomText(text: '${split.splitPercent}% Split Share', fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                    ],
                  ),
                ),
                if (showAmounts && split.splitAmount != null)
                  CustomText(
                    text: '\$${split.splitAmount!.toStringAsFixed(2)}',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  )
                else
                  CustomText(
                    text: '${split.splitPercent}% Split',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          )),
          if (showProgressBar) ...[
            SizedBox(height: 6.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: 1.0,
                backgroundColor: const Color(0xFF3A3A3A),
                color: AppColors.primaryColor,
                minHeight: 6.h,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'Total Split: 100% of 100%', fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                CustomText(text: 'Subtotal : \$${totalCommissionPool.toStringAsFixed(2)}', fontsize: 10.sp, color: AppColors.primaryColor, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
              ],
            ),
          ] else ...[
            Divider(color: const Color(0xFF3A3A3A), height: 14.h, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'Total Commission Pool', fontsize: 12.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                CustomText(text: '\$${totalCommissionPool.toStringAsFixed(2)}', fontsize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1DB954), textAlign: TextAlign.start),
              ],
            ),
            SizedBox(height: 4.h),
            CustomText(text: 'Auto-calculated based on region tier 2 and product margins.', fontsize: 9.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
          ],
        ],
      ),
    );
  }
}