import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class ExpenseDescriptionBox extends StatelessWidget {
  final String description;

  const ExpenseDescriptionBox({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 13.sp,
          fontFamily: 'Poppins',
          color: AppColors.secondaryTextColor,
          height: 1.6,
        ),
      ),
    );
  }
}