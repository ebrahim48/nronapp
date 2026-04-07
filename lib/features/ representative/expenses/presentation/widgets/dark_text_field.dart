import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class DarkTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? textController;
  final int maxLines;
  final String? initialValue;
  final void Function(String)? onChanged;

  const DarkTextField({
    super.key,
    required this.label,
    required this.hint,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.textController,
    this.maxLines = 1,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryTextColor,
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: TextFormField(
              controller: textController,
              initialValue: textController == null ? initialValue : null,
              readOnly: readOnly,
              maxLines: maxLines,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                  color: AppColors.secondaryTextColor,
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 14.h),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}