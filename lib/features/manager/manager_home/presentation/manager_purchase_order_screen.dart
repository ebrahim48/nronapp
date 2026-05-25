import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/manager_po_card.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/manager_po_filter_tabs.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/manager_po_search_bar.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
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

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 14.h),
            const ManagerPOSearchBar(),
            SizedBox(height: 12.h),
            const ManagerPOFilterTabs(),
            SizedBox(height: 14.h),

            // Error banner
            Obx(() {
              if (c.errorMessage.value.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A1A),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFEC0101).withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: const Color(0xFFEC0101), size: 18.r),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: c.errorMessage.value,
                        fontsize: 11.sp,
                        color: const Color(0xFFEC0101),
                        textAlign: TextAlign.start,
                        maxline: 3,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: c.fetchOrders,
                      child: Icon(Icons.refresh, color: AppColors.primaryColor, size: 20.r),
                    ),
                  ],
                ),
              );
            }),

            Expanded(
              child: Obx(() {
                // ── Shimmer ──────────────────────────────────────────
                if (c.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: const Color(0xFF2A2A2A),
                    highlightColor: const Color(0xFF3A3A3A),
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: 6,
                      itemBuilder: (_, __) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        height: 110.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                }

                // ── Empty ────────────────────────────────────────────
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

                // ── List ─────────────────────────────────────────────
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: orders.length,
                  itemBuilder: (context, i) => ManagerPOCard(
                    order: orders[i],
                    onTap: () async {
                      await c.fetchDetail(orders[i].id);
                      if (context.mounted) {
                        context.push(AppRoutes.poReviewScreen);
                      }
                    },
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
