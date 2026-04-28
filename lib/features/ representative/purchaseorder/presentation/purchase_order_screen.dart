import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_create_button.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_filter_tab.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_order_card.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_searchbar_widgets.dart';

import '../../appdrawer/app_drawer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/purchase_order_controller.dart';

class PurchaseOrderScreen extends StatelessWidget {
  const PurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseOrderController());

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
      ),

      floatingActionButton: const PoCreateButton(),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Search Bar
            const PoSearchBar(),

            SizedBox(height: 14.h),

            // Filter Tabs
            const PoFilterTabs(),

            SizedBox(height: 16.h),

            // Order List
            Expanded(
              child: Obx(() {
                final orders = controller.filteredOrders;

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
                  itemCount: orders.length,
                  padding: EdgeInsets.only(bottom: 100.h),
                  itemBuilder: (context, index) {
                    return PoCard(order: orders[index]);
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