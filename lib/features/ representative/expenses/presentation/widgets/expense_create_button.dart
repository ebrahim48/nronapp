import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app-routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';

class ExpenseCreateButton extends StatelessWidget {
  const ExpenseCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.createExpenseScreen),
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A6EFF),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primaryTextColor, size: 18.r),
            SizedBox(width: 6.w),
            Text(
              'Create Expense',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}