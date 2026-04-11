import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class CalculatedCommissionCard extends StatelessWidget {
  final double amount;
  final bool isPaid;
  final VoidCallback onViewTransaction;

  const CalculatedCommissionCard({
    super.key,
    required this.amount,
    required this.isPaid,
    required this.onViewTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          CustomText(
            text: 'Calculated Commission',
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
          ),
          SizedBox(height: 6.h),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: AppColors.secondaryTextColor, size: 12.r),
              SizedBox(width: 4.w),
              CustomText(
                text: 'Based on standard territory agreement',
                fontsize: 10.sp,
                color: AppColors.secondaryTextColor,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (isPaid) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF003A00),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, color: const Color(0xFF1DB954), size: 14.r),
                  SizedBox(width: 4.w),
                  Text('Paid', style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: const Color(0xFF1DB954))),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: onViewTransaction,
              child: Container(
                width: double.infinity,
                height: 46.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFEC5B13),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Text('View Transaction', style: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'Payment processed successfully and synced with QuickBooks',
              fontsize: 10.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}