import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';

class HistoryGroupHeader extends StatelessWidget {
  final String label;

  const HistoryGroupHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 4.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
        ),
      ),
    );
  }
}