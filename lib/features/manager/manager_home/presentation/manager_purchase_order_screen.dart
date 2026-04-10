import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/manager_po_card.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/manager_po_filter_tabs.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/manager_po_search_bar.dart';
import '../../../ representative/appdrawer/app_drawer.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../appdrawer/app_drawer.dart';
import '../manager_controller/manager_po_controller.dart';


class ManagerPurchaseOrderScreen extends StatelessWidget {
  const ManagerPurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerPOController());

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
          text: 'Purchase Orders',
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.centerLeft,
            child: const ManagerPOFilterTabs(),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 14.h),
            const ManagerPOSearchBar(),
            SizedBox(height: 14.h),
            Expanded(
              child: Obx(() {
                final orders = c.filteredOrders;
                if (orders.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No orders found',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: orders.length,
                  itemBuilder: (context, i) => ManagerPOCard(
                    order: orders[i],
                    onTap: () => context.push(AppRoutes.poReviewScreen),
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