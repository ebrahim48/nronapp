import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/missing_instrument_model.dart';



class MissingSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const MissingSearchBar({
    super.key,
    required this.controller,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Search field ──
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2121),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Row(
              children: [
                SizedBox(width: 14.w),
                Icon(Icons.search,
                    size: 18.r, color: AppColors.secondaryTextColor),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.primaryTextColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search Tray ID or Facility...',
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.secondaryTextColor,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w),

        // ── Filter button ──
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2121),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 20.r,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 2. Stats Row  (Total | Missing)
// ─────────────────────────────────────────────────────────────
class MissingStatsRow extends StatelessWidget {
  final int total;
  final int missing;

  const MissingStatsRow({
    super.key,
    required this.total,
    required this.missing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total',
            value: '$total',
            valueColor: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            label: 'Missing',
            value: '$missing',
            valueColor: const Color(0xFFE53935),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 28.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}


class MissingReportCard extends StatelessWidget {
  final MissingInstrumentModel item;
  final VoidCallback onTap;

  const MissingReportCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: trayId tag + status badge + arrow ──
            Row(
              children: [
                _TrayIdBadge(trayId: item.trayId),
                SizedBox(width: 8.w),
                _StatusBadge(status: item.status),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.r,
                  color: AppColors.secondaryTextColor,
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // ── Facility name ──
            CustomText(
              text: item.facility,
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 12.h),

            Divider(height: 1, thickness: 1, color: const Color(0xFF2E2E2E)),

            SizedBox(height: 12.h),

            // ── Reporter + date ──
            Row(
              children: [
                CircleAvatar(
                  radius: 14.r,
                  backgroundImage: AssetImage(item.reporterAvatar),
                  backgroundColor: const Color(0xFF3A3A3A),
                  onBackgroundImageError: (_, __) {},
                  child: Icon(Icons.person,
                      size: 14.r, color: AppColors.secondaryTextColor),
                ),
                SizedBox(width: 8.w),
                CustomText(
                  text: item.reportedBy,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
                CustomText(
                  text: DateFormat('MMM dd, yyyy').format(item.date),
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrayIdBadge extends StatelessWidget {
  final String trayId;
  const _TrayIdBadge({required this.trayId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0D3A3A),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: CustomText(
        text: trayId,
        fontsize: 11.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF00BCD4),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MissingInstrumentStatus status;
  const _StatusBadge({required this.status});

  Color get _bg {
    switch (status) {
      case MissingInstrumentStatus.missing:
        return const Color(0xFF3A0D0D);
      case MissingInstrumentStatus.damaged:
        return const Color(0xFF3A2A00);
      case MissingInstrumentStatus.resolved:
        return const Color(0xFF0D2E1A);
    }
  }

  Color get _text {
    switch (status) {
      case MissingInstrumentStatus.missing:
        return const Color(0xFFE53935);
      case MissingInstrumentStatus.damaged:
        return const Color(0xFFFFB300);
      case MissingInstrumentStatus.resolved:
        return const Color(0xFF22C55E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: CustomText(
        text: status.name[0].toUpperCase() + status.name.substring(1),
        fontsize: 11.sp,
        fontWeight: FontWeight.w600,
        color: _text,
        textAlign: TextAlign.start,
      ),
    );
  }
}