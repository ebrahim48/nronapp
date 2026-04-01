import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class PoScannedItemCard extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final String serialNo;
  final String price;

  const PoScannedItemCard({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.serialNo,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 108.h,
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
      child: Row(
        children: [
          // Product image — 80x80, borderRadius 12
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              width: 80.r,
              height: 80.r,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12.w),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Item name + SCANNED badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: itemName,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    // SCANNED badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3A3A),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                            color: AppColors.primaryColor, width: 0.5),
                      ),
                      child: CustomText(
                        text: 'SCANNED',
                        fontsize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Serial number
                CustomText(
                  text: serialNo,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 4.h),

                // Price in teal
                CustomText(
                  text: price,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}