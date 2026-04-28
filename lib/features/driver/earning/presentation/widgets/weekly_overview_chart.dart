import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/earning_model.dart';


class WeeklyOverviewChart extends StatelessWidget {
  final List<WeeklyBarModel> bars;
  final VoidCallback? onExport;

  const WeeklyOverviewChart({
    super.key,
    required this.bars,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Weekly Overview',
                fontsize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              GestureDetector(
                onTap: onExport,
                child: Row(
                  children: [
                    CustomText(
                      text: 'Export',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.download_outlined,
                        color: AppColors.primaryColor, size: 14.r),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Bars
          SizedBox(
            height: 80.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: bars.map((b) => _Bar(bar: b)).toList(),
            ),
          ),
          SizedBox(height: 8.h),

          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: bars
                .map(
                  (b) => SizedBox(
                width: 32.w,
                child: CustomText(
                  text: b.day,
                  fontsize: 10.sp,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final WeeklyBarModel bar;
  const _Bar({required this.bar});

  @override
  Widget build(BuildContext context) {
    const maxBarHeight = 68.0;
    final barH = maxBarHeight * bar.value;

    return SizedBox(
      width: 32.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            width: 18.w,
            height: barH.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}