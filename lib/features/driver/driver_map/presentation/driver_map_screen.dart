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

class DriverMapScreen extends StatefulWidget {
  final String? jobId;

  const DriverMapScreen({super.key, this.jobId});

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  final c = Get.put(DriverMapController());

  @override
  void initState() {
    super.initState();
    // Fetch once here (not in build) so rebuilds don't refetch the job.
    final jobId = widget.jobId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (jobId != null && jobId.isNotEmpty) {
        c.fetchJobForMap(jobId);
      } else if (c.mapJob.value == null) {
        c.loadActiveJob();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => EtaDistanceBar(
                                  eta: c.etaToPickup.value,
                                  distance: c.distanceToPickup.value,
                                )),
                            SizedBox(height: 8.h),
                            Obx(() => _LocationBadge(
                                  status: c.locationStatus.value,
                                )),
                          ],
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
                          ? (c.hasNoActiveJob.value
                              ? _buildEmptyState()
                              : _buildShimmer())
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

                                  // Arrived at Destination
                                  Obx(() => GestureDetector(
                                    onTap: c.isArrivingAtDestination.value
                                        ? null
                                        : c.arrivedAtDestination,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(30.r),
                                      ),
                                      child: c.isArrivingAtDestination.value
                                          ? Center(
                                              child: SizedBox(
                                                width: 20.r,
                                                height: 20.r,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.location_on_outlined,
                                                    color: AppColors.blackColor,
                                                    size: 18.r),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  'Arrived at Destination',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  )),

                                  SizedBox(height: 10.h),

                                  // Mark as Delivered — navigate only, no loader
                                  GestureDetector(
                                    onTap: () => c.markAsDelivered(context),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A2A2A),
                                        borderRadius: BorderRadius.circular(30.r),
                                        border: Border.all(color: const Color(0xFF3A3A3A)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Mark as Delivered',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryTextColor,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping_outlined,
              color: AppColors.secondaryTextColor, size: 42.r),
          SizedBox(height: 10.h),
          CustomText(
            text: 'No active delivery',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: 'Accept a job to see its route here',
            fontsize: 11.sp,
            color: AppColors.secondaryTextColor,
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: c.loadActiveJob,
            child: CustomText(
              text: 'Refresh',
              fontsize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
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

class _LocationBadge extends StatelessWidget {
  final String status;
  const _LocationBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isLive = status == 'Live';
    final isUpdated = status.startsWith('Updated');
    final color = isUpdated
        ? const Color(0xFF22C55E)
        : isLive
            ? const Color(0xFF3B82F6)
            : const Color(0xFFF59E0B);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseDot(color: color, animate: isLive),
          SizedBox(width: 6.w),
          Text(
            status,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  final bool animate;
  const _PulseDot({required this.color, required this.animate});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    if (widget.animate) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_PulseDot old) {
    super.didUpdateWidget(old);
    if (widget.animate && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.animate) {
      _ctrl.stop();
      _ctrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: widget.animate ? _scale.value : 1.0,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
