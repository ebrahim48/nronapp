import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/shipment_model.dart';


class ShipmentCard extends StatelessWidget {
  final ShipmentModel shipment;
  final VoidCallback? onTap;

  const ShipmentCard({super.key, required this.shipment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: shipment.title,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(width: 8.w),
                _StatusBadge(status: shipment.status),
              ],
            ),
            SizedBox(height: 2.h),
            CustomText(
              text: 'Ref: ${shipment.refNumber}',
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10.h),
            // Driver / Pickup Date row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Driver',
                        fontsize: 11.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Container(
                            width: 22.r,
                            height: 22.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3A3A3A),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 13.r,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          CustomText(
                            text: shipment.driverName,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: 'Pickup Date',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 3.h),
                    CustomText(
                      text: '${shipment.pickupDate}, ${shipment.pickupTime}',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Pickup / Drop timeline
            _AddressTimeline(
              pickup: shipment.pickupAddress,
              dropoff: shipment.dropAddress,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final String label;

    switch (status) {
      case 'pending':
        bg = AppColors.warningColor;
        label = 'Pending';
        break;
      case 'in_transit':
        bg = AppColors.warningColor;
        label = 'In Transit';
        break;
      case 'delivered':
        bg = const Color(0xFF00D500);
        label = 'Delivered';
        break;
      case 'approved':
        bg = AppColors.primaryColor;
        label = 'Approved';
        break;
      case 'rejected':
        bg = Colors.red;
        label = 'Rejected';
        break;
      default:
        bg = AppColors.secondaryTextColor;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: label,
        fontsize: 11.sp,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}

// ── Address Timeline ──────────────────────────────────────────────────────────

class _AddressTimeline extends StatelessWidget {
  final String pickup;
  final String dropoff;

  const _AddressTimeline({required this.pickup, required this.dropoff});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot–line–dot indicator
        Column(
          children: [
            SizedBox(height: 3.h),
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 1.5.w,
              height: 26.h,
              color: AppColors.primaryColor.withValues(alpha: 0.35),
            ),
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        SizedBox(width: 8.w),
        // Labels
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Pickup',
                  fontsize: 10.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: pickup,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Drop Address',
                  fontsize: 10.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: dropoff,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}