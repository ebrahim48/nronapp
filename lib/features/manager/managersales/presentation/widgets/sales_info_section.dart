import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SaleInfoSection extends StatelessWidget {
  final String title;
  final List<SaleInfoRow> rows;

  const SaleInfoSection({
    super.key,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontsize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Column(
          children: rows.asMap().entries.map((e) {
            final isLast = e.key == rows.length - 1;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: e.value.label,
                        fontsize: 13.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(width: 16.w),
                      Flexible(
                        child: CustomText(
                          text: e.value.value,
                          fontsize: 13.sp,
                          fontWeight: e.value.bold
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: e.value.valueColor ??
                              AppColors.primaryTextColor,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                      height: 1,
                      color: const Color(0xFF3A3A3A),
                      thickness: 0.5),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SaleInfoRow {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const SaleInfoRow(
      this.label,
      this.value, {
        this.valueColor,
        this.bold = false,
      });
}