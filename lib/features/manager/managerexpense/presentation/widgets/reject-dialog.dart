import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/manager_expense_controller.dart';


class RejectDialog extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RejectDialog({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  static Future<void> show(
      BuildContext context, {
        required VoidCallback onSubmit,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => RejectDialog(
        onSubmit: onSubmit,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerExpenseController>();

    return Container(
      padding: EdgeInsets.fromLTRB(
          20.w, 20.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2427),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Reason for Rejection',
            fontsize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 6.h),

          CustomText(
            text: 'Please specify why this expense is being rejected.',
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),

          Divider(
              color: const Color(0xFF3A3A3A), height: 16.h, thickness: 0.5),

          CustomText(
            text: 'Comments',
            fontsize: 13.sp,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 8.h,
          ),

          // Comments text area
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: TextFormField(
              controller: c.rejectCommentController,
              maxLines: 4,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'Provide additional feedback for the employee...',
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                  color: AppColors.secondaryTextColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14.r),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Cancel + Submit row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
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
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: GestureDetector(
                  onTap: onSubmit,
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: AppColors.redColorFF1D1D,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}