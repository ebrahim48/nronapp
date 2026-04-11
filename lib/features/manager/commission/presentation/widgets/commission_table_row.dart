import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class CommissionTableRow extends StatelessWidget {
  final CommissionListItem item;
  final VoidCallback? onTap;

  const CommissionTableRow({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isClosed = item.billStatus == CommissionBillStatus.closed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF2A2A2A), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 52.w,
              child: CustomText(
                text: item.saleId,
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3A4A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        item.repInitials,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: CustomText(
                      text: item.repName,
                      fontsize: 10.sp,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      maxline: 2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80.w,
              child: CustomText(
                text: item.area,
                fontsize: 9.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
                maxline: 2,
              ),
            ),
            SizedBox(
              width: 56.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isClosed
                        ? const Color(0xFF5A4A00)
                        : const Color(0xFF003A00),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    isClosed ? 'Closed' : 'Open',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: isClosed
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF00D500),
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