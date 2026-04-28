import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class PaymentInfoNote extends StatelessWidget {
  const PaymentInfoNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2427),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: AppColors.warningColor,
            size: 16.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Payment Info',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text:
                  'Earnings will be automatically transferred to your default payment method every week. You can also request instant payouts anytime.',
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  textHeight: 1.55,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}