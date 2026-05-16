import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../controller/notification_controller.dart';
import 'notification_tile.dart';

class NotificationList extends StatefulWidget {
  final NotificationController controller;
  const NotificationList({super.key, required this.controller});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 150) {
        widget.controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    return RefreshIndicator(
      onRefresh: c.fetchNotifications,
      color: AppColors.primaryColor,
      child: Obx(() => ListView.separated(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: c.notifications.length + (c.isLoadingMore.value ? 1 : 0),
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 0.5,
              color: const Color(0xFF2A2A2A),
            ),
            itemBuilder: (_, i) {
              if (i == c.notifications.length) {
                return Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                );
              }
              return NotificationTile(notification: c.notifications[i]);
            },
          )),
    );
  }
}
