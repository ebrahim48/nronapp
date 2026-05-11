import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SaleFeedbackSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  const SaleFeedbackSection({
    super.key,
    required this.controller,
    required this.onSend,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Feedback & Comment',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 10.h),

          // Comment text field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: TextFormField(
              controller: controller,
              maxLines: 4,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'Leave a comment for the Rep...',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                  color: AppColors.secondaryTextColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12.r),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // Send Feedback button - right aligned
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: isSending ? null : onSend,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSending
                      ? AppColors.primaryColor.withValues(alpha: 0.5)
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: isSending
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: CircularProgressIndicator(
                          color: AppColors.blackColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Send Feedback',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(Icons.arrow_forward,
                              color: AppColors.blackColor, size: 14.r),
                        ],
                      ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Note to Manager card
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2200),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: AppColors.warningColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOTE TO MANAGER',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.warningColor,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Comments are logged in the permanent audit trail for this transaction.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.warningColor.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}