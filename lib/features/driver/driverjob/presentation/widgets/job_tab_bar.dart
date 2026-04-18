import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/driver_job_controller.dart';
import '../../model/driver_job_model.dart';

class JobsTabBar extends StatelessWidget {
  const JobsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverJobController>();

    final tabs = [
      DriverJobTab.newJobs,
      DriverJobTab.active,
      DriverJobTab.completed,
    ];
    final labels = ['New', 'Active', 'Completed'];

    return Obx(() => Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = c.selectedTab.value == tabs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => c.onTabSelected(tabs[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
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
            ),
          );
        }),
      ),
    ));
  }
}