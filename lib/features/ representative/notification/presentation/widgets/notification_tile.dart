import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/custom_widgets/custom_network_image.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../model/notification_model.dart';
import 'notification_detail_popup.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({super.key, required this.notification});

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
    final unread = !notification.isRead;

    return GestureDetector(
      onTap: () => showNotificationDetail(context, notification),
      child: Container(
      color: unread
          ? AppColors.primaryColor.withValues(alpha: 0.04)
          : Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              notification.sender.profileUrl.isNotEmpty
                  ? CustomNetworkImage(
                      imageUrl: notification.sender.profileUrl,
                      height: 44.r,
                      width: 44.r,
                    )
                  : Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2A2A2A),
                      ),
                      child: Icon(Icons.person_outline,
                          color: AppColors.secondaryTextColor, size: 22.r),
                    ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _iconBg,
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 1.5),
                  ),
                  child: Icon(_icon, color: Colors.white, size: 11.r),
                ),
              ),
            ],
          ),

          SizedBox(width: 12.w),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: notification.title,
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (unread)
                      Container(
                        width: 8.r,
                        height: 8.r,
                        margin: EdgeInsets.only(top: 4.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 3.h),
                CustomText(
                  text: notification.description,
                  fontsize: 12.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  maxline: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.access_time_outlined,
                        color: AppColors.secondaryTextColor, size: 11.r),
                    SizedBox(width: 3.w),
                    CustomText(
                      text: notification.published,
                      fontsize: 10.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: CustomText(
                        text: '• ${notification.sender.name}',
                        fontsize: 10.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                        maxline: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
