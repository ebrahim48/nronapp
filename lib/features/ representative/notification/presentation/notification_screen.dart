import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/notification_controller.dart';
import 'widgets/notification_list.dart';
import 'widgets/notification_shimmer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 56.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Notifications',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),

      body: Obx(() {
        if (c.isLoading.value) return const NotificationShimmerList();

        if (c.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined,
                    color: AppColors.secondaryTextColor, size: 52.r),
                SizedBox(height: 14.h),
                CustomText(
                  text: 'No notifications yet',
                  fontsize: 14.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return NotificationList(controller: c);
      }),
    );
  }
}
