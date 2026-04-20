import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/earnings_history_list.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/earnings_stats_card.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/request_pay_button.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/total_balance_card.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/weekly_overview_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/earnings_controller.dart';
import 'all_earning_screen.dart';


class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final _ctrl = EarningsController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _ctrl.summary;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                            16.w, 0, 16.w, 110.h),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // Total Balance
                            TotalBalanceCard(
                              balance: s.totalBalance,
                              percentChange:
                              s.percentChangeFromLastWeek,
                            ),
                            SizedBox(height: 14.h),

                            // Stats grid
                            EarningsStatsGrid(
                              todayEarnings: s.todayEarnings,
                              todayDeliveries: s.todayDeliveries,
                              thisWeekEarnings: s.thisWeekEarnings,
                              thisWeekDeliveries:
                              s.thisWeekDeliveries,
                              pendingEarnings: s.pendingEarnings,
                              pendingDeliveries:
                              s.pendingDeliveries,
                              totalPaid: s.totalPaid,
                              totalDeliveries: s.totalDeliveries,
                            ),
                            SizedBox(height: 14.h),

                            // Weekly chart
                            WeeklyOverviewChart(
                              bars: s.weeklyBars,
                              onExport: () {},
                            ),
                            SizedBox(height: 14.h),

                            EarningsHistoryList(
                              entries: _ctrl.recentHistory,
                              showViewMore: true,
                              onViewMore: () =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const AllEarningScreen(),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 60.h, // above bottom nav
                left: 0,
                right: 0,
                child: RequestPayoutButton(
                  amount: s.pendingPayoutAmount,
                  loading: _ctrl.isLoading,
                  onTap: () async {
                    await _ctrl.requestPayout();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Payout request submitted!'),
                          backgroundColor: AppColors.primaryColor,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

