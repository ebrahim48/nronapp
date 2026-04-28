import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class LocationCard extends StatelessWidget {
  final String pickupName;
  final String pickupAddress;
  final String pickupContact;
  final String pickupPhone;

  final String dropoffName;
  final String dropoffAddress;
  final String dropoffContact;
  final String dropoffPhone;

  const LocationCard({
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
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Pickup ────────────────────────────────────────────────────────
          _LocationEntry(
            dotColor: const Color(0xFF00D500),
            label: 'Pickup Location',
            name: pickupName,
            address: pickupAddress,
            contact: pickupContact,
            phone: pickupPhone,
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(
              color: const Color(0xFF3A3A3A),
              height: 1,
              thickness: 0.6,
            ),
          ),

          // ── Drop-off ──────────────────────────────────────────────────────
          _LocationEntry(
            dotColor: Colors.redAccent,
            label: 'Drop-off Location',
            name: dropoffName,
            address: dropoffAddress,
            contact: dropoffContact,
            phone: dropoffPhone,
          ),
        ],
      ),
    );
  }
}

// ── Single location entry ─────────────────────────────────────────────────────

class _LocationEntry extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String name;
  final String address;
  final String contact;
  final String phone;

  const _LocationEntry({
    required this.dotColor,
    required this.label,
    required this.name,
    required this.address,
    required this.contact,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with dot
        Row(
          children: [
            Container(
              width: 9.r,
              height: 9.r,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: label,
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(height: 4.h),

        // Place name
        Padding(
          padding: EdgeInsets.only(left: 17.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name,
                fontsize: 14.sp,
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

              // Contact + Phone
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Contact',
                          fontsize: 10.sp,
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
                          fontsize: 10.sp,
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
      ],
    );
  }
}