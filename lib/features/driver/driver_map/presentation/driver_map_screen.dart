import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/delivery_progress_tracker.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/destination_card.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/eta_distance_bar.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/map_action_buttons.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/route_stop_list.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/driver_map_controller.dart';

class DriverMapScreen extends StatelessWidget {
  final String? jobId;

  const DriverMapScreen({super.key, this.jobId});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DriverMapController());

    // Initialize with jobId if provided
    if (jobId != null && jobId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        c.fetchJobForMap(jobId!);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        final job = c.mapJob.value;

        return Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Obx(() => GoogleMap(
                        onMapCreated: c.onMapCreated,
                        initialCameraPosition:
                            DriverMapController.initialCamera,
                        markers: c.markers.value,
                        polylines: c.polylines.value,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                      )),

                  if (job != null)
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: EtaDistanceBar(
                          eta: job.etaToPickup.isEmpty
                              ? '0 mins'
                              : job.etaToPickup,
                          distance: job.distanceMi.isEmpty
                              ? '0 km'
                              : job.distanceMi,
                        ),
                      ),
                    ),

                  Positioned(
                    right: 12.w,
                    bottom: 20.h,
                    child: const MapActionButtons(),
                  ),

                  if (c.isLoading.value)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              flex: 6,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
                        width: 36.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A3A3A),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    Expanded(
                      child: job == null
                          ? _buildShimmer()
                          : SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 6.h),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: 'Shipment ID',
                                            fontsize: 10.sp,
                                            color: AppColors
                                                .secondaryTextColor,
                                            textAlign: TextAlign.start,
                                          ),
                                          CustomText(
                                            text: job.shipmentId,
                                            fontsize: 18.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors
                                                .primaryTextColor,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.warningColor
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  20.r),
                                        ),
                                        child: Text(
                                          job.status,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color:
                                                AppColors.warningColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 14.h),

                                  RouteStopsList(
                                    pickup: job.pickup,
                                    intermediate: job.intermediate,
                                  ),

                                  SizedBox(height: 10.h),

                                  DestinationCard(
                                    destinationName:
                                        job.destination.name,
                                    onCall: c.callDestination,
                                  ),

                                  SizedBox(height: 14.h),

                                  GestureDetector(
                                    onTap: c.arrivedAtDestination,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                              Icons
                                                  .location_on_outlined,
                                              color:
                                                  AppColors.blackColor,
                                              size: 18.r),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Arrived at Destination',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight:
                                                  FontWeight.w700,
                                              color:
                                                  AppColors.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  GestureDetector(
                                    onTap: () =>
                                        c.markAsDelivered(context),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color(0xFF2A2A2A),
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                        border: Border.all(
                                            color: const Color(
                                                0xFF3A3A3A)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Mark as Delivered',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color: AppColors
                                                .primaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 14.h),

                                  Obx(() => DeliveryProgressTracker(
                                        currentStatus:
                                            c.currentProgress.value,
                                      )),

                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: List.generate(
            4,
            (_) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
