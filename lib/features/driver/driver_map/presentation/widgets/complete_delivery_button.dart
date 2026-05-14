import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';

class CompleteDeliveryButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const CompleteDeliveryButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1DB954),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 18.r),
                  SizedBox(width: 8.w),
                  Text(
                    'Complete Delivery',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
