import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class JobLocationCard extends StatelessWidget {
  final String pickupName;
  final String pickupAddress;
  final String pickupContact;
  final String pickupPhone;
  final String dropoffName;
  final String dropoffAddress;
  final String dropoffContact;
  final String dropoffPhone;

  const JobLocationCard({
    super.key,
    required this.pickupName,
    required this.pickupAddress,
    required this.pickupContact,
    required this.pickupPhone,
    required this.dropoffName,
    required this.dropoffAddress,
    required this.dropoffContact,
    required this.dropoffPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        children: [
          _LocationSection(
            dotColor: const Color(0xFF1DB954),
            label: 'Pickup Location',
            name: pickupName,
            address: pickupAddress,
            contact: pickupContact,
            phone: pickupPhone,
            showDivider: true,
          ),
          _LocationSection(
            dotColor: AppColors.redColorFF1D1D,
            label: 'Drop-off Location',
            name: dropoffName,
            address: dropoffAddress,
            contact: dropoffContact,
            phone: dropoffPhone,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String name;
  final String address;
  final String contact;
  final String phone;
  final bool showDivider;

  const _LocationSection({
    required this.dotColor,
    required this.label,
    required this.name,
    required this.address,
    required this.contact,
    required this.phone,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: label,
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: name,
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: address,
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Contact',
                          fontsize: 9.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: contact,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Phone',
                          fontsize: 9.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: phone,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
              height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
      ],
    );
  }
}