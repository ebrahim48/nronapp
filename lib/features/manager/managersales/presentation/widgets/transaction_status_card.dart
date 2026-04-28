import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class TransactionStatusCard extends StatelessWidget {
  final String status;

  const TransactionStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Transaction Status',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: status,
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1DB954),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SvgPicture.asset(
            'assets/icons/salecheck.svg',
            width: 28.r,
            height: 28.r,
            colorFilter: const ColorFilter.mode(
              Color(0xFF1DB954),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}