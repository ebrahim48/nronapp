import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/manager_expense_controller.dart';
import '../../model/manager_expense_model.dart';

class ManagerExpenseFilterTabs extends StatelessWidget {
  const ManagerExpenseFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerExpenseController>();

    final filters = [
      ManagerExpenseStatus.all,
      ManagerExpenseStatus.pending,
      ManagerExpenseStatus.approved,
      ManagerExpenseStatus.rejected,
    ];
    final labels = ['All', 'Pending', 'Approved', 'Rejected'];

    return Obx(() => Row(
      children: List.generate(filters.length, (i) {
        final isSelected = c.selectedFilter.value == filters[i];
        return GestureDetector(
          onTap: () => c.onFilterSelected(filters[i]),
          child: Container(
            margin: EdgeInsets.only(right: 20.w),
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryTextColor
                    : AppColors.secondaryTextColor,
              ),
            ),
          ),
        );
      }),
    ));
  }
}