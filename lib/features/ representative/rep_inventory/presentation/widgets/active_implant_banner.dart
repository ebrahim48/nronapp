import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class ActiveImplantBanner extends StatelessWidget {
  final String serialNumber;
  final String implantName;
  final String? imageAsset;

  const ActiveImplantBanner({
    super.key,
    required this.serialNumber,
    required this.implantName,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'ACTIVE IMPLANT',
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warningColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: serialNumber,
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: implantName,
                  fontsize: 12.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: imageAsset != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(imageAsset!, fit: BoxFit.cover),
            )
                : Icon(
              Icons.medical_services_outlined,
              color: AppColors.secondaryTextColor,
              size: 28.r,
            ),
          ),
        ],
      ),
    );
  }
}