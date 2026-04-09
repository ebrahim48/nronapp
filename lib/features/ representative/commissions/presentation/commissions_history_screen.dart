import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commission_card.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/commissions_history_filter_tabs.dart';
import 'package:nron_app/features/%20representative/commissions/presentation/widgets/history_group_header.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/commission_controller.dart';


class CommissionHistoryScreen extends StatelessWidget {
  const CommissionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CommissionController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Commission History',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: const CommissionHistoryFilterTabs(),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 345.w,
                height: 1,
                color: const Color(0xFFD4D4D4),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        final groups = c.filteredGroups;

        if (groups.isEmpty) {
          return Center(
            child: CustomText(
              text: 'No commissions found',
              fontsize: 14.sp,
              color: AppColors.secondaryTextColor,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: groups.length,
          itemBuilder: (context, gi) {
            final group = groups[gi];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistoryGroupHeader(label: group.dateLabel),
                ...group.items.map(
                      (item) => CommissionCard(
                    commission: item,
                    onTap: () => context.pushNamed(
                        AppRoutes.commissionDetailScreen),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            );
          },
        );
      }),
    );
  }
}