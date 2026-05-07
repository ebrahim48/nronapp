import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipment_detail_controller.dart';
import '../model/shipment_model.dart';
import 'track_shipment_screen.dart';
import 'widgets/section_card.dart';

class JobDetailsScreen extends StatefulWidget {
  final String id;
  const JobDetailsScreen({super.key, required this.id});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late final ShipmentDetailController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ShipmentDetailController());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _ctrl.loadDetail(widget.id));
  }

  @override
  void dispose() {
    Get.delete<ShipmentDetailController>(force: true);
    super.dispose();
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
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Job Details',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) return _shimmer();
        final s = _ctrl.shipment.value;
        if (s == null) {
          return Center(
            child: CustomText(
              text: 'Shipment not found',
              color: AppColors.secondaryTextColor,
            ),
          );
        }
        return _buildBody(context, s);
      }),
    );
  }

  Widget _buildBody(BuildContext context, ShipmentModel s) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 140.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Status + Job ID ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'STATUS',
                        fontsize: 10.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4.h),
                      _StatusChip(status: s.shipmentStatus),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text: 'JOB ID',
                        fontsize: 10.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: s.refDisplay,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // ── Job Info ──
              SectionCard(
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
                      if (s.priority.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B1818),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: CustomText(
                            text: s.priority,
                            fontsize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Company row
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 10.h),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: s.company.isNotEmpty ? s.company : '—',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                              CustomText(
                                text: s.packageType.isNotEmpty
                                    ? s.packageType
                                    : 'Shipment',
                                fontsize: 11.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Driver row
                  Row(
                    children: [
                      Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3A3A3A),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person,
                            color: AppColors.secondaryTextColor, size: 18.r),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: s.driverName.isNotEmpty
                                  ? s.driverName
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
                      if (s.driverPhone.isNotEmpty)
                        ActionIconButton(
                          icon: Icons.phone_outlined,
                          onTap: () {},
                        ),
                    ],
                  ),
                ],
              ),

              // ── Map ──
              CustomText(
                text: 'Route Map',
                fontsize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
                bottom: 10.h,
              ),
              _ShipmentMap(shipment: s, height: 180.h),

              SizedBox(height: 16.h),

              // ── Route Information ──
              _RouteInfoCard(s: s),

              // ── Package Details ──
              SectionCard(
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
                          color: AppColors.primaryColor, size: 16.r),
                      SizedBox(width: 6.w),
                      CustomText(
                        text: 'Services Type',
                        fontsize: 11.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: s.serviceType.isNotEmpty ? s.serviceType : '—',
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
                              text: s.weight.isNotEmpty ? '${s.weight} kg' : '—',
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
                              text: s.dimensions.isNotEmpty ? s.dimensions : '—',
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
                ],
              ),

              // ── Special Instructions ──
              if (s.specialInstructions.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 14.h),
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
                              text: s.specialInstructions,
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

              // ── Inventory Item List ──
              if (s.products.isNotEmpty)
                SectionCard(
                  children: [
                    CustomText(
                      text: 'Inventory Item List',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 12.h,
                    ),
                    ...s.products.take(3).map((p) => _ProductRow(product: p)),
                    if (s.products.length > 3) ...[
                      SizedBox(height: 8.h),
                      Center(
                        child: CustomText(
                          text: 'View All ${s.products.length} Items',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),

              // ── Attached Files ──
              if (s.fileUrls.isNotEmpty)
                SectionCard(
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
                    ...s.fileUrls.map((url) => _FileRow(url: url)),
                  ],
                ),
            ],
          ),
        ),

        // ── Sticky bottom ──
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
                      CustomText(
                        text: 'SHIPMENT STATUS',
                        fontsize: 10.sp,
                        color: Colors.white54,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4.h),
                      _StatusChip(status: s.shipmentStatus),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackShipmentScreen(shipmentId: s.id),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            color: Colors.black, size: 18.r),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'Track Shipment',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                        ),
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
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
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
    );
  }
}

// ── Map Widget ────────────────────────────────────────────────────────────────

class _ShipmentMap extends StatelessWidget {
  final ShipmentModel shipment;
  final double height;

  const _ShipmentMap({required this.shipment, required this.height});

  LatLng? get _pickupPos => (shipment.pickupLat != null && shipment.pickupLng != null)
      ? LatLng(shipment.pickupLat!, shipment.pickupLng!)
      : null;

  LatLng? get _dropoffPos => (shipment.dropoffLat != null && shipment.dropoffLng != null)
      ? LatLng(shipment.dropoffLat!, shipment.dropoffLng!)
      : null;

  LatLng get _center {
    final p = _pickupPos;
    final d = _dropoffPos;
    if (p != null && d != null) {
      return LatLng((p.latitude + d.latitude) / 2, (p.longitude + d.longitude) / 2);
    }
    return p ?? d ?? const LatLng(37.7749, -122.4194);
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
          snippet: shipment.pickupAddress.isNotEmpty ? shipment.pickupAddress : null,
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
          snippet: shipment.dropoffAddress.isNotEmpty ? shipment.dropoffAddress : null,
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
          liteModeEnabled: false,
        ),
      ),
    );
  }
}

// ── Route Info Card ────────────────────────────────────────────────────────────

class _RouteInfoCard extends StatelessWidget {
  final ShipmentModel s;
  const _RouteInfoCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
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
          _LocationRow(
            dotColor: const Color(0xFF22C55E),
            label: 'Pickup Location',
            name: s.pickupAddress.isNotEmpty ? s.pickupAddress : '—',
            details: [
              if (s.pickupContact.isNotEmpty) _DetailRow('Contact', s.pickupContact),
              if (s.pickupPhone.isNotEmpty) _DetailRow('Phone', s.pickupPhone, valueColor: AppColors.primaryColor),
              if (s.pickupDate.isNotEmpty) _DetailRow('Pickup Date', s.pickupDate),
              if (s.pickupInstructions.isNotEmpty) _DetailRow('Instructions', s.pickupInstructions, isNote: true),
            ],
          ),
          SizedBox(height: 14.h),

          // Dropoff
          _LocationRow(
            dotColor: const Color(0xFFE53935),
            label: 'Drop-off Location',
            name: s.dropoffAddress.isNotEmpty ? s.dropoffAddress : '—',
            details: [
              if (s.dropoffContact.isNotEmpty) _DetailRow('Contact', s.dropoffContact),
              if (s.dropoffPhone.isNotEmpty) _DetailRow('Phone', s.dropoffPhone, valueColor: AppColors.primaryColor),
              if (s.dropoffInstructions.isNotEmpty) _DetailRow('Instructions', s.dropoffInstructions, isNote: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isNote;
  const _DetailRow(this.label, this.value, {this.valueColor, this.isNote = false});
}

class _LocationRow extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String name;
  final List<_DetailRow> details;

  const _LocationRow({
    required this.dotColor,
    required this.label,
    required this.name,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          margin: EdgeInsets.only(top: 3.h),
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: name,
                fontsize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
                bottom: 8.h,
              ),
              if (details.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2427),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: details.map((d) {
                      if (d.isNote) {
                        return Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: d.label, fontsize: 11.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                              CustomText(text: d.value, fontsize: 12.sp, fontWeight: FontWeight.w500, color: d.valueColor ?? AppColors.primaryTextColor, textAlign: TextAlign.start),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90.w,
                              child: CustomText(text: d.label, fontsize: 11.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                            ),
                            Expanded(
                              child: CustomText(text: d.value, fontsize: 12.sp, fontWeight: FontWeight.w500, color: d.valueColor ?? AppColors.primaryTextColor, textAlign: TextAlign.start),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Product Row ──────────────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  final ShipmentProductItem product;
  const _ProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: product.name.isNotEmpty ? product.name : 'Item',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: product.serialNumber.isNotEmpty
                      ? 'SN: ${product.serialNumber}'
                      : product.productType,
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0D2E1A),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: CustomText(
              text: product.productType.isNotEmpty ? product.productType : 'Item',
              fontsize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF22C55E),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

// ── File Row ─────────────────────────────────────────────────────────────────

class _FileRow extends StatelessWidget {
  final String url;
  const _FileRow({required this.url});

  @override
  Widget build(BuildContext context) {
    final isPdf = url.toLowerCase().contains('.pdf');
    final fileName = url.split('/').last.split('?').first;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
              color: isPdf
                  ? Colors.redAccent.withValues(alpha: 0.15)
                  : AppColors.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf : Icons.image_outlined,
              color: isPdf ? Colors.redAccent : AppColors.primaryColor,
              size: 20.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              text: fileName.isNotEmpty ? fileName : 'File',
              fontsize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          Icon(Icons.download_outlined,
              color: AppColors.secondaryTextColor, size: 18.r),
        ],
      ),
    );
  }
}

// ── Status Chip ───────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;
    switch (status.toLowerCase()) {
      case 'in_transit':
      case 'in transit':
        bg = AppColors.warningColor;
        label = 'In Transit';
        break;
      case 'pending':
        bg = AppColors.warningColor;
        label = 'Pending';
        break;
      case 'delivered':
        bg = const Color(0xFF00D500);
        label = 'Delivered';
        break;
      case 'approved':
        bg = AppColors.primaryColor;
        label = 'Approved';
        break;
      default:
        bg = AppColors.primaryColor;
        label = status.isNotEmpty ? status : 'Unknown';
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bg, width: 0.8),
      ),
      child: CustomText(
        text: label,
        fontsize: 12.sp,
        fontWeight: FontWeight.w500,
        color: bg,
      ),
    );
  }
}
