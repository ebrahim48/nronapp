import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_sales_model.dart';

class SaleInventoryList extends StatelessWidget {
  final List<SaleInventoryItem> items;

  const SaleInventoryList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Inventory Item List',
          fontsize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
          ),
          child: Column(
            children: [
              ...items.map((item) {
                final isLast = item == items.last;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: item.name,
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                              CustomText(
                                text: item.serial,
                                fontsize: 10.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                  color: const Color(0xFF3A3A3A)),
                            ),
                            child: CustomText(
                              text: item.tag,
                              fontsize: 11.sp,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                          height: 1,
                          color: const Color(0xFF3A3A3A),
                          thickness: 0.5),
                  ],
                );
              }),
              Divider(
                  height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: CustomText(
                  text: 'View All 12 Items',
                  fontsize: 13.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}