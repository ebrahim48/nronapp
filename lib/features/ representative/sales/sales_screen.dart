import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/sales/presentation/widgets/sales_list_card.dart';
import 'package:nron_app/features/%20representative/sales/presentation/widgets/sales_state_card.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../core/config/app-routes/app_routes.dart';
import '../appdrawer/app_drawer.dart';
import 'controller/sales_controller.dart';


class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SaleController());

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stats Grid ───────────────────────────────────────
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    SalesStatCard(
                      label: 'Implant Sales',
                      value: c.implantSales.value.toString().padLeft(2, '0'),
                      iconPath: 'assets/icons/implantsales.svg',
                    ),
                    SizedBox(width: 12.w),
                    SalesStatCard(
                      label: 'Bio Sales',
                      value: c.bioSales.value.toString().padLeft(2, '0'),
                      iconPath: 'assets/icons/biosales.svg',
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    SalesStatCard(
                      label: 'Total Revenue',
                      value: c.totalRevenue.value.toString().padLeft(2, '0'),
                      iconPath: 'assets/icons/totalrevenue.svg',
                    ),
                    SizedBox(width: 12.w),
                    SalesStatCard(
                      label: 'Commission',
                      value: c.commission.value.toString().padLeft(2, '0'),
                      iconPath: 'assets/icons/commisonsales.svg',
                    ),
                  ],
                ),
              ],
            )),

            SizedBox(height: 16.h),

            // ── Create Sales button ───────────────────────────────
            CustomButton(
              title: 'Create Sales',
              onpress: () => context.pushNamed(AppRoutes.createSaleScreen),
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
                  onTap: () {},
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

            Obx(() => Column(
              children: c.recentSales
                  .map(
                    (sale) => SaleListCard(
                  sale: sale,
                  onTap: () => context.pushNamed(
                    AppRoutes.saleDetailScreen,
                  ),
                ),
              )
                  .toList(),
            )),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}