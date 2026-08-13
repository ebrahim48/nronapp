import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/manager_expense_filter_tabs.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/repense_review_card.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/sync_qb_banner.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_expense_controller.dart';
import '../../manager_bottomnavbar/presentation/widgets/manager_main_bottom_bar.dart';

class ManagerExpenseScreen extends StatelessWidget {
  const ManagerExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerExpenseController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const ManagerMainBottomBar(currentIndex: -1, standalone: true),
      drawer: const ManagerAppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: CustomText(
          text: 'Expenses',
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: const ManagerExpenseFilterTabs(),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.primaryTextColor.withValues(alpha: 0.08),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),

            // Sync to QB banner
            const SyncToQBBanner(),

            SizedBox(height: 16.h),

            // Header row
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Expense Reviews',
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        '${c.totalItems} Items',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                )),

            SizedBox(height: 10.h),

            // List
            Expanded(
              child: Obx(() {

                if (c.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: const Color(0xFF2A2A2A),
                    highlightColor: const Color(0xFF3A3A3A),
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: 6,
                      itemBuilder: (_, __) => Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        height: 88.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                }


                if (c.filteredExpenses.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No expenses found',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  );
                }


                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: c.filteredExpenses.length,
                  itemBuilder: (context, i) {
                    final expense = c.filteredExpenses[i];
                    return ExpenseReviewCard(
                      expense: expense,
                      onTap: () async {
                        await c.fetchExpenseDetail(expense.id);
                        if (context.mounted) {
                          context.push(AppRoutes.managerExpenseDetailScreen);
                        }
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
