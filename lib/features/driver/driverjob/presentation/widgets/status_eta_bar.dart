import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class StatusEtaBar extends StatelessWidget {
  final String status;
  final String eta;

  const StatusEtaBar({super.key, required this.status, required this.eta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Poppins',
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: status,
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'ETA',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Poppins',
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: eta,
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}