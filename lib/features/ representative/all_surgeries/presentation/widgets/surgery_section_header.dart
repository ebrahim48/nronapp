import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';

class SurgerySectionHeader extends StatelessWidget {
  final String title;

  const SurgerySectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
        ),
      ),
    );
  }
}