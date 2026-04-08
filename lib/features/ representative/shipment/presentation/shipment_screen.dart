import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nron_app/features/%20representative/shipment/presentation/shipments_list_screen.dart';
import 'package:nron_app/features/%20representative/shipment/presentation/track_shipment_screen.dart';
import 'package:nron_app/features/%20representative/shipment/presentation/widgets/shipment_card.dart';
import 'package:nron_app/features/%20representative/shipment/presentation/widgets/state_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../appdrawer/app_drawer.dart';
import '../controller/shipments_controller.dart';
import 'create_shipment_job_screen.dart';
import 'job_details_screen.dart';


class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final _controller = ShipmentsController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Track Shipment
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TrackShipmentScreen(),
                          ),
                        ),
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
                    // Create Shipment
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
                        value: _controller.activeJobsCount
                            .toString()
                            .padLeft(2, '0'),
                        valueColor: AppColors.primaryTextColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StatsCard(
                        label: 'Pending Pickup',
                        value: _controller.pendingPickupCount
                            .toString()
                            .padLeft(2, '0'),
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
                        value: _controller.inTransitCount
                            .toString()
                            .padLeft(2, '0'),
                        valueColor: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StatsCard(
                        label: 'Delivered',
                        value: _controller.deliveredCount
                            .toString()
                            .padLeft(2, '0'),
                        valueColor: const Color(0xFF00D500),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),

                // ── Active Shipments ─────────────────────────────────────────
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
                ..._controller.activeShipments.map(
                      (s) => ShipmentCard(
                    shipment: s,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(shipment: s),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}