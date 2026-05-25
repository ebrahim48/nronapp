import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/managershipment/presentation/widgets/shipment_card.dart';
import 'package:nron_app/features/manager/managershipment/presentation/widgets/state_card.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipmentcontroller.dart';

class ManagerShipmentsScreen extends StatelessWidget {
  const ManagerShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ShipmentController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const ManagerAppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: CustomText(
            text: 'Shipments',
            fontsize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

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
                      onTap: () { c.fetchAll(); },
                      child: Icon(Icons.refresh, color: AppColors.primaryColor, size: 20.r),
                    ),
                  ],
                ),
              );
            }),

            Obx(() {
              if (c.isLoadingStats.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Column(
                    children: [
                      Row(children: [
                        _ShimmerCard(), SizedBox(width: 12.w), _ShimmerCard(),
                      ]),
                      SizedBox(height: 12.h),
                      Row(children: [
                        _ShimmerCard(), SizedBox(width: 12.w), _ShimmerCard(),
                      ]),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      ShipmentStatCard(
                        label: 'Pending Jobs',
                        value: c.pendingJobs.value.toString().padLeft(2, '0'),
                        valueColor: AppColors.primaryTextColor,
                      ),
                      SizedBox(width: 12.w),
                      ShipmentStatCard(
                        label: 'Driver',
                        value: c.drivers.value.toString().padLeft(2, '0'),
                        valueColor: AppColors.warningColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      ShipmentStatCard(
                        label: 'In Transit',
                        value: c.inTransit.value.toString().padLeft(2, '0'),
                        valueColor: AppColors.primaryColor,
                      ),
                      SizedBox(width: 12.w),
                      ShipmentStatCard(
                        label: 'Delivered',
                        value: c.delivered.value.toString().padLeft(2, '0'),
                        valueColor: const Color(0xFF1DB954),
                      ),
                    ],
                  ),
                ],
              );
            }),

            SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Active Shipments',
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

            // ── Active shipments list ─────────────────────────────────
            Obx(() {
              if (c.isLoadingList.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Column(
                    children: List.generate(
                      3,
                      (_) => Container(
                        margin: EdgeInsets.only(bottom: 14.h),
                        height: 160.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                );
              }

              final list = c.allShipments.isNotEmpty
                  ? c.allShipments
                  : c.activeShipments;

              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: CustomText(
                      text: 'No shipments found.',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Column(
                children: list
                    .map((s) => ActiveShipmentCard(
                          shipment: s,
                          onTap: () async {
                            await c.fetchDetail(s.id);
                            if (context.mounted) {
                              context.push(AppRoutes.jobReviewScreen);
                            }
                          },
                        ))
                    .toList(),
              );
            }),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
