import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app-routes/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/services/socket_service.dart';
import '../../controller/rep_header_controller.dart';

class RepHeader extends StatelessWidget {
  const RepHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RepHeaderController());

    return SizedBox(
      width: 345.w,
      height: 52.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              // Avatar
              Obx(() {
                final url = c.imageUrl.value;
                return Container(
                  width: 54.r,
                  height: 54.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: url.isNotEmpty
                        ? Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _defaultAvatar(),
                          )
                        : _defaultAvatar(),
                  ),
                );
              }),

              SizedBox(width: 10.w),

              // Greeting + name
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Good Morning,',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: c.isLoading.value
                          ? '...'
                          : c.name.value.isNotEmpty
                              ? c.name.value
                              : 'User',
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                );
              }),
            ],
          ),

          Row(
            children: [
              // Notification icon with red dot badge
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.notificationScreen),
                child: SizedBox(
                  width: 42.r,
                  height: 42.r,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/icons/notification.svg',
                          width: 26.r,
                          height: 26.r,
                        ),
                      ),
                      Obx(() {
                        final show = Get.isRegistered<SocketService>() &&
                            SocketService.instance.hasUnread.value;
                        if (!show) return const SizedBox.shrink();
                        return Positioned(
                          top: 6.h,
                          right: 6.w,
                          child: Container(
                            width: 7.r,
                            height: 7.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF2828),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.backgroundColor,
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 3,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 8.w),
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: SizedBox(
                    width: 42.r,
                    height: 42.r,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/drawer.svg',
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: const Icon(Icons.person, color: Colors.white54),
    );
  }
}
