import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/rep_home_controller.dart';

class RepStatGrid extends StatelessWidget {
  const RepStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RepHomeController>();

    return Obx(() {
      if (c.isLoading.value) return const _StatGridShimmer();

      return Column(
        children: [
          Row(
            children: [
              _StatCard(
                iconPath: 'assets/icons/totalsales.svg',
                iconColor: AppColors.primaryColor,
                label: 'Total Sales',
                value: c.totalSales.value.toString(),
              ),
              SizedBox(width: 12.w),
              _StatCard(
                iconPath: 'assets/icons/activepos.svg',
                iconColor: const Color(0xFF08AF40),
                label: 'Active POs',
                value: c.activePOs.value.toString(),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _StatCard(
                iconPath: 'assets/icons/expense.svg',
                iconColor: AppColors.primaryColor,
                label: 'Total Inventory',
                value: c.totalInventory.value.toString(),
              ),
              SizedBox(width: 12.w),
              _StatCard(
                iconPath: 'assets/icons/expenses.svg',
                iconColor: const Color(0xFFEC0101),
                label: 'Expenses',
                value: c.expenses.value.toString(),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _StatGridShimmer extends StatelessWidget {
  const _StatGridShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ShimmerCard()),
              SizedBox(width: 12.w),
              Expanded(child: _ShimmerCard()),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _ShimmerCard()),
              SizedBox(width: 12.w),
              Expanded(child: _ShimmerCard()),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 32.r,
              height: 32.r,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            SizedBox(height: 12.h),
            CustomText(
              text: label,
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
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
