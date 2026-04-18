import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class JobShipmentHeader extends StatelessWidget {
  final String shipmentId;
  final bool isUrgent;

  const JobShipmentHeader({
    super.key,
    required this.shipmentId,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Shipment ID',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: shipmentId,
                fontsize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          if (isUrgent)
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.redColorFF1D1D,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Urgent',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}