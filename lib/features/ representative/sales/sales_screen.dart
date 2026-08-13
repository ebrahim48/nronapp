import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/sales/presentation/widgets/sales_list_card.dart';
import 'package:nron_app/features/%20representative/sales/presentation/widgets/sales_state_card.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../appdrawer/app_drawer.dart';
import 'all_sales_screen.dart';
import 'controller/sales_controller.dart';
import 'create_sales_screen.dart';
import 'sales_details_screen.dart';
import '../rep_bottomnavbar/presentation/widgets/rep_main_bottom_bar.dart';


class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SaleController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const RepMainBottomBar(currentIndex: -1, standalone: true),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
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
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        backgroundColor: const Color(0xFF1E2427),
        onRefresh: () async {
          await c.fetchOverview();
          await c.fetchSales();
        },
        child: SingleChildScrollView(
          controller: c.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stats Grid ───────────────────────────────────────
              Obx(() {
                if (c.isLoadingOverview.value) return _ShimmerStatGrid();
                return Column(
                  children: [
                    Row(
                      children: [
                        SalesStatCard(
                          label: 'Implant Sales',
                          value: c.implantSales.value
                              .toString()
                              .padLeft(2, '0'),
                          iconPath: 'assets/icons/implantsales.svg',
                        ),
                        SizedBox(width: 12.w),
                        SalesStatCard(
                          label: 'Bio Sales',
                          value:
                              c.bioSales.value.toString().padLeft(2, '0'),
                          iconPath: 'assets/icons/biosales.svg',
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        SalesStatCard(
                          label: 'Total Revenue',
                          value: c.totalRevenue.value
                              .toString()
                              .padLeft(2, '0'),
                          iconPath: 'assets/icons/totalrevenue.svg',
                        ),
                        SizedBox(width: 12.w),
                        SalesStatCard(
                          label: 'Commission',
                          value: c.commission.value
                              .toString()
                              .padLeft(2, '0'),
                          iconPath: 'assets/icons/commisonsales.svg',
                        ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16.h),

              // ── Create Sales button ───────────────────────────────
              CustomButton(
                title: 'Create Sales',
                onpress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateSaleScreen(),
                  ),
                ),
                prefixIcon: SvgPicture.asset(
                  'assets/icons/createsale.svg',
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blackColor,
                    BlendMode.srcIn,
                  ),
                ),
                titlecolor: AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 20.h),

              // ── Recent Sales List ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Recent Sales List',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllSalesScreen(),
                      ),
                    ),
                    child: CustomText(
                      text: 'View All',
                      fontsize: 13.sp,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Obx(() {
                if (c.isLoadingSales.value) {
                  return Column(
                    children: List.generate(
                        4, (_) => _ShimerSaleCard()),
                  );
                }
                if (c.recentSales.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: CustomText(
                        text: 'No sales found.',
                        fontsize: 14.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    ...c.recentSales.map(
                      (sale) => SaleListCard(
                        sale: sale,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SaleDetailScreen(saleId: sale.id),
                          ),
                        ),
                      ),
                    ),
                    if (c.isLoadingMore.value)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                );
              }),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerStatGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Column(
        children: [
          Row(
            children: [
              _shimmerCard(),
              SizedBox(width: 12.w),
              _shimmerCard(),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _shimmerCard(),
              SizedBox(width: 12.w),
              _shimmerCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shimmerCard() => Expanded(
        child: Container(
          height: 88.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
}

class _ShimerSaleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Container(
        height: 72.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
