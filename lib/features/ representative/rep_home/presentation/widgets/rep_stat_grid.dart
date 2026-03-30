import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/rep_home_controller.dart';

class RepStatGrid extends StatelessWidget {
  const RepStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RepHomeController>();

    return Obx(() => Column(
      children: [
        Row(
          children: [
            _StatCard(
              iconPath: 'assets/icons/totalsales.svg',
              iconColor: AppColors.primaryColor,
              label: 'Total  Sales',
              value: c.totalSales.value,
            ),
            SizedBox(width: 12.w),
            _StatCard(
              iconPath: 'assets/icons/activepos.svg',
              iconColor: const Color(0xFF08AF40),
              label: 'Active POs',
              value: c.activePOs.value,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _StatCard(
              iconPath: 'assets/icons/expense.svg',
              iconColor: AppColors.primaryColor,
              label: 'Achievement',
              value: c.achievement.value,
            ),
            SizedBox(width: 12.w),
            _StatCard(
              iconPath: 'assets/icons/expenses.svg',
              iconColor: const Color(0xFFEC0101),
              label: 'Expenses',
              value: c.expenses.value,
            ),
          ],
        ),
      ],
    ));
  }
}

class _StatCard extends StatelessWidget {
  final String iconPath;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.iconPath,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 130.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A25292A),
              blurRadius: 1,
              offset: Offset(0.5, 1),
            ),
          ],
        ),
        // ── CENTER everything ──────────────────────────────────────────
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            SvgPicture.asset(
              iconPath,
              width: 32.r,
              height: 32.r,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),

            SizedBox(height: 12.h),

            // Label
            CustomText(
              text: label,
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Value
            CustomText(
              text: value,
              fontsize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}