import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../controller/purchase_order_controller.dart';
import '../../model/purchase_order_model.dart';

class PoFilterTabs extends StatelessWidget {
  const PoFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PurchaseOrderController>();

    const filters = [
      POStatus.all,
      POStatus.open,
      POStatus.lost,
      POStatus.complete,
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
          children: List.generate(filters.length, (index) {
            final isSelected =
                controller.selectedFilter.value == filters[index];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.onFilterSelected(filters[index]),
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
                    labels[index],
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
