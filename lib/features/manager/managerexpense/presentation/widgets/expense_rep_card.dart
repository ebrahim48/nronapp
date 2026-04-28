import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_expense_model.dart';

class ExpenseRepCard extends StatelessWidget {
  final ManagerExpenseDetailModel detail;

  const ExpenseRepCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3A),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF2A3A4A), width: 0.8),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28.r,
            backgroundImage: detail.repAvatarAsset != null
                ? AssetImage(detail.repAvatarAsset!)
                : null,
            backgroundColor: const Color(0xFF3A3A3A),
            child: detail.repAvatarAsset == null
                ? Icon(Icons.person,
                color: AppColors.secondaryTextColor, size: 26.r)
                : null,
          ),

          SizedBox(width: 14.w),

          // Name + role + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: detail.repName,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: detail.repRole,
                  fontsize: 12.sp,
                  color: AppColors.primaryColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: detail.submittedDate,
                  fontsize: 10.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}