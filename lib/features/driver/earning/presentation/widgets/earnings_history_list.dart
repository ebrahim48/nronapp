import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/earning_model.dart';


class EarningsHistoryList extends StatelessWidget {
  final List<EarningEntryModel> entries;
  final String? filterValue;
  final List<String>? filterOptions;
  final ValueChanged<String>? onFilterChanged;
  final VoidCallback? onViewMore;
  final bool showViewMore;

  const EarningsHistoryList({
    super.key,
    required this.entries,
    this.filterValue,
    this.filterOptions,
    this.onFilterChanged,
    this.onViewMore,
    this.showViewMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Earnings History',
                fontsize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              if (showViewMore && onViewMore != null)
                GestureDetector(
                  onTap: onViewMore,
                  child: CustomText(
                    text: 'View More',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              if (!showViewMore &&
                  filterOptions != null &&
                  filterValue != null)
                _FilterDropdown(
                  value: filterValue!,
                  options: filterOptions!,
                  onChanged: onFilterChanged,
                ),
            ],
          ),
          SizedBox(height: 14.h),

          // Rows
          ...entries.map((e) => _EarningRow(entry: e)),
        ],
      ),
    );
  }
}


class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  const _FilterDropdown({
    required this.value,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: const Color(0xFF252525),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (o) => ListTile(
                title: Text(
                  o,
                  style: TextStyle(
                    color: o == value
                        ? AppColors.primaryColor
                        : AppColors.primaryTextColor,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                  ),
                ),
                trailing: o == value
                    ? Icon(Icons.check,
                    color: AppColors.primaryColor, size: 16.r)
                    : null,
                onTap: () => Navigator.pop(context, o),
              ),
            )
                .toList(),
          ),
        );
        if (result != null) onChanged?.call(result);
      },
      child: Row(
        children: [
          CustomText(
            text: value,
            fontsize: 12.sp,
            color: AppColors.primaryTextColor,
          ),
          SizedBox(width: 3.w),
          Icon(Icons.keyboard_arrow_down,
              color: AppColors.primaryTextColor, size: 16.r),
        ],
      ),
    );
  }
}


class _EarningRow extends StatelessWidget {
  final EarningEntryModel entry;
  const _EarningRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isPaid = entry.status == 'paid';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shipment ID + date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: entry.shipmentId,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: entry.date,
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),

              // Amount + badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: '\$${entry.amount.toInt()}',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: isPaid
                        ? const Color(0xFF4ADE80)
                        : AppColors.warningColor,
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 4.h),
                  _StatusBadge(status: entry.status),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: const Color(0xFF3A3A3A),
          height: 1,
          thickness: 0.5,
        ),
      ],
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'paid';
    final color =
    isPaid ? const Color(0xFF4ADE80) : AppColors.warningColor;
    final bg = isPaid
        ? const Color(0xFF0F2A1A)
        : const Color(0xFF2A1A0A);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: status,
        fontsize: 10.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}