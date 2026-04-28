import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../manager_controller/manager_po_controller.dart';
import '../../model/manager_po_model.dart';

class ManagerPOFilterTabs extends StatelessWidget {
  const ManagerPOFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerPOController>();

    final filters = [
      ManagerPOStatus.all,
      ManagerPOStatus.complete,
      ManagerPOStatus.open,
      ManagerPOStatus.lost,
    ];
    final labels = ['All', 'Complete', 'Open', 'Lost'];

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