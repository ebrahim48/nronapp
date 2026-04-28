import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class RouteInformationCard extends StatelessWidget {
  final String pickupLocation;
  final String pickupAddress;
  final String pickupContact;
  final String pickupPhone;
  final String pickupDate;
  final String pickupInstructions;
  final String dropoffLocation;
  final String dropoffAddress;
  final String dropoffFacility;
  final String dropoffContact;
  final String dropoffPhone;
  final String dropoffInstructions;

  const RouteInformationCard({
    super.key,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.pickupContact,
    required this.pickupPhone,
    required this.pickupDate,
    required this.pickupInstructions,
    required this.dropoffLocation,
    required this.dropoffAddress,
    required this.dropoffFacility,
    required this.dropoffContact,
    required this.dropoffPhone,
    required this.dropoffInstructions,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Route Information',
            fontsize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 12.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1DB954),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                      width: 1.5,
                      height: 160.h,
                      color: const Color(0xFF3A3A3A)),
                  Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: const BoxDecoration(
                      color: AppColors.redColorFF1D1D,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Pickup Location',
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: pickupLocation,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: pickupAddress,
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    _DetailBox(
                      rows: [
                        _DetailBoxRow(label: 'Contact', value: pickupContact, valueColor: AppColors.primaryTextColor),
                        _DetailBoxRow(label: 'Phone', value: pickupPhone, valueColor: AppColors.primaryColor),
                        _DetailBoxRow(label: 'Pickup Date', value: pickupDate, valueColor: AppColors.primaryTextColor),
                        _DetailBoxRow(label: 'Instructions', value: pickupInstructions, valueColor: AppColors.primaryTextColor, fullWidth: true),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'Drop-off Location',
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: dropoffLocation,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: dropoffAddress,
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    _DetailBox(
                      rows: [
                        _DetailBoxRow(label: 'Facility', value: dropoffFacility, valueColor: AppColors.primaryTextColor),
                        _DetailBoxRow(label: 'Contact', value: dropoffContact, valueColor: AppColors.primaryTextColor),
                        _DetailBoxRow(label: 'Phone', value: dropoffPhone, valueColor: AppColors.primaryColor),
                        _DetailBoxRow(label: 'Instructions', value: dropoffInstructions, valueColor: AppColors.primaryTextColor, fullWidth: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailBoxRow {
  final String label;
  final String value;
  final Color valueColor;
  final bool fullWidth;
  const _DetailBoxRow({required this.label, required this.value, required this.valueColor, this.fullWidth = false});
}

class _DetailBox extends StatelessWidget {
  final List<_DetailBoxRow> rows;
  const _DetailBox({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: rows.map((row) {
          return Padding(
            padding: EdgeInsets.only(bottom: row == rows.last ? 0 : 6.h),
            child: row.fullWidth
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.label, style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', color: AppColors.secondaryTextColor)),
                SizedBox(height: 2.h),
                Text(row.value, style: TextStyle(fontSize: 11.sp, fontFamily: 'Poppins', color: row.valueColor)),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(row.label, style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', color: AppColors.secondaryTextColor)),
                Text(row.value, style: TextStyle(fontSize: 11.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: row.valueColor)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}