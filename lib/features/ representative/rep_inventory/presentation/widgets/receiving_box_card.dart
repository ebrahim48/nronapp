import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/implant_model.dart';


class ReceivingBoxCard extends StatelessWidget {
  final ReceivingBoxModel box;
  final VoidCallback onToggle;

  const ReceivingBoxCard({
    super.key,
    required this.box,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: box.boxCode,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: box.description,
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: '${box.itemCount.toString().padLeft(2, '0')} ITEMS',
                    fontsize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          // Collapse/expand toggle row
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.only(
                  bottomLeft:
                  box.isExpanded ? Radius.zero : Radius.circular(12.r),
                  bottomRight:
                  box.isExpanded ? Radius.zero : Radius.circular(12.r),
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                ),
              ),
              child: Icon(
                box.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.secondaryTextColor,
                size: 20.r,
              ),
            ),
          ),

          // Serial list (expanded)
          if (box.isExpanded)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                children: box.serialRanges
                    .map(
                      (sr) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 7.h),
                    child: Row(
                      children: [
                        Icon(Icons.drag_indicator,
                            color: AppColors.secondaryTextColor,
                            size: 14.r),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: sr,
                          fontsize: 12.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}