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

    const filters = [
      ManagerPOStatus.all,
      ManagerPOStatus.open,
      ManagerPOStatus.lost,
      ManagerPOStatus.complete,
    ];
    const labels = ['All', 'Open', 'Lost', 'Complete'];

    return Obx(
      () => Container(
        height: 44.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2427),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(filters.length, (i) {
            final isSelected = c.selectedFilter.value == filters[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => c.onFilterSelected(filters[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1B1B1B)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.secondaryTextColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
