import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/actitvity_log_controller.dart';
import 'widgets/activity_log_widgets.dart';
import '../../../../core/custom_widgets/role_aware_bottom_bar.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Container(
        width: double.infinity,
        height: 130.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  Widget _buildShimmerChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF2A2A2A),
        highlightColor: const Color(0xFF3A3A3A),
        child: Row(
          children: List.generate(
            4,
            (_) => Container(
              width: 70.w,
              height: 30.h,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ActivityLogController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const RoleAwareBottomBar(),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 24.w,
        title: CustomText(
          text: 'Activity Log',
          fontsize: 22.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 24.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: SvgPicture.asset('assets/icons/drawer.svg'),
              ),
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await c.fetchLogs();
        },
        color: AppColors.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Module filter ──────────────────────────────────────────
              Row(
                children: [
                  CustomText(
                    text: 'MODULE:',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(() {
                      if (c.isLoadingModules.value) {
                        return _buildShimmerChips();
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: c.modules.map((m) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: ActivityFilterChip(
                                label: m,
                                isActive: c.selectedModule.value == m,
                                onTap: () => c.selectModule(m),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // ── Log list ───────────────────────────────────────────────
              Obx(() {
                if (c.isLoading.value) {
                  return Column(
                    children: List.generate(5, (_) => _buildShimmerCard()),
                  );
                }

                if (c.logs.isEmpty) {
                  return SizedBox(
                    height: 300.h,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_outlined,
                              color: AppColors.secondaryTextColor, size: 48.r),
                          SizedBox(height: 12.h),
                          CustomText(
                            text: 'No activity found',
                            fontsize: 14.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: c.logs
                      .map((log) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: ActivityLogCard(
                              log: log,
                              onTap: () => context.pushNamed(
                                AppRoutes.activityLogDetailScreen,
                                extra: log,
                              ),
                            ),
                          ))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
