import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/driver_job_controller.dart';
import '../../model/driver_job_model.dart';

class CompletedPeriodFilter extends StatelessWidget {
  const CompletedPeriodFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverJobController>();

    final periods = [
      CompletedPeriod.today,
      CompletedPeriod.thisWeek,
      CompletedPeriod.thisMonth,
    ];
    final labels = ['Today', 'This Week', 'This Month'];

    return Obx(() => Row(
      children: List.generate(periods.length, (i) {
        final isSelected = c.selectedPeriod.value == periods[i];
        return GestureDetector(
          onTap: () => c.onPeriodSelected(periods[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(
                horizontal: 14.w, vertical: 8.h),
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
                    ? FontWeight.w700
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