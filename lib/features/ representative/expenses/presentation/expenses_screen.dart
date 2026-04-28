import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
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

            // Search Bar
            const ExpenseSearchBar(),

            SizedBox(height: 12.h),

            // Create Expense Button
            const ExpenseCreateButton(),

            SizedBox(height: 16.h),

            // Expense List
            Expanded(
              child: Obx(() {
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
                  itemCount: expenses.length,
                  padding: EdgeInsets.only(bottom: 30.h),
                  itemBuilder: (context, index) {
                    return ExpenseCard(
                      expense: expenses[index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpenseDetailScreen(
                              expense: expenses[index]),
                        ),
                      ),
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