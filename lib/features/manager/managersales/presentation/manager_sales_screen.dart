import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/manager_sales_card.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_filter_chips.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_search_bar.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_sales_controller.dart';


class ManagerSalesScreen extends StatelessWidget {
  const ManagerSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerSaleController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const ManagerAppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: CustomText(
          text: 'Sales',
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),
            const SalesSearchBar(),
            SizedBox(height: 12.h),
            const SalesFilterChips(),
            SizedBox(height: 16.h),
            CustomText(
              text: 'Recent Sales List',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                final list = c.filteredSales;
                if (list.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No sales found',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: list.length,
                  itemBuilder: (context, i) => ManagerSaleCard(
                    sale: list[i],
                    onTap: () => context.push(AppRoutes.managerSaleDetailScreen),
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