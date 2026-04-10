import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_button.dart';


class ApproveDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ApproveDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  static Future<void> show(
      BuildContext context, {
        required VoidCallback onConfirm,
      }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => ApproveDialog(
        onConfirm: onConfirm,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2427),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Check circle icon
            Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
                    width: 2),
              ),
              child: Icon(
                Icons.check,
                color: AppColors.primaryColor,
                size: 36.r,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              'Confirm Approval',
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              'This expense will be approved and automatically synced with QuickBooks Online.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                color: AppColors.secondaryTextColor,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24.h),


            CustomButton(
              title: 'Confirm & Sync',
              onpress: onConfirm,
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w700,
              borderRadius: 12,
            ),

            SizedBox(height: 10.h),

            // Cancel
            GestureDetector(
              onTap: onCancel,
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}