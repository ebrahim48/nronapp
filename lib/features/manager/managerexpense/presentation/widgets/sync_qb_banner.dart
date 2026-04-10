import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/manager_expense_controller.dart';

class SyncToQBBanner extends StatelessWidget {
  const SyncToQBBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerExpenseController>();

    return Obx(() => GestureDetector(
      onTap: c.isSyncing.value ? null : c.syncToQB,
      child: Container(
        width: double.infinity,
        padding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Bank/sync icon
            SvgPicture.asset(
              'assets/icons/sync1.svg',
              width: 28.r,
              height: 28.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryTextColor,
                BlendMode.srcIn,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sync ${c.syncCount.value} items to QB',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  Text(
                    'READY FOR ACCOUNTING',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor
                          .withValues(alpha: 0.7),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            // Sync icon right
            c.isSyncing.value
                ? SizedBox(
              width: 20.r,
              height: 20.r,
              child: const CircularProgressIndicator(
                color: AppColors.primaryTextColor,
                strokeWidth: 2,
              ),
            )
                : SvgPicture.asset(
              'assets/icons/sync2.svg',
              width: 24.r,
              height: 24.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryTextColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}