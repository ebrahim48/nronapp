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
          // Avatar — network or fallback
          ClipOval(
            child: detail.repProfileUrl.isNotEmpty
                ? Image.network(
                    detail.repProfileUrl,
                    width: 56.r,
                    height: 56.r,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackAvatar(),
                  )
                : _fallbackAvatar(),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: detail.repName.isNotEmpty ? detail.repName : '—',
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

  Widget _fallbackAvatar() {
    return Container(
      width: 56.r,
      height: 56.r,
      color: const Color(0xFF3A3A3A),
      child: Icon(Icons.person,
          color: AppColors.secondaryTextColor, size: 26.r),
    );
  }
}
