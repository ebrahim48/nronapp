import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/low_stack_alert_card.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/manager_state_card.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/org_performance_chart.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/pending_approval_card.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/team_activity_tile.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../appdrawer/app_drawer.dart';
import '../manager_controller/manager_home_controller.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerHomeController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const ManagerAppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage:
                  const AssetImage('assets/images/profile.jpg'),
              backgroundColor: const Color(0xFF3A3A3A),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Good Morning,',
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                Obx(() => CustomText(
                      text: c.userName.value.isNotEmpty
                          ? c.userName.value
                          : 'Manager',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    )),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.notificationScreen),
            icon: Icon(Icons.notifications_outlined,
                color: AppColors.primaryTextColor, size: 22.r),
          ),
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 12.w),
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

            // Error banner
            Obx(() {
              if (c.errorMessage.value.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A1A),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFEC0101).withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: const Color(0xFFEC0101), size: 18.r),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: c.errorMessage.value,
                        fontsize: 11.sp,
                        color: const Color(0xFFEC0101),
                        textAlign: TextAlign.start,
                        maxline: 3,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: c.fetchOverview,
                      child: Icon(Icons.refresh, color: AppColors.primaryColor, size: 20.r),
                    ),
                  ],
                ),
              );
            }),

            Obx(() {
              if (c.isLoading.value) {
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
                    ManagerStatCard(stat: s[0]),
                    SizedBox(width: 12.w),
                    ManagerStatCard(stat: s[1]),
                  ]),
                  SizedBox(height: 12.h),
                  Row(children: [
                    ManagerStatCard(stat: s[2]),
                    SizedBox(width: 12.w),
                    ManagerStatCard(stat: s[3]),
                  ]),
                ],
              );
            }),

            SizedBox(height: 16.h),


            Obx(() => PendingApprovalCard(
                  poCount: c.pendingPOs.value,
                  expenseCount: c.pendingExpenses.value,
                  onReviewNow: () =>
                      context.push(AppRoutes.managerPurchaseOrderScreen),
                )),

            SizedBox(height: 12.h),

            Obx(() => LowStockAlertCard(
                  itemCount: c.lowStockCount.value,
                  onViewInventory: () {},
                )),

            SizedBox(height: 16.h),


            Obx(() {
              if (c.isLoading.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Container(
                    height: 260.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              }
              return const OrgPerformanceChart();
            }),

            SizedBox(height: 20.h),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Recent Team Activity',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Obx(() {
              if (c.isLoading.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              }

              if (c.teamActivity.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Center(
                    child: CustomText(
                      text: 'No recent activity.',
                      fontsize: 13.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2121),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border(
                    left: BorderSide(
                        color: const Color(0xFFD4D4D4), width: 1),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A25292A),
                      offset: Offset(0.5, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: c.teamActivity
                      .asMap()
                      .entries
                      .map((e) => TeamActivityTile(
                            activity: e.value,
                            isLast:
                                e.key == c.teamActivity.length - 1,
                          ))
                      .toList(),
                ),
              );
            }),

            SizedBox(height: 10.h),

            Center(
              child: GestureDetector(
                onTap: () {},
                child: CustomText(
                  text: 'View all activity',
                  fontsize: 13.sp,
                  color: AppColors.primaryColor,
                ),
              ),
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
        height: 90.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
