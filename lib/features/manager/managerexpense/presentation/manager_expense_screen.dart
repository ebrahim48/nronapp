import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/manager_expense_filter_tabs.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/repense_review_card.dart';
import 'package:nron_app/features/manager/managerexpense/presentation/widgets/sync_qb_banner.dart';
import '../../../ representative/appdrawer/app_drawer.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_expense_controller.dart';


class ManagerExpenseScreen extends StatelessWidget {
  const ManagerExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerExpenseController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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

            // Expense Reviews header
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
                    color: AppColors.primaryColor
                        .withValues(alpha: 0.12),
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
                final list = c.filteredExpenses;
                if (list.isEmpty) {
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
                  itemCount: list.length,
                  itemBuilder: (context, i) => ExpenseReviewCard(
                    expense: list[i],
                    onTap: () => context.push(AppRoutes.managerExpenseDetailScreen),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}