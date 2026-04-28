import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class InventoryModelToggle extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const InventoryModelToggle({
    super.key,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Loaner', 'Consignment'];
    return Row(
      children: labels.asMap().entries.map((e) {
        final isActive = e.key == activeIndex;
        return Padding(
          padding: EdgeInsets.only(right: e.key == 0 ? 8.w : 0),
          child: GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0x1A1AC8DB)
                    : const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryColor
                      : const Color(0x331AC8DB),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Center(
                child: CustomText(
                  text: e.value,
                  fontsize: 13.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.primaryColor
                      : AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TrayStatusSelector extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const TrayStatusSelector({
    super.key,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Down Rack', 'Wrapped', 'Warehouse'];
    return Row(
      children: labels.asMap().entries.map((e) {
        final isActive = e.key == activeIndex;
        return Padding(
          padding: EdgeInsets.only(right: e.key < 2 ? 8.w : 0),
          child: GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0x1A1AC8DB)
                    : const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryColor
                      : const Color(0x331AC8DB),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Center(
                child: CustomText(
                  text: e.value,
                  fontsize: 12.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.primaryColor
                      : AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TrayReturnWarningBanner extends StatelessWidget {
  const TrayReturnWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE6A817).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE6A817).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFE6A817), size: 20),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              text: 'Return in 7 days to avoid late fees.',
              fontsize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
