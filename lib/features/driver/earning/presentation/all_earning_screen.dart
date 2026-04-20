import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/earnings_history_list.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/request_pay_button.dart';
import 'package:nron_app/features/driver/earning/presentation/widgets/total_balance_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/earnings_controller.dart';


class AllEarningScreen extends StatefulWidget {
  const AllEarningScreen({super.key});

  @override
  State<AllEarningScreen> createState() => _AllEarningScreenState();
}

class _AllEarningScreenState extends State<AllEarningScreen> {
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
          text: 'All Earning',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16.w, 8.h, 16.w, 110.h),
                child: Column(
                  children: [
                    TotalBalanceCard(
                      balance: s.totalBalance,
                      percentChange: s.percentChangeFromLastWeek,
                    ),
                    SizedBox(height: 14.h),

                    EarningsHistoryList(
                      entries: _ctrl.filteredHistory,
                      showViewMore: false,
                      filterValue: _ctrl.selectedFilter,
                      filterOptions: _ctrl.filters,
                      onFilterChanged: _ctrl.setFilter,
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
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