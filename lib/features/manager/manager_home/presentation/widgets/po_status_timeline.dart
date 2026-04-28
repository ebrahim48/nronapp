import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_po_model.dart';

class POStatusTimeline extends StatelessWidget {
  final List<POTimelineItem> items;

  const POStatusTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Status Timeline',
            fontsize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 14.h),
          ...items.asMap().entries.map((e) {
            final isLast = e.key == items.length - 1;
            return _TimelineStep(
                item: e.value, isLast: isLast);
          }),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final POTimelineItem item;
  final bool isLast;

  const _TimelineStep({required this.item, required this.isLast});

  Color _dotColor() {
    switch (item.status) {
      case POTimelineStatus.done:
        return AppColors.primaryColor;
      case POTimelineStatus.inProgress:
        return AppColors.primaryColor;
      case POTimelineStatus.pending:
        return const Color(0xFF3A3A3A);
    }
  }

  Widget _dotIcon() {
    switch (item.status) {
      case POTimelineStatus.done:
        return Icon(Icons.check,
            color: AppColors.blackColor, size: 14.r);
      case POTimelineStatus.inProgress:
        return Icon(Icons.more_horiz,
            color: AppColors.blackColor, size: 14.r);
      case POTimelineStatus.pending:
        return Icon(Icons.access_time,
            color: AppColors.secondaryTextColor, size: 14.r);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + line column
          Column(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: _dotColor(),
                  shape: BoxShape.circle,
                ),
                child: Center(child: _dotIcon()),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),
          // Content
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
                    color: item.status == POTimelineStatus.pending
                        ? AppColors.secondaryTextColor
                        : AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: item.subtitle,
                    fontsize: 11.sp,
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