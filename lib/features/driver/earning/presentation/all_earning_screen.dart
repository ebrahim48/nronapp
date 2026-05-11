import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/earnings_history_list.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/request_pay_button.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/total_balance_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/earnings_controller.dart';

class AllEarningScreen extends StatelessWidget {
  const AllEarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse existing controller if available, otherwise create
    final c = Get.put(EarningsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'All Earnings',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            final isLoading = c.isLoadingSummary.value;
            final s = c.summary.value;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 110.h),
              child: Column(
                children: [
                  // ── Balance card ──────────────────────────────────
                  isLoading
                      ? Shimmer.fromColors(
                          baseColor: const Color(0xFF2A2A2A),
                          highlightColor: const Color(0xFF3A3A3A),
                          child: Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        )
                      : TotalBalanceCard(
                          balance: s.totalBalance,
                          percentChange: 0,
                        ),

                  SizedBox(height: 14.h),

                  // ── History list ──────────────────────────────────
                  Obx(() => c.isLoadingHistory.value
                      ? Shimmer.fromColors(
                          baseColor: const Color(0xFF2A2A2A),
                          highlightColor: const Color(0xFF3A3A3A),
                          child: Column(
                            children: List.generate(
                              5,
                              (_) => Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ),
                        )
                      : EarningsHistoryList(
                          entries: c.historyItems,
                          showViewMore: false,
                          filterValue: c.selectedFilter.value,
                          filterOptions: c.filters,
                          onFilterChanged: c.setFilter,
                        )),
                ],
              ),
            );
          }),

          // ── Request Payout button ─────────────────────────────────
          Positioned(
            bottom: 0,
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
    );
  }
}
