import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/app-routes/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/rep_home_controller.dart';
import '../../data/model/rep_home_model.dart';

class RepWideCard extends StatelessWidget {
  const RepWideCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RepHomeController>();

    return Obx(() {
      if (c.isLoading.value) return const _ActivityShimmer();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Recent Activity',
                fontsize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              GestureDetector(
                onTap: () => context.push(AppRoutes.allActivitiesScreen),
                child: CustomText(
                  text: 'View All',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          c.activities.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: CustomText(
                      text: 'No recent activity',
                      fontsize: 13.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: c.activities
                      .map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _ActivityItem(activity: item),
                          ))
                      .toList(),
                ),
        ],
      );
    });
  }
}

class _ActivityShimmer extends StatelessWidget {
  const _ActivityShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Column(
        children: List.generate(
          2,
          (_) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 72.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final RecentActivity activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isCreate = activity.action.toUpperCase() == 'CREATE';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A25292A),
            blurRadius: 1,
            offset: Offset(0.5, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                isCreate ? 'assets/icons/click.svg' : 'assets/icons/dots.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: activity.title,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: activity.description,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  maxline: 2,
                  textHeight: 1.4,
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: activity.timeAgo,
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 6.h),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isCreate
                      ? const Color(0x9900D500)
                      : const Color(0xFFE6A817).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: activity.action,
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
