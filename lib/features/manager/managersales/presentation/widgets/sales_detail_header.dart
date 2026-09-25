import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SaleDetailHeader extends StatelessWidget {
  final String saleNumber;
  final String repName;
  final VoidCallback onAddNote;
  final VoidCallback onApproveCommission;
  final bool isApproving;

  const SaleDetailHeader({
    super.key,
    required this.saleNumber,
    required this.repName,
    required this.onAddNote,
    required this.onApproveCommission,
    this.isApproving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
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
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                if (saleNumber.isEmpty) return;
                await Clipboard.setData(ClipboardData(text: saleNumber));
                ToastMessageHelper.showToastMessage('Sale ID copied');
              },
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  Icons.copy_outlined,
                  color: AppColors.secondaryTextColor,
                  size: 20.r,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Add Note button (full width)
        GestureDetector(
          onTap: onAddNote,
          child: Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2200),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.warningColor.withValues(alpha: 0.4),
              ),
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

        SizedBox(height: 10.h),

        // Approve Commission button
        GestureDetector(
          onTap: isApproving ? null : onApproveCommission,
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color:
                  isApproving
                      ? AppColors.primaryColor.withValues(alpha: 0.5)
                      : AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child:
                isApproving
                    ? Center(
                      child: SizedBox(
                        width: 22.r,
                        height: 22.r,
                        child: CircularProgressIndicator(
                          color: AppColors.blackColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    )
                    : Row(
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
