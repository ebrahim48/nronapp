import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/driver_job_model.dart';

class ShipmentSummaryCard extends StatelessWidget {
  final String shipmentId;
  final String type;
  final JobPriority priority;

  const ShipmentSummaryCard({
    super.key,
    required this.shipmentId,
    required this.type,
    required this.priority,
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
            text: 'Shipment Summary',
            fontsize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          _Row(label: 'Shipment ID', value: shipmentId),
          _Row(label: 'Type', value: type),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Priority',
                fontsize: 12.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: priority == JobPriority.urgent
                      ? AppColors.redColorFF1D1D.withValues(alpha: 0.15)
                      : AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  priority == JobPriority.urgent ? 'urgent' : 'standard',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: priority == JobPriority.urgent
                        ? AppColors.redColorFF1D1D
                        : AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          CustomText(
            text: value,
            fontsize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}