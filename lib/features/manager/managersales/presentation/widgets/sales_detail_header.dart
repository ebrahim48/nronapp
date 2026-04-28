import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SaleDetailHeader extends StatelessWidget {
  final String saleNumber;
  final String repName;
  final VoidCallback onViewLogistic;
  final VoidCallback onAddNote;
  final VoidCallback onApproveCommission;

  const SaleDetailHeader({
    super.key,
    required this.saleNumber,
    required this.repName,
    required this.onViewLogistic,
    required this.onAddNote,
    required this.onApproveCommission,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: saleNumber,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DB954),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    CustomText(
                      text: 'Rep: $repName',
                      fontsize: 12.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
            // Copy icon
            Icon(Icons.copy_outlined,
                color: AppColors.secondaryTextColor, size: 20.r),
          ],
        ),

        SizedBox(height: 12.h),

        // View Logistic + Add Note row
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onViewLogistic,
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: AppColors.primaryColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/viewlogistic.svg',
                        width: 16.r,
                        height: 16.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'View Logistic',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: onAddNote,
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2200),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: AppColors.warningColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/addnote.svg',
                        width: 16.r,
                        height: 16.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.warningColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Add Note',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        // Approve Commission button
        GestureDetector(
          onTap: onApproveCommission,
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/salecheck.svg',
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blackColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Approve Commission',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}