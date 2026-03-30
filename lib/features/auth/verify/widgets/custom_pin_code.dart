import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/constants/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;

  const CustomPinCodeTextField({super.key, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.primaryTextColor,
      controller: textEditingController,
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
        // inactive (empty, not focused)
        inactiveFillColor: const Color(0xFF1E2121),
        inactiveColor: AppColors.dotButtonInactiveColor,
        // selected (focused)
        selectedFillColor: const Color(0xFF1E2121),
        selectedColor: AppColors.primaryColor,
        // active (filled)
        activeFillColor: const Color(0xFF1E2121),
        activeColor: AppColors.dotButtonInactiveColor,
        borderWidth: 1,
      ),
      enableActiveFill: true,
      obscureText: false,
      keyboardType: TextInputType.number,
      onChanged: (value) {},
      onCompleted: (value) {
        textEditingController?.text = value;
      },
    );
  }
}
