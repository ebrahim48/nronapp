import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class BillVerificationToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onToggle;

  const BillVerificationToggle({
    super.key,
    required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.warningColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/billverification.svg',
            width: 22.r,
            height: 22.r,
            colorFilter: const ColorFilter.mode(
              AppColors.warningColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Bill Verification Status',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text:
                  'Verify all items and totals match hospital records',
                  fontsize: 10.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: value
                    ? const Color(0xFFEC5B13)
                    : const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(3.r),
                  width: 22.r,
                  height: 22.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}