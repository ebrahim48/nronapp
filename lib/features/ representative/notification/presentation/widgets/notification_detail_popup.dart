import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/custom_widgets/custom_network_image.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../model/notification_model.dart';

void showNotificationDetail(BuildContext context, NotificationModel n) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _NotificationDetailSheet(notification: n),
  );
}

class _NotificationDetailSheet extends StatelessWidget {
  final NotificationModel notification;
  const _NotificationDetailSheet({required this.notification});

  Color get _iconBg {
    switch (notification.iconType) {
      case IconType.assigned:  return const Color(0xFF7B61FF);
      case IconType.delivered: return const Color(0xFF08AF40);
      case IconType.status:    return const Color(0xFF00C5DA);
      case IconType.newItem:   return const Color(0xFFE6A817);
      case IconType.general:   return AppColors.secondaryTextColor;
    }
  }

  IconData get _icon {
    switch (notification.iconType) {
      case IconType.assigned:  return Icons.person_add_outlined;
      case IconType.delivered: return Icons.check_circle_outline;
      case IconType.status:    return Icons.sync_outlined;
      case IconType.newItem:   return Icons.add_circle_outline;
      case IconType.general:   return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  notification.sender.profileUrl.isNotEmpty
                      ? CustomNetworkImage(
                          imageUrl: notification.sender.profileUrl,
                          height: 52.r,
                          width: 52.r,
                        )
                      : Container(
                          width: 52.r,
                          height: 52.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF2A2A2A),
                          ),
                          child: Icon(Icons.person_outline,
                              color: AppColors.secondaryTextColor, size: 26.r),
                        ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _iconBg,
                        border: Border.all(
                            color: const Color(0xFF1E2121), width: 1.5),
                      ),
                      child: Icon(_icon, color: Colors.white, size: 12.r),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: notification.sender.name,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined,
                            color: AppColors.secondaryTextColor, size: 11.r),
                        SizedBox(width: 3.w),
                        CustomText(
                          text: notification.published,
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: 'New',
                    fontsize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),
          Divider(color: const Color(0xFF2A2A2A), thickness: 0.8),
          SizedBox(height: 16.h),

          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: notification.title,
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: notification.description,
            fontsize: 13.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
