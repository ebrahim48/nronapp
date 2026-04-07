import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/expense_controller.dart';

class PaidToggle extends StatelessWidget {
  const PaidToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paid',
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => Row(
          children: [
            _ToggleOption(
              label: 'Yes',
              isSelected: controller.isPaid.value,
              onTap: () => controller.isPaid.value = true,
            ),
            SizedBox(width: 10.w),
            _ToggleOption(
              label: 'No',
              isSelected: !controller.isPaid.value,
              onTap: () => controller.isPaid.value = false,
            ),
          ],
        )),
        SizedBox(height: 14.h),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFF3A3A3A),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.blackColor
                : AppColors.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}