import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/driver_map_model.dart';

class RouteStopsList extends StatelessWidget {
  final RouteStopModel pickup;
  final RouteStopModel intermediate;

  const RouteStopsList({
    super.key,
    required this.pickup,
    required this.intermediate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StopRow(
          stop: pickup,
          dotColor: const Color(0xFF1DB954),
          showDivider: true,
        ),
        _StopRow(
          stop: intermediate,
          dotColor: AppColors.secondaryTextColor,
          showDivider: false,
          isLocationPin: true,
        ),
      ],
    );
  }
}

class _StopRow extends StatelessWidget {
  final RouteStopModel stop;
  final Color dotColor;
  final bool showDivider;
  final bool isLocationPin;

  const _StopRow({
    required this.stop,
    required this.dotColor,
    required this.showDivider,
    this.isLocationPin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              isLocationPin
                  ? Icon(Icons.location_on_outlined,
                  color: dotColor, size: 16.r)
                  : Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: stop.name,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: stop.address,
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              CustomText(
                text: stop.eta,
                fontsize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              color: const Color(0xFF3A3A3A),
              thickness: 0.5),
      ],
    );
  }
}