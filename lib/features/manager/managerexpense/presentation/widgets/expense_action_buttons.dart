import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class ExpenseActionButtons extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onApprove;

  const ExpenseActionButtons({
    super.key,
    required this.onReject,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Reject button
        Expanded(
          child: GestureDetector(
            onTap: onReject,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: AppColors.redColorFF1D1D, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close,
                      color: AppColors.redColorFF1D1D, size: 16.r),
                  SizedBox(width: 6.w),
                  Text(
                    'Reject',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColors.redColorFF1D1D,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Approve button
        Expanded(
          child: GestureDetector(
            onTap: onApprove,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: AppColors.blackColor, size: 16.r),
                  SizedBox(width: 6.w),
                  Text(
                    'Approve',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}