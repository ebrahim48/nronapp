import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final RxBool isVisible;
  final VoidCallback onToggle;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hint,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
            color: AppColors.dotButtonInactiveColor, width: 0.8),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible.value,
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Poppins',
          color: AppColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            color: AppColors.secondaryTextColor,
          ),
          prefixIcon: Icon(Icons.key_outlined,
              color: AppColors.secondaryTextColor, size: 18.r),
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(
              isVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.secondaryTextColor,
              size: 18.r,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w, vertical: 14.h),
        ),
      ),
    ));
  }
}