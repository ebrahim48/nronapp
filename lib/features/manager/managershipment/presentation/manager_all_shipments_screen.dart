import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/managershipment/presentation/widgets/shipment_card.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipmentcontroller.dart';
import '../model/shipment_model.dart';

class ManagerAllShipmentsScreen extends StatelessWidget {
  const ManagerAllShipmentsScreen({super.key});

  static const _filters = <ShipmentStatus?>[
    null,
    ShipmentStatus.pending,
    ShipmentStatus.inTransit,
    ShipmentStatus.delivered,
  ];
  static const _labels = ['All', 'Pending', 'In Transit', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<ShipmentController>()
        ? Get.find<ShipmentController>()
        : Get.put(ShipmentController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'All Shipments',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status chips ─────────────────────────────────────────────
          SizedBox(
            height: 36.h,
            child: Obx(() {
              // Read here: itemBuilder runs lazily, outside Obx's tracking.
              final current = c.listFilter.value;
              return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (_, i) {
                    final selected = current == _filters[i];
                    return GestureDetector(
                      onTap: () => c.listFilter.value = _filters[i],
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: selected
                                ? AppColors.primaryColor
                                : const Color(0xFF3A3A3A),
                          ),
                        ),
                        child: Text(
                          _labels[i],
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected
                                ? AppColors.blackColor
                                : AppColors.secondaryTextColor,
                          ),
                        ),
                      ),
                    );
                  },
                );
            }),
          ),
          SizedBox(height: 14.h),

          // ── List ─────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (c.isLoadingList.value && c.allShipments.isEmpty) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 4,
                    itemBuilder: (_, __) => Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      height: 160.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                );
              }

              final list = c.filteredAllShipments;
              return RefreshIndicator(
                color: AppColors.primaryColor,
                backgroundColor: const Color(0xFF1E2427),
                onRefresh: c.refreshAll,
                child: list.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 120.h),
                          Center(
                            child: CustomText(
                              text: 'No shipments found.',
                              fontsize: 14.sp,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        controller: c.allScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                        itemCount:
                            list.length + (c.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i == list.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Center(
                                child: SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryColor),
                                ),
                              ),
                            );
                          }
                          final s = list[i];
                          return ActiveShipmentCard(
                            shipment: s,
                            onTap: () async {
                              await c.fetchDetail(s.id);
                              if (context.mounted) {
                                context.push(AppRoutes.jobReviewScreen);
                              }
                            },
                          );
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
