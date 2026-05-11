import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class CommissionTableRow extends StatelessWidget {
  final CommissionListItem item;
  final VoidCallback? onTap;

  const CommissionTableRow({super.key, required this.item, this.onTap});

  bool get _isPaid => item.status.toLowerCase() == 'paid';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E1E),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: Sale ID label + status badge ──────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sale ID',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: AppColors.warningColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.saleId.isNotEmpty ? '#${item.saleId}' : '—',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                // Status badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: _isPaid
                        ? const Color(0xFF00C853).withValues(alpha: 0.15)
                        : const Color(0xFFFF6D00).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _isPaid
                          ? const Color(0xFF00C853).withValues(alpha: 0.5)
                          : const Color(0xFFFF6D00).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    _isPaid ? 'PAID' : 'UNPAID',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: _isPaid
                          ? const Color(0xFF00C853)
                          : const Color(0xFFFF6D00),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // ── Rep name ───────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.person_outline,
                    color: AppColors.secondaryTextColor, size: 14.r),
                SizedBox(width: 6.w),
                Expanded(
                  child: CustomText(
                    text: item.repName.isNotEmpty ? item.repName : '—',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            // ── Facility ───────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.business_outlined,
                    color: AppColors.secondaryTextColor, size: 14.r),
                SizedBox(width: 6.w),
                Expanded(
                  child: CustomText(
                    text: item.facilityName.isNotEmpty
                        ? item.facilityName
                        : '—',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Divider(
                height: 1, thickness: 0.5, color: const Color(0xFF2A2A2A)),

            SizedBox(height: 10.h),

            // ── Bottom row: sale info + commission amount ──────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.saleAmount > 0
                          ? 'Sale: \$${item.saleAmount.toStringAsFixed(0)} (${item.commissionRate}%)'
                          : '—',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.date.isNotEmpty ? item.date : '—',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Commission',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '\$${item.commissionAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
