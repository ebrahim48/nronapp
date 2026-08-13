import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../appdrawer/app_drawer.dart';
import '../controller/shipments_controller.dart';
import '../model/shipment_model.dart';
import 'create_shipment_job_screen.dart';
import 'job_details_screen.dart';
import 'shipments_list_screen.dart';
import 'track_shipment_screen.dart';
import 'widgets/shipment_card.dart';
import 'widgets/state_card.dart';
import '../../rep_bottomnavbar/presentation/widgets/rep_main_bottom_bar.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  late final ShipmentsController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ShipmentsController());
  }

  @override
  void dispose() {
    Get.delete<ShipmentsController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'Shipments',
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
      body: Obx(() {
        if (_ctrl.isLoading.value) return _shimmer();
        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: const Color(0xFF252525),
          onRefresh: _ctrl.fetchHome,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.trackShipmentScreen);
                        },
                        child: Container(
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 14.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/trackshipment.svg',
                                  width: 36.r,
                                  height: 36.r,
                                ),
                                SizedBox(height: 8.h),
                                CustomText(
                                  maxline: 2,
                                  text: 'Track\nShipment',
                                  fontsize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateShipmentJobScreen(),
                          ),
                        ),
                        child: Container(
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA8A8A8),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 14.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/createshipment.svg',
                                  width: 36.r,
                                  height: 36.r,
                                ),
                                SizedBox(height: 8.h),
                                CustomText(
                                  maxline: 2,
                                  text: 'Create\nShipment',
                                  fontsize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        label: 'Active Jobs',
                        value: _ctrl.activeJobsCount.value.toString().padLeft(2, '0'),
                        valueColor: AppColors.primaryTextColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StatsCard(
                        label: 'Pending Pickup',
                        value: _ctrl.pendingPickupCount.value.toString().padLeft(2, '0'),
                        valueColor: AppColors.warningColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        label: 'In Transit',
                        value: _ctrl.inTransitCount.value.toString().padLeft(2, '0'),
                        valueColor: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StatsCard(
                        label: 'Delivered',
                        value: _ctrl.deliveredCount.value.toString().padLeft(2, '0'),
                        valueColor: const Color(0xFF00D500),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),

                // ── Active Shipments ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Active Shipments',
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShipmentsListScreen(),
                        ),
                      ),
                      child: CustomText(
                        text: 'View All',
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                if (_ctrl.activeShipments.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: CustomText(
                        text: 'No active shipments',
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  )
                else
                  ..._ctrl.activeShipments.map(
                    (s) => ShipmentCard(
                      shipment: s,
                      onTap: () => _openDetails(context, s),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _openDetails(BuildContext context, ShipmentModel s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailsScreen(id: s.id),
      ),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Stats
            Row(
              children: List.generate(2, (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i == 0 ? 6.w : 0, left: i == 1 ? 6.w : 0),
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              )),
            ),
            SizedBox(height: 12.h),
            Row(
              children: List.generate(2, (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i == 0 ? 6.w : 0, left: i == 1 ? 6.w : 0),
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              )),
            ),
            SizedBox(height: 22.h),
            ...List.generate(
              3,
              (_) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
