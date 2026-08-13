import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/appdrawer/app_drawer.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/monthly_commission_trend_card.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/quick_action_card.dart';
import '../../ representative/commissions/presentation/widgets/commission_state_card.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../core/config/app-routes/app_routes.dart';
import 'controller/manager_commission_controller.dart';
import '../manager_bottomnavbar/presentation/widgets/manager_main_bottom_bar.dart';

class CommissionDashboardScreen extends StatelessWidget {
  const CommissionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerCommissionController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const ManagerMainBottomBar(currentIndex: -1, standalone: true),
      drawer: const ManagerAppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: CustomText(
          text: 'Commissions',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: SvgPicture.asset('assets/icons/drawer.svg'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stats ────────────────────────────────────────────────────
            Obx(() {
              if (c.isLoadingStats.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Column(
                    children: [
                      Row(children: [
                        _ShimmerCard(), SizedBox(width: 12.w), _ShimmerCard(),
                      ]),
                      SizedBox(height: 12.h),
                      Row(children: [
                        _ShimmerCard(), SizedBox(width: 12.w), _ShimmerCard(),
                      ]),
                    ],
                  ),
                );
              }
              final s = c.stats;
              return Column(
                children: [
                  Row(children: [
                    CommissionStatCard(label: s[0].label, value: s[0].value, valueColor: s[0].valueColor),
                    SizedBox(width: 12.w),
                    CommissionStatCard(label: s[1].label, value: s[1].value, valueColor: s[1].valueColor),
                  ]),
                  SizedBox(height: 12.h),
                  Row(children: [
                    CommissionStatCard(label: s[2].label, value: s[2].value, valueColor: s[2].valueColor),
                    SizedBox(width: 12.w),
                    CommissionStatCard(label: s[3].label, value: s[3].value, valueColor: s[3].valueColor),
                  ]),
                ],
              );
            }),

            SizedBox(height: 16.h),

            // ── Trend chart ───────────────────────────────────────────────
            Obx(() {
              if (c.isLoadingStats.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              }
              return MonthlyCommissionTrendChart(
                points: c.trendPoints.toList(),
              );
            }),

            SizedBox(height: 20.h),

            CustomText(
              text: 'Quick Actions',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    iconPath: 'assets/icons/cmlist.svg',
                    label: 'CM List',
                    onTap: () => context.push(AppRoutes.commissionListScreen),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: QuickActionCard(
                    iconPath: 'assets/icons/cmmanage.svg',
                    label: 'CM Manage',
                    onTap: () => context.push(AppRoutes.commissionManagementScreen),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
