import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/payment_model.dart';


class PaymentCardTile extends StatelessWidget {
  final PaymentCardModel card;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PaymentCardTile({
    super.key,
    required this.card,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: card.isDefault
              ? AppColors.primaryColor.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(
                    color: card.cardColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: card.cardColor,
                    size: 22.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: card.cardType,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          if (card.isDefault) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.15),
                                borderRadius:
                                BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.4),
                                  width: 0.6,
                                ),
                              ),
                              child: CustomText(
                                text: 'Default',
                                fontsize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      CustomText(
                        text: card.holderName,
                        fontsize: 12.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 3.h),
                      CustomText(
                        text: '•••• •••• ${card.lastFour}',
                        fontsize: 12.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onSetDefault,
                  child: Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: card.isDefault
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: card.isDefault
                            ? AppColors.primaryColor
                            : AppColors.secondaryTextColor
                            .withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: card.isDefault
                        ? Icon(Icons.check,
                        color: Colors.white, size: 14.r)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          if (card.isDefault) ...[
            Container(
              height: 0.5,
              color: const Color(0xFF3A3A3A),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2427),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Edit',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A1010),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Delete',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}