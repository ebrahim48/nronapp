import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/expense_card.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/expense_create_button.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/expense_filter_tabs.dart';
import 'package:nron_app/features/%20representative/expenses/presentation/widgets/expense_search_bar.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/expense_controller.dart';
import 'expense_details_screen.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpenseController());

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(42.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.centerLeft,
            child: const ExpenseFilterTabs(),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            const ExpenseSearchBar(),
            SizedBox(height: 12.h),
            const ExpenseCreateButton(),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _ExpenseListShimmer();
                }

                final expenses = controller.filteredExpenses;

                if (expenses.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No expenses found',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: expenses.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  padding: EdgeInsets.only(bottom: 30.h),
                  itemBuilder: (context, index) {
                    if (index == expenses.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      );
                    }
                    return ExpenseCard(
                      expense: expenses[index],
                      onTap: () {
                        controller.fetchDetail(expenses[index].id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExpenseDetailScreen(
                                expenseId: expenses[index].id),
                          ),
                        );
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

class _ExpenseListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.only(bottom: 30.h),
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 90.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
