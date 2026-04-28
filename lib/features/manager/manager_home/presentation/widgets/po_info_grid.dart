import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_po_model.dart';

class POInfoGrid extends StatelessWidget {
  final ManagerPODetailModel detail;

  const POInfoGrid({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoCell(
                label: 'Patient ID',
                value: detail.patientId,
              ),
            ),
            Expanded(
              child: _InfoCell(
                label: 'Additional Notes',
                value: '',
                showIcon: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoCell(
                label: 'Facility',
                value: detail.facility,
                subValue: detail.facilityEmail,
              ),
            ),
            Expanded(
              child: _InfoCell(
                label: 'Date of Surgery',
                value: detail.dateOfSurgery,
                subValue: detail.surgeryTime,
                valueColor: AppColors.primaryTextColor,
                subValueWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoCell(
                label: 'Surgeon',
                value: detail.surgeon,
                subValue: detail.surgeonSpecialty,
              ),
            ),
            Expanded(
              child: _InfoCell(
                label: 'Vendor',
                value: detail.vendor,
                subValue: detail.vendorEmail,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Total Amount',
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: '\$${detail.totalAmount.toStringAsFixed(2)}',
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final Color? valueColor;
  final FontWeight? subValueWeight;
  final bool showIcon;

  const _InfoCell({
    required this.label,
    required this.value,
    this.subValue,
    this.valueColor,
    this.subValueWeight,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontsize: 10.sp,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 2.h),
        if (showIcon)
          Icon(Icons.copy_outlined,
              color: AppColors.primaryColor, size: 18.r)
        else ...[
          CustomText(
            text: value,
            fontsize: 12.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          if (subValue != null)
            CustomText(
              text: subValue!,
              fontsize: 10.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
        ],
      ],
    );
  }
}