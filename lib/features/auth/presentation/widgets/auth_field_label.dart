import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/core/utils/app_colors.dart';

class AuthFieldLabel extends StatelessWidget {
  final String label;

  const AuthFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryTextColor,
        ),
      ),
    );
  }
}
