import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SurgeryInfoTable extends StatelessWidget {
  final List<SurgeryInfoRow> rows;

  const SurgeryInfoTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: e.value.label,
                      fontsize: 12.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: e.value.value,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.end,
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
    );
  }
}

class SurgeryInfoRow {
  final String label;
  final String value;
  const SurgeryInfoRow(this.label, this.value);
}