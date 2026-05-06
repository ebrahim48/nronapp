import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/tray_details_controller.dart';

class TrayHeaderSection extends StatelessWidget {
  final String title;       // e.g. "Surgical Unit A"
  final String location;    // e.g. "Main Operative Suite, North Wing"

  const TrayHeaderSection({
    super.key,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontsize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14.r,
              color: AppColors.secondaryTextColor,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: CustomText(
                text: location,
                fontsize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrayImagePlaceholder extends StatelessWidget {
  const _TrayImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E2A2E),
      child: Center(
        child: Icon(
          Icons.medical_services_outlined,
          color: Colors.white24,
          size: 48.r,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 2. TrayImageWithTags  →  full-width image + Loaner/Down Rack
// ─────────────────────────────────────────────────────────────
class TrayImageWithTags extends StatelessWidget {
  final String imagePath;
  final String inventoryModel; // "Loaner"
  final String status;         // "Down Rack"

  const TrayImageWithTags({
    super.key,
    required this.imagePath,
    required this.inventoryModel,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          // ── Tray image ──
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imagePath.startsWith('http')
              ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _TrayImagePlaceholder(),
                )
              : Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _TrayImagePlaceholder(),
                ),
          ),

          // ── Tags (top-left) ──
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Row(
              children: [
                _ImageTag(
                  iconPath: 'assets/icons/loaner.svg',
                  label: inventoryModel,
                  bgColor: const Color(0xCC1A1A1A),
                  borderColor: const Color(0xFF3A3A3A),
                  textColor: AppColors.primaryTextColor,
                ),
                SizedBox(width: 8.w),
                _ImageTag(
                  iconPath: 'assets/icons/downrack.svg',
                  label: status,
                  bgColor: const Color(0xCC1A2A3A),
                  borderColor: const Color(0xFF2A4A6A),
                  textColor: AppColors.primaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageTag extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const _ImageTag({
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
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 13.r,
            height: 13.r,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          SizedBox(width: 5.w),
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

// ─────────────────────────────────────────────────────────────
// 3. TrayGeneralInfoCard  →  "General Information" + In Stock
// ─────────────────────────────────────────────────────────────
class TrayGeneralInfoCard extends StatelessWidget {
  final String serialNumber;
  final String systemType;
  final String vendor;
  final String availabilityStatus; // "Available" | "Unavailable"

  const TrayGeneralInfoCard({
    super.key,
    required this.serialNumber,
    required this.systemType,
    required this.vendor,
    required this.availabilityStatus,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable =
        availabilityStatus.toLowerCase() == 'available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'General Information',
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF0D2E1A),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFF1A5C30),
                  width: 1,
                ),
              ),
              child: CustomText(
                text: 'In Stock',
                fontsize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF22C55E),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // ── Info rows container ──
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Column(
            children: [
              _GeneralInfoRow(
                iconPath: 'assets/icons/serial.svg',
                label: 'Serial Number',
                value: serialNumber,
                showDivider: true,
              ),
              _GeneralInfoRow(
                iconPath: 'assets/icons/systemtype.svg',
                label: 'System Type',
                value: systemType,
                showDivider: true,
              ),
              _GeneralInfoRow(
                iconPath: 'assets/icons/vendor.svg',
                label: 'Vendor',
                value: vendor,
                showDivider: true,
              ),
              _GeneralInfoRow(
                iconPath: 'assets/icons/status.svg',
                label: 'Status',
                value: availabilityStatus,
                showDivider: false,
                customTrailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isAvailable
                            ? const Color(0xFF22C55E)
                            : Colors.redAccent,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      text: availabilityStatus,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GeneralInfoRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final bool showDivider;
  final Widget? customTrailing;

  const _GeneralInfoRow({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.showDivider,
    this.customTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF4A90D9),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomText(
                  text: label,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ),
              customTrailing ??
                  CustomText(
                    text: value,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: const Color(0xFF3A3A3A),
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4. TrayAdditionalNote
// ─────────────────────────────────────────────────────────────
class TrayAdditionalNote extends StatelessWidget {
  final String note;

  const TrayAdditionalNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Additional Note',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: CustomText(
            text: note,
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 5. TrayInfoCard  (existing – unchanged)
// ─────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────
// 6. TrayTagRow  (existing – unchanged)
// ─────────────────────────────────────────────────────────────
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
          iconPath: 'assets/icons/loaner.svg',
          label: inventoryModel,
          bgColor: const Color(0x1AEC5B13),
          borderColor: const Color(0x4DEC5B13),
          textColor: const Color(0xFFEC5B13),
        ),
        SizedBox(width: 10.w),
        _TrayTag(
          iconPath: 'assets/icons/downrack.svg',
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

// ─────────────────────────────────────────────────────────────
// 7. TrayLocationCard  (existing – unchanged)
// ─────────────────────────────────────────────────────────────
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
          Container(
            width: 32.r,
            height: 36.r,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0x1AEC5B13),
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

// ─────────────────────────────────────────────────────────────
// 8. TrayMovementHistory  (existing – unchanged)
// ─────────────────────────────────────────────────────────────
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
          SizedBox(
            width: 24.r,
            child: Column(
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isActive
                        ? const Color(0xFF221610)
                        : const Color(0xFF94A3B8),
                    border: Border.all(
                      color: item.isActive
                          ? const Color(0xFFEC5B13)
                          : const Color(0xFF221610),
                      width: 2,
                    ),
                  ),
                ),
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

// ─────────────────────────────────────────────────────────────
// 9. TrayActionButtons  (existing – unchanged)
// ─────────────────────────────────────────────────────────────
class TrayActionButtons extends StatelessWidget {
  final void Function(BuildContext context) onSendTray;
  final void Function(BuildContext context) onReceiveTray;
  final void Function(BuildContext context) onReportMissing;

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
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onSendTray(context),
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
                onTap: () => onReceiveTray(context),
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
          onTap: () => onReportMissing(context),
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