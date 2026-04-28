import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class PackageDetailsRow extends StatelessWidget {
  final String items;
  final String weight;
  final String service;

  const PackageDetailsRow({
    super.key,
    required this.items,
    required this.weight,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Package Details',
          fontsize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            _PackageCell(label: 'Items', value: items),
            SizedBox(width: 10.w),
            _PackageCell(label: 'Weight', value: weight),
            SizedBox(width: 10.w),
            _PackageCell(label: 'Service', value: service),
          ],
        ),
      ],
    );
  }
}

class _PackageCell extends StatelessWidget {
  final String label;
  final String value;

  const _PackageCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label,
              fontsize: 9.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: value,
              fontsize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}