import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_create_button.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_filter_tab.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_order_card.dart';
import 'package:nron_app/features/%20representative/purchaseorder/presentation/widgets/purchase_searchbar_widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../appdrawer/app_drawer.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/purchase_order_controller.dart';

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _PoShimmerList extends StatelessWidget {
  const _PoShimmerList();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.only(bottom: 100.h),
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
}

// ── Screen ────────────────────────────────────────────────────────────────────

class PurchaseOrderScreen extends StatefulWidget {
  const PurchaseOrderScreen({super.key});

  @override
  State<PurchaseOrderScreen> createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen>
    with RouteAware {
  late final PurchaseOrderController controller;
  bool _firstDepChange = true;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PurchaseOrderController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstDepChange) {
      _firstDepChange = false;
      return; // onInit() already fetched
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) controller.fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                if (controller.isLoading.value) {
                  return const _PoShimmerList();
                }
                final orders = controller.filteredOrders;
                if (orders.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No purchase orders found',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    controller.onScrollNotification(notification);
                    return false;
                  },
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: orders.length + 1,
                    padding: EdgeInsets.only(bottom: 100.h),
                    itemBuilder: (context, index) {
                      if (index == orders.length) {
                        return Obx(() => controller.isLoadingMore.value
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.primaryColor),
                                ),
                              )
                            : const SizedBox.shrink());
                      }
                      final order = orders[index];
                      return PoCard(
                        order: order,
                        onTap: () => context.pushNamed(
                          AppRoutes.purchaseOrderDetailScreen,
                          extra: order.id,
                        ),
                      );
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