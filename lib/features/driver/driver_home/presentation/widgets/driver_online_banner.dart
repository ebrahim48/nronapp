import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/driver_home_controller.dart';

class DriverOnlineBanner extends StatelessWidget {
  const DriverOnlineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverHomeController>();

    return Obx(() {
      final online = c.isOnline.value;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: online
                ? AppColors.primaryColor.withValues(alpha: 0.3)
                : const Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: online ? AppColors.primaryColor : const Color(0xFF5A5A5A),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: online ? "You're Online" : "You're Offline",
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: online ? 'Ready to accept jobs' : 'Not accepting job',
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: c.toggleOnlineStatus,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: online ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: online
                        ? AppColors.primaryColor
                        : const Color(0xFF5A5A5A),
                  ),
                ),
                child: Text(
                  online ? 'Go Offline' : 'Go Online',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: online
                        ? AppColors.blackColor
                        : AppColors.primaryTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}