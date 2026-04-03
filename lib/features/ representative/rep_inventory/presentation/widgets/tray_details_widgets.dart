import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/tray_details_controller.dart';

class TrayInfoCard extends StatelessWidget {
  final String imagePath;
  final String trayId;
  final String trayName;
  final String updatedAgo;

  const TrayInfoCard({
    super.key,
    required this.imagePath,
    required this.trayId,
    required this.trayName,
    required this.updatedAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 109.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              width: 96.w,
              height: 76.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 96.w,
                height: 76.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3A3A),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/implantsinventory.svg',
                    width: 32.r,
                    height: 32.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 16.w),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: trayId,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: trayName,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.secondaryTextColor,
                      size: 12.r,
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: updatedAgo,
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrayTagRow extends StatelessWidget {
  final String inventoryModel;
  final String status;

  const TrayTagRow({
    super.key,
    required this.inventoryModel,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TrayTag(
          iconPath: 'assets/icons/expense.svg',
          label: inventoryModel,
          bgColor: const Color(0x1AEC5B13),
          borderColor: const Color(0x4DEC5B13),
          textColor: const Color(0xFFEC5B13),
        ),
        SizedBox(width: 10.w),
        _TrayTag(
          iconPath: 'assets/icons/drawer1.svg',
          label: status,
          bgColor: const Color(0x1A3A3A3A),
          borderColor: const Color(0xFF3A3A3A),
          textColor: AppColors.primaryTextColor,
        ),
      ],
    );
  }
}

class _TrayTag extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const _TrayTag({
    required this.iconPath,
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon box — orange bg 10% for loaner
          Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 12.r,
                height: 12.r,
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          CustomText(
            text: label,
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class TrayLocationCard extends StatelessWidget {
  final String location;

  const TrayLocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          // Orange location icon box
          Container(
            width: 32.r,
            height: 36.r,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0x1AEC5B13), // 10%
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              'assets/icons/map.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFFEC5B13),
                BlendMode.srcIn,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Current Location',
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: location,
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrayMovementHistory extends StatelessWidget {
  final List<MovementHistoryItem> items;

  const TrayMovementHistory({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Movement History',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16.h),
        ...items.asMap().entries.map((e) => _HistoryItem(
          item: e.value,
          isLast: e.key == items.length - 1,
        )),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final MovementHistoryItem item;
  final bool isLast;

  const _HistoryItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot + line
          SizedBox(
            width: 24.w,
            child: Column(
              children: [
                Container(
                  width: 14.r,
                  height: 14.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isActive
                        ? const Color(0xFFEC5B13)
                        : const Color(0xFF555555),
                    border: Border.all(
                      color: item.isActive
                          ? const Color(0xFF221610) // dark ring
                          : const Color(0xFF3A3A3A),
                      width: 3,
                    ),
                  ),
                ),
                // Vertical line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: const Color(0xFF3A3A3A),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.title,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: item.isActive
                        ? AppColors.primaryTextColor
                        : AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: item.subtitle,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrayActionButtons extends StatelessWidget {
  final VoidCallback onSendTray;
  final VoidCallback onReceiveTray;
  final VoidCallback onReportMissing;

  const TrayActionButtons({
    super.key,
    required this.onSendTray,
    required this.onReceiveTray,
    required this.onReportMissing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Send Tray + Receive Tray
        Row(
          children: [
            // Send Tray — teal filled
            Expanded(
              child: GestureDetector(
                onTap: onSendTray,
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping_outlined,
                          color: Colors.black, size: 18.r),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'Send Tray',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: GestureDetector(
                onTap: onReceiveTray,
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call_received_rounded,
                          color: AppColors.primaryTextColor, size: 16.r),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'Receive Tray',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        GestureDetector(
          onTap: onReportMissing,
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2121),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: const Color(0xFFEC5B13), size: 18.r),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Report Missing Instrument',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}