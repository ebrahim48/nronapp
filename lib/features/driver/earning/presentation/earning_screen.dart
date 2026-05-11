import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/earnings_history_list.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/earnings_stats_card.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/request_pay_button.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/total_balance_card.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/weekly_overview_chart.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/earnings_controller.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 110.h),
        child: Column(
          children: [
            // Balance card
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            SizedBox(height: 14.h),
            // Stats grid
            Row(children: [
              Expanded(child: Container(height: 90.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)))),
              SizedBox(width: 12.w),
              Expanded(child: Container(height: 90.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)))),
            ]),
            SizedBox(height: 12.h),
            Row(children: [
              Expanded(child: Container(height: 90.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)))),
              SizedBox(width: 12.w),
              Expanded(child: Container(height: 90.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)))),
            ]),
            SizedBox(height: 14.h),
            // Chart
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            SizedBox(height: 14.h),
            // History
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EarningsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Header ─────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Earnings',
                        fontsize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFF252525),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: AppColors.primaryTextColor,
                              size: 20.r,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10.r,
                              height: 10.r,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.backgroundColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Body ───────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    if (c.isLoadingSummary.value) return _buildShimmer();

                    final s = c.summary.value;

                    return RefreshIndicator(
                      onRefresh: () async {
                        await c.fetchSummary();
                        await c.fetchHistory();
                      },
                      color: AppColors.primaryColor,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding:
                            EdgeInsets.fromLTRB(16.w, 0, 16.w, 110.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TotalBalanceCard(
                              balance: s.totalBalance,
                              percentChange: 0,
                            ),
                            SizedBox(height: 14.h),

                            EarningsStatsGrid(
                              todayEarnings: s.todayEarnings,
                              todayDeliveries: s.todayDeliveries,
                              thisWeekEarnings: s.thisWeekEarnings,
                              thisWeekDeliveries: s.thisWeekDeliveries,
                              pendingEarnings: s.pendingEarnings,
                              pendingDeliveries: s.pendingDeliveries,
                              totalPaid: s.totalPaid,
                              totalDeliveries: s.totalPaidDeliveries,
                            ),
                            SizedBox(height: 14.h),

                            if (s.weeklyBars.isNotEmpty) ...[
                              WeeklyOverviewChart(
                                bars: s.weeklyBars,
                                onExport: () {},
                              ),
                              SizedBox(height: 14.h),
                            ],

                            Obx(() => c.isLoadingHistory.value
                                ? Shimmer.fromColors(
                                    baseColor: const Color(0xFF2A2A2A),
                                    highlightColor:
                                        const Color(0xFF3A3A3A),
                                    child: Container(
                                      height: 180.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                      ),
                                    ),
                                  )
                                : EarningsHistoryList(
                                    entries: c.recentHistory,
                                    showViewMore: true,
                                    onViewMore: () => context.pushNamed(
                                        AppRoutes.allEarningScreen),
                                  )),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            // ── Request Payout button ───────────────────────────────
            Positioned(
              bottom: 60.h,
              left: 0,
              right: 0,
              child: Obx(() => RequestPayoutButton(
                    amount: c.summary.value.pendingPayoutAmount,
                    loading: c.isRequestingPayout.value,
                    onTap: () => c.requestPayout(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
