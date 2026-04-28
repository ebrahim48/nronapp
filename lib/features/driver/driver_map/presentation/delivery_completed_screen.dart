import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';


class DeliveryCompletedScreen extends StatelessWidget {
  const DeliveryCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90.r,
                height: 90.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF1DB954),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 46.r,
                ),
              ),

              SizedBox(height: 24.h),

              Text(
                'Delivery Completed!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                ),
              ),

              SizedBox(height: 8.h),

              CustomText(
                text: 'Earnings added to your account',
                fontsize: 13.sp,
                color: AppColors.secondaryTextColor,
              ),
            ],
          ),
        ),
      ),

    );
  }
}

