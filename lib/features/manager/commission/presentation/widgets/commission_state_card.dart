import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class CommissionStatCard extends StatelessWidget {
  final ManagerCommissionStat stat;

  const CommissionStatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: stat.label,
              fontsize: 12.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: stat.value,
              fontsize: 20.sp,
              fontWeight: FontWeight.w700,
              color: stat.valueColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}