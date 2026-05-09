import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipmentcontroller.dart';
import '../model/shipment_model.dart';
import 'widgets/job_status_header.dart';

class JobReviewScreen extends StatelessWidget {
  const JobReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ShipmentController>();

    return Obx(() {
      if (c.isLoadingDetail.value) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E2427),
            elevation: 0,
            toolbarHeight: 52.h,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios,
                  color: AppColors.primaryTextColor, size: 18.r),
            ),
            title: CustomText(
              text: 'Job Details',
              fontsize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          body: Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 140.h),
              child: Column(
                children: List.generate(
                  5,
                  (_) => Container(
                    margin: EdgeInsets.only(bottom: 14.h),
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      final s = c.selectedShipment.value;
      if (s == null) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E2427),
            elevation: 0,
            toolbarHeight: 52.h,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios,
                  color: AppColors.primaryTextColor, size: 18.r),
            ),
            title: CustomText(
              text: 'Job Details',
              fontsize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          body: Center(
            child: CustomText(
              text: 'Shipment not found',
              fontsize: 14.sp,
              color: AppColors.secondaryTextColor,
            ),
          ),
        );
      }

      return _JobReviewBody(shipment: s, controller: c);
    });
  }
}


class _JobReviewBody extends StatelessWidget {
  final ShipmentModel shipment;
  final ShipmentController controller;

  const _JobReviewBody({required this.shipment, required this.controller});

  String _formatDate(String raw) {
    if (raw.isEmpty) return '—';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Job Details',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 160.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobStatusHeader(
                  status: shipment.displayStatus,
                  jobId: shipment.shipmentId.isNotEmpty
                      ? shipment.shipmentId
                      : shipment.id,
                ),

                SizedBox(height: 16.h),

                _JobInfoCard(shipment: shipment, onCallDriver: controller.callDriver),

                SizedBox(height: 16.h),

                CustomText(
                  text: 'Active Shipments',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                  bottom: 10.h,
                ),
                _ShipmentMap(shipment: shipment, height: 180.h),

                SizedBox(height: 16.h),


                _RouteInformationCard(shipment: shipment),

                SizedBox(height: 14.h),


                _PackageDetailsCard(shipment: shipment),

                SizedBox(height: 14.h),

                if (shipment.specialInstructions.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1A00),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: const Color(0xFFEC5B13).withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: const Color(0xFFEC5B13), size: 18.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Special Instructions',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFEC5B13),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 4.h),
                              CustomText(
                                text: shipment.specialInstructions,
                                fontsize: 12.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                if (shipment.specialInstructions.isNotEmpty) SizedBox(height: 14.h),

                // ── Inventory ────────────────────────────────────────
                if (shipment.products.isNotEmpty)
                  _InventorySection(products: shipment.products),

                if (shipment.products.isNotEmpty) SizedBox(height: 14.h),

                // ── Attached Files ───────────────────────────────────
                if (shipment.fileUrls.isNotEmpty)
                  _AttachedFilesSection(fileUrls: shipment.fileUrls),

                // ── Tracking History ─────────────────────────────────
                if (shipment.trackingHistory.isNotEmpty) ...[
                  SizedBox(height: 14.h),
                  _TrackingHistorySection(events: shipment.trackingHistory),
                ],
              ],
            ),
          ),

          // ── Bottom bar ───────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.backgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                    color: const Color(0xFF1A2A3A),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ESTIMATED SERVICE FEE',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'Poppins',
                            color: Colors.white54,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$${shipment.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                    child: GestureDetector(
                      onTap: () => controller.trackShipment(context),
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_shipping_outlined,
                                color: Colors.black, size: 18.r),
                            SizedBox(width: 8.w),
                            Text(
                              'Track Shipment',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Google Maps widget ────────────────────────────────────────────────────────

class _ShipmentMap extends StatelessWidget {
  final ShipmentModel shipment;
  final double height;

  const _ShipmentMap({required this.shipment, required this.height});

  LatLng? get _pickupPos =>
      (shipment.pickupLat != null && shipment.pickupLng != null)
          ? LatLng(shipment.pickupLat!, shipment.pickupLng!)
          : null;

  LatLng? get _dropoffPos =>
      (shipment.dropoffLat != null && shipment.dropoffLng != null)
          ? LatLng(shipment.dropoffLat!, shipment.dropoffLng!)
          : null;

  LatLng get _center {
    final p = _pickupPos;
    final d = _dropoffPos;
    if (p != null && d != null) {
      return LatLng(
        (p.latitude + d.latitude) / 2,
        (p.longitude + d.longitude) / 2,
      );
    }
    return p ?? d ?? const LatLng(23.8103, 90.4125);
  }

  Set<Marker> get _markers {
    final markers = <Marker>{};
    final p = _pickupPos;
    final d = _dropoffPos;
    if (p != null) {
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: p,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: shipment.pickupAddress.isNotEmpty
              ? shipment.pickupAddress
              : null,
        ),
      ));
    }
    if (d != null) {
      markers.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: d,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Drop-off',
          snippet: shipment.dropoffAddress.isNotEmpty
              ? shipment.dropoffAddress
              : null,
        ),
      ));
    }
    return markers;
  }

  Set<Polyline> get _polylines {
    final p = _pickupPos;
    final d = _dropoffPos;
    if (p == null || d == null) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        color: const Color(0xFF4DB6AC),
        width: 3,
        points: [p, d],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_pickupPos == null && _dropoffPos == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          height: height,
          color: const Color(0xFF1A2E3A),
          child: Center(
            child: Icon(Icons.map_outlined, color: Colors.white24, size: 48.r),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: _center, zoom: 12),
          markers: _markers,
          polylines: _polylines,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }
}

// ── Job Info Card ─────────────────────────────────────────────────────────────

class _JobInfoCard extends StatelessWidget {
  final ShipmentModel shipment;
  final VoidCallback onCallDriver;

  const _JobInfoCard({required this.shipment, required this.onCallDriver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Job Info',
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              if (shipment.priority.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1818),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    shipment.priority,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          // Company row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2427),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.business_outlined,
                      color: AppColors.primaryColor, size: 18.r),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: shipment.company.isNotEmpty
                          ? shipment.company
                          : 'Company',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: shipment.type.isNotEmpty ? shipment.type : 'Shipment',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          // Driver row
          Row(
            children: [
              ClipOval(
                child: shipment.driverProfileUrl.isNotEmpty
                    ? Image.network(
                        shipment.driverProfileUrl,
                        width: 36.r,
                        height: 36.r,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _driverFallback(),
                      )
                    : _driverFallback(),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: shipment.driverName.isNotEmpty
                          ? shipment.driverName
                          : 'Unassigned',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: 'Assigned Driver',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCallDriver,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone_outlined,
                      color: AppColors.primaryColor, size: 17.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _driverFallback() {
    return Container(
      width: 36.r,
      height: 36.r,
      color: const Color(0xFF3A3A3A),
      child: Icon(Icons.person, color: Colors.white54, size: 18.r),
    );
  }
}

// ── Route Information Card ────────────────────────────────────────────────────

class _RouteInformationCard extends StatelessWidget {
  final ShipmentModel shipment;
  const _RouteInformationCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Route Information',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 14.h,
          ),
          // Pickup
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RouteDot(color: const Color(0xFF22C55E)),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Pickup Location',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: shipment.pickupAddress.isNotEmpty
                          ? shipment.pickupAddress
                          : '—',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 8.h,
                    ),
                    _RouteDetailBox(rows: [
                      if (shipment.pickupPhone.isNotEmpty)
                        _RRow(
                            label: 'Phone',
                            value: shipment.pickupPhone,
                            valueColor: AppColors.primaryColor,
                            isPhone: true),
                      if (shipment.pickupDate.isNotEmpty)
                        _RRow(label: 'Pickup Date', value: shipment.pickupDate),
                      if (shipment.pickupInstructions.isNotEmpty)
                        _RRow(
                            label: 'Instructions',
                            value: shipment.pickupInstructions,
                            isNote: true),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Dropoff
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RouteDot(color: const Color(0xFFE53935)),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Drop-off Location',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: shipment.dropoffAddress.isNotEmpty
                          ? shipment.dropoffAddress
                          : '—',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 8.h,
                    ),
                    _RouteDetailBox(rows: [
                      if (shipment.dropoffFacility.isNotEmpty)
                        _RRow(label: 'Facility', value: shipment.dropoffFacility),
                      if (shipment.dropoffPhone.isNotEmpty)
                        _RRow(
                            label: 'Phone',
                            value: shipment.dropoffPhone,
                            valueColor: AppColors.primaryColor,
                            isPhone: true),
                      if (shipment.dropoffInstructions.isNotEmpty)
                        _RRow(
                            label: 'Instructions',
                            value: shipment.dropoffInstructions,
                            isNote: true),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteDot extends StatelessWidget {
  final Color color;
  const _RouteDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.r,
      height: 10.r,
      margin: EdgeInsets.only(top: 4.h),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _RRow {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isNote;
  final bool isPhone;

  const _RRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isNote = false,
    this.isPhone = false,
  });
}

class _RouteDetailBox extends StatelessWidget {
  final List<_RRow> rows;
  const _RouteDetailBox({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2427),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: rows.map((r) {
          if (r.isNote) {
            return Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: r.label,
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: r.value,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Row(
              children: [
                SizedBox(
                  width: 88.w,
                  child: CustomText(
                    text: r.label,
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                if (r.isPhone) ...[
                  Icon(Icons.phone, color: AppColors.primaryColor, size: 11.r),
                  SizedBox(width: 3.w),
                ],
                Expanded(
                  child: CustomText(
                    text: r.value,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: r.valueColor ?? AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Package Details Card ──────────────────────────────────────────────────────

class _PackageDetailsCard extends StatelessWidget {
  final ShipmentModel shipment;
  const _PackageDetailsCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Package Details',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          Row(
            children: [
              Icon(Icons.local_shipping_outlined,
                  color: AppColors.primaryColor, size: 15.r),
              SizedBox(width: 6.w),
              CustomText(
                text: 'Services Type',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          CustomText(
            text: shipment.serviceType.isNotEmpty ? shipment.serviceType : '—',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 10.h,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Weight',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: shipment.weight.isNotEmpty ? shipment.weight : '—',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Dimensions (L*W*H)',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: shipment.dimensions.isNotEmpty
                          ? shipment.dimensions
                          : '—',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (shipment.totalDistance.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.route_outlined,
                    color: AppColors.secondaryTextColor, size: 14.r),
                SizedBox(width: 6.w),
                CustomText(
                  text: 'Distance: ${shipment.totalDistance}',
                  fontsize: 12.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Inventory Section ─────────────────────────────────────────────────────────

class _InventorySection extends StatelessWidget {
  final List<ManagerShipmentProduct> products;
  const _InventorySection({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Inventory Item List',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          ...products.asMap().entries.map((e) {
            final isLast = e.key == products.length - 1;
            final p = e.value;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: p.name.isNotEmpty ? p.name : p.productType,
                              fontsize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                            if (p.serialNumber.isNotEmpty)
                              CustomText(
                                text: 'SN: ${p.serialNumber}',
                                fontsize: 11.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D2E1A),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: CustomText(
                          text: p.productType.isNotEmpty
                              ? p.productType
                              : 'Item',
                          fontsize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF22C55E),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                      height: 1,
                      thickness: 0.5,
                      color: const Color(0xFF3A3A3A)),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Attached Files Section ────────────────────────────────────────────────────

class _AttachedFilesSection extends StatelessWidget {
  final List<String> fileUrls;
  const _AttachedFilesSection({required this.fileUrls});

  bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_file_rounded,
                  color: AppColors.primaryColor, size: 18.r),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Attached Files',
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...fileUrls.map((url) {
            final isPdf = url.toLowerCase().endsWith('.pdf');
            final fileName = url.split('/').last;
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: !isPdf
                        ? Image.network(
                            url,
                            width: 36.r,
                            height: 36.r,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fileIcon(isPdf),
                          )
                        : _fileIcon(isPdf),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomText(
                      text: fileName,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      maxline: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.download_outlined,
                      color: AppColors.secondaryTextColor, size: 18.r),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _fileIcon(bool isPdf) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: isPdf
            ? Colors.redAccent.withValues(alpha: 0.15)
            : AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(
        isPdf ? Icons.picture_as_pdf : Icons.image_outlined,
        color: isPdf ? Colors.redAccent : AppColors.primaryColor,
        size: 20.r,
      ),
    );
  }
}

// ── Tracking History Section ──────────────────────────────────────────────────

class _TrackingHistorySection extends StatelessWidget {
  final List<ManagerTrackingEvent> events;
  const _TrackingHistorySection({required this.events});

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Tracking History',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          ...events.asMap().entries.map((entry) {
            final e = entry.value;
            final isLast = entry.key == events.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                    child: Column(
                      children: [
                        Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: BoxDecoration(
                            color: e.isDone
                                ? AppColors.primaryColor
                                : const Color(0xFF3A3A3A),
                            shape: BoxShape.circle,
                            border: e.isDone
                                ? null
                                : Border.all(
                                    color: AppColors.secondaryTextColor,
                                    width: 1.5),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 1.5.w,
                              color: AppColors.primaryColor
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: e.title.isNotEmpty ? e.title : e.status,
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: e.isDone
                                ? AppColors.primaryTextColor
                                : AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          if (e.description.isNotEmpty)
                            CustomText(
                              text: e.description,
                              fontsize: 11.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                        ],
                      ),
                    ),
                  ),
                  CustomText(
                    text: _formatDate(e.timestamp),
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
