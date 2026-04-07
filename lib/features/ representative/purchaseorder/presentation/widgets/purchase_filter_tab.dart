import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/purchase_order_controller.dart';
import '../../model/purchase_order_model.dart';


class PoFilterTabs extends StatelessWidget {
  const PoFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PurchaseOrderController>();

    final filters = [
      POStatus.all,
      POStatus.open,
      POStatus.lost,
      POStatus.complete,
    ];

    final labels = ['All', 'Open', 'Lost', 'Complete'];

    return Obx(() => Row(
      children: List.generate(filters.length, (index) {
        final isSelected = controller.selectedFilter.value == filters[index];
        return GestureDetector(
          onTap: () => controller.onFilterSelected(filters[index]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFF3A3A3A),
              ),
            ),
            child: Text(
              labels[index],
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
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