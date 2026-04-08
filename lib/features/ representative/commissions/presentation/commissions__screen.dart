import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commission_card.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commission_state_card.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commission_trend_chart.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/commission_controller.dart';


class CommissionScreen extends StatelessWidget {
  const CommissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CommissionController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    CommissionStatCard(
                      label: 'Total Sales',
                      value: '\$${c.totalSales.value.toInt()}',
                      valueColor: AppColors.primaryTextColor,
                    ),
                    SizedBox(width: 12.w),
                    CommissionStatCard(
                      label: 'This Month',
                      value: '\$${c.thisMonth.value.toInt()}',
                      valueColor: AppColors.primaryTextColor,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    CommissionStatCard(
                      label: 'Pending Payment',
                      value: '\$${c.pendingPayment.value.toInt()}',
                      valueColor: AppColors.warningColor,
                    ),
                    SizedBox(width: 12.w),
                    CommissionStatCard(
                      label: 'Paid',
                      value: '\$${c.paid.value.toInt()}',
                      valueColor: const Color(0xFF1DB954),
                    ),
                  ],
                ),
              ],
            )),

            SizedBox(height: 16.h),

            CommissionTrendChart(points: c.trendPoints),

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
                  onTap: () {
                    context.pushNamed(AppRoutes.commissionHistoryScreen);
                  },
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

            Obx(() => Column(
              children: c.recentCommissions
                  .map(
                    (item) => CommissionCard(
                  commission: item,
                  onTap: () {
                    context.pushNamed(AppRoutes.commissionDetailScreen);
                  },
                ),
              )
                  .toList(),
            )),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}