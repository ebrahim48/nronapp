import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const CustomPinCodeTextField({
    super.key,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.primaryTextColor,
      textStyle: TextStyle(
        color: AppColors.primaryTextColor,
        fontSize: 18.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      autoFocus: false,
      appContext: context,
      length: 6,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8.r),
        fieldHeight: 55.h,
        fieldWidth: 43.w,
        inactiveFillColor: const Color(0xFF1E2121),
        inactiveColor: AppColors.dotButtonInactiveColor,
        selectedFillColor: const Color(0xFF1E2121),
        selectedColor: AppColors.primaryColor,
        activeFillColor: const Color(0xFF1E2121),
        activeColor: AppColors.dotButtonInactiveColor,
        borderWidth: 1,
      ),
      enableActiveFill: true,
      obscureText: false,
      keyboardType: TextInputType.number,
      onChanged: (value) => onChanged?.call(value),
      onCompleted: (value) => onCompleted?.call(value),
    );
  }
}
