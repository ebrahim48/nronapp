import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class NavigateButton extends StatelessWidget {
  final VoidCallback onTap;

  const NavigateButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.navigation_outlined,
                color: AppColors.blackColor, size: 18.r),
            SizedBox(width: 8.w),
            Text(
              'Navigate',
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}