import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_sales_model.dart';

class SaleRepSplitSection extends StatelessWidget {
  final List<SaleRepSplit> splits;
  final double totalCommissionPool;

  const SaleRepSplitSection({
    super.key,
    required this.splits,
    required this.totalCommissionPool,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Representative Split',
          fontsize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
          ),
          child: Column(
            children: [
              ...splits.map((split) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Icon(Icons.person_outline,
                        color: AppColors.secondaryTextColor,
                        size: 16.r),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: split.name,
                        fontsize: 13.sp,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    CustomText(
                      text: '${split.splitPercent}% Split',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              )),
              Divider(
                  color: const Color(0xFF3A3A3A),
                  height: 1,
                  thickness: 0.5),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Total Commission Pool',
                    fontsize: 12.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text:
                    '\$${totalCommissionPool.toStringAsFixed(2)}',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              CustomText(
                text:
                'Auto-calculated based on region tier 2 and product margins.',
                fontsize: 10.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}