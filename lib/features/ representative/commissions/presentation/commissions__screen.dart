import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commission_card.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commission_state_card.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commission_trend_chart.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/commission_controller.dart';
import '../../rep_bottomnavbar/presentation/widgets/rep_main_bottom_bar.dart';

class CommissionScreen extends StatelessWidget {
  const CommissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CommissionController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const RepMainBottomBar(currentIndex: -1, standalone: true),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: CustomText(
          text: 'My Commissions',
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
                child: SizedBox(
                  width: 42.r,
                  height: 42.r,
                  child: Center(
                    child: SvgPicture.asset('assets/icons/drawer.svg'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoadingOverview.value) return _CommissionOverviewShimmer();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommissionStatCard(
                    label: 'Total Sales',
                    value: '\$${c.totalSales.value.toStringAsFixed(2)}',
                    valueColor: AppColors.primaryTextColor,
                  ),
                  SizedBox(width: 12.w),
                  CommissionStatCard(
                    label: 'This Month',
                    value: '\$${c.thisMonth.value.toStringAsFixed(2)}',
                    valueColor: AppColors.primaryTextColor,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  CommissionStatCard(
                    label: 'Pending Payment',
                    value: '\$${c.pendingPayment.value.toStringAsFixed(2)}',
                    valueColor: AppColors.warningColor,
                  ),
                  SizedBox(width: 12.w),
                  CommissionStatCard(
                    label: 'Paid',
                    value: '\$${c.paid.value.toStringAsFixed(2)}',
                    valueColor: const Color(0xFF1DB954),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              CommissionTrendChart(points: c.trendPoints.toList()),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Recent Commissions',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: () =>
                        context.pushNamed(AppRoutes.commissionHistoryScreen),
                    child: CustomText(
                      text: 'View All',
                      fontsize: 13.sp,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              ...c.recentCommissions.map(
                (item) => CommissionCard(
                  commission: item,
                  onTap: () {
                    c.fetchDetail(item.id);
                    context.pushNamed(AppRoutes.commissionDetailScreen);
                  },
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        );
      }),
    );
  }
}

class _CommissionOverviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              children: [
                _ShimmerBox(width: 160.w, height: 72.h, radius: 12.r),
                SizedBox(width: 12.w),
                _ShimmerBox(width: 160.w, height: 72.h, radius: 12.r),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _ShimmerBox(width: 160.w, height: 72.h, radius: 12.r),
                SizedBox(width: 12.w),
                _ShimmerBox(width: 160.w, height: 72.h, radius: 12.r),
              ],
            ),
            SizedBox(height: 16.h),
            _ShimmerBox(width: double.infinity, height: 210.h, radius: 12.r),
            SizedBox(height: 20.h),
            _ShimmerBox(width: double.infinity, height: 70.h, radius: 12.r),
            SizedBox(height: 10.h),
            _ShimmerBox(width: double.infinity, height: 70.h, radius: 12.r),
            SizedBox(height: 10.h),
            _ShimmerBox(width: double.infinity, height: 70.h, radius: 12.r),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox(
      {required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
