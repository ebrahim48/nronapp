import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class PersonalInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const PersonalInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: label,
                fontsize: 13.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: value,
                fontsize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
              height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
      ],
    );
  }
}