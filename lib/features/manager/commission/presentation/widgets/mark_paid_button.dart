import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class MarkPaidButton extends StatelessWidget {
  final VoidCallback onTap;

  const MarkPaidButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: const Color(0xFFEC5B13), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wallet_outlined, color: const Color(0xFFEC5B13), size: 18.r),
            SizedBox(width: 8.w),
            Text(
              'Mark Paid',
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEC5B13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}