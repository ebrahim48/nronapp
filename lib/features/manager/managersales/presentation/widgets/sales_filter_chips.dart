import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../controller/manager_sales_controller.dart';
import '../../model/manager_sales_model.dart';

class SalesFilterChips extends StatelessWidget {
  const SalesFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerSaleController>();

    final filters = [
      ManagerSaleStatus.allSales,
      ManagerSaleStatus.pending,
      ManagerSaleStatus.paid,
    ];
    final labels = ['All Sales', 'Pending', 'Paid'];

    return Obx(() => Row(
      children: List.generate(filters.length, (i) {
        final isSelected = c.selectedFilter.value == filters[i];
        return GestureDetector(
          onTap: () => c.onFilterSelected(filters[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFF3A3A3A),
              ),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isSelected
                    ? AppColors.blackColor
                    : AppColors.secondaryTextColor,
              ),
            ),
          ),
        );
      }),
    ));
  }
}