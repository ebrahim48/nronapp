import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/custom_widgets/custom_button.dart';

class PendingApprovalCard extends StatelessWidget {
  final int poCount;
  final int expenseCount;
  final VoidCallback onReviewNow;

  const PendingApprovalCard({
    super.key,
    required this.poCount,
    required this.expenseCount,
    required this.onReviewNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: AppColors.primaryColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Pending Approvals',
            fontsize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: '$poCount POs and $expenseCount Expenses require review',
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: 140.w,
            child: CustomButton(
              title: 'Review Now',
              onpress: onReviewNow,
              height: 38.h,
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              suffixIcon: Icon(Icons.arrow_forward,
                  color: AppColors.blackColor, size: 14.r),
            ),
          ),
        ],
      ),
    );
  }
}