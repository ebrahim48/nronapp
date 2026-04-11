import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class ShipmentMapWidget extends StatelessWidget {
  final String status;

  const ShipmentMapWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        children: [
          // Map image
          Image.asset(
            'assets/images/map.png',
            width: double.infinity,
            height: 180.h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: double.infinity,
              height: 180.h,
              color: const Color(0xFF1A2A3A),
              child: Center(
                child: Icon(Icons.map_outlined,
                    color: AppColors.primaryColor, size: 40.r),
              ),
            ),
          ),

          // Status overlay badge (center)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),

          // Location pin
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.location_pin,
                color: AppColors.redColorFF1D1D,
                size: 30.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}