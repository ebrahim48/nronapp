import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/manager_commission_model.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class CommissionRepCard extends StatelessWidget {
  final String name;
  final String role;
  final String? avatarUrl;
  final CommissionPaymentStatus? status;

  const CommissionRepCard({
    super.key,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Row(
        children: [
          ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    width: 56.r,
                    height: 56.r,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(),
                  )
                : _fallback(),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name.isNotEmpty ? name : '—',
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: role,
                  fontsize: 12.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          if (status != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.warningColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                status == CommissionPaymentStatus.paid ? 'PAID' : 'PENDING',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: AppColors.warningColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: 56.r,
      height: 56.r,
      color: const Color(0xFF3A3A3A),
      child: Icon(Icons.person, color: AppColors.secondaryTextColor, size: 26.r),
    );
  }
}
