import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../controller/commission_controller.dart';
import '../../model/commission_model.dart';

class CommissionHistoryFilterTabs extends StatelessWidget {
  const CommissionHistoryFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CommissionController>();

    final filters = <CommissionStatus?>[
      null,
      CommissionStatus.pending,
      CommissionStatus.approved,
      CommissionStatus.paid,
    ];
    final labels = ['All', 'Pending', 'Approved', 'Paid'];

    return Obx(() => Row(
      children: List.generate(filters.length, (i) {
        final isSelected = c.historyFilter.value == filters[i];
        return GestureDetector(
          onTap: () => c.setHistoryFilter(filters[i]),
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
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
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