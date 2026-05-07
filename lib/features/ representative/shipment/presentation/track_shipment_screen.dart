import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipment_detail_controller.dart';
import '../model/shipment_model.dart';
import 'widgets/section_card.dart';

class TrackShipmentScreen extends StatefulWidget {
  final String? shipmentId;
  const TrackShipmentScreen({super.key, this.shipmentId});

  @override
  State<TrackShipmentScreen> createState() => _TrackShipmentScreenState();
}

class _TrackShipmentScreenState extends State<TrackShipmentScreen> {
  late final ShipmentDetailController _ctrl;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ShipmentDetailController(), tag: 'track');
    if (widget.shipmentId != null && widget.shipmentId!.isNotEmpty) {
      _searchController.text = widget.shipmentId!;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _ctrl.loadDetail(widget.shipmentId!));
    } else {
      _ctrl.isLoading.value = false;
    }
  }

  @override
  void dispose() {
    Get.delete<ShipmentDetailController>(tag: 'track', force: true);
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final id = _searchController.text.trim();
    if (id.isEmpty) return;
    _ctrl.loadDetail(id);
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
          text: 'Track Shipment',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ──
          if (widget.shipmentId == null)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: AppColors.dotButtonInactiveColor, width: 0.6),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12.w),
                          Icon(Icons.search,
                              color: AppColors.secondaryTextColor, size: 18.r),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(
                                color: AppColors.primaryTextColor,
                                fontSize: 13.sp,
                                fontFamily: 'Poppins',
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter shipment ID...',
                                hintStyle: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.h),
                              ),
                              onSubmitted: (_) => _search(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: _search,
                    child: Container(
                      width: 46.r,
                      height: 46.r,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.search, color: Colors.black, size: 22.r),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: Obx(() {
              if (_ctrl.isLoading.value) return _shimmer();
              final s = _ctrl.shipment.value;
              if (s == null) {
                return Center(
                  child: CustomText(
                    text: widget.shipmentId == null
                        ? 'Enter a shipment ID to track'
                        : 'Shipment not found',
                    color: AppColors.secondaryTextColor,
                  ),
                );
              }
              return _buildContent(s);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ShipmentModel s) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                  _StatusBadge(status: s.shipmentStatus),
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

          // ── Job Info Card ──
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

              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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

          // ── Live Location Map ──
          CustomText(
            text: 'Live Location',
            fontsize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 10.h,
          ),
          _LiveMap(shipment: s),
          SizedBox(height: 20.h),

          // ── Tracking History ──
          if (s.trackingHistory.isNotEmpty) ...[
            CustomText(
              text: 'Tracking History',
              fontsize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
              bottom: 12.h,
            ),
            _TrackingTimeline(events: s.trackingHistory),
            SizedBox(height: 20.h),
          ],

          // ── Package Details ──
          CustomText(
            text: 'Package Details',
            fontsize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          Row(
            children: [
              Expanded(
                child: _PackageCard(
                  label: 'Items',
                  value: s.products.isNotEmpty
                      ? '${s.products.length} item${s.products.length > 1 ? 's' : ''}'
                      : '—',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _PackageCard(
                  label: 'Weight',
                  value: s.weight.isNotEmpty ? '${s.weight} lbs' : '—',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _PackageCard(
                  label: 'Service',
                  value: s.serviceType.isNotEmpty ? s.serviceType : '—',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
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
          children: List.generate(
            4,
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

// ── Live Map ──────────────────────────────────────────────────────────────────

class _LiveMap extends StatelessWidget {
  final ShipmentModel shipment;
  const _LiveMap({required this.shipment});

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
          (p.latitude + d.latitude) / 2, (p.longitude + d.longitude) / 2);
    }
    return p ?? d ?? const LatLng(37.7749, -122.4194);
  }

  @override
  Widget build(BuildContext context) {
    if (_pickupPos == null && _dropoffPos == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          height: 160.h,
          color: const Color(0xFF1A2E3A),
          child: Center(
            child: Icon(Icons.map_outlined, color: Colors.white24, size: 48.r),
          ),
        ),
      );
    }

    final markers = <Marker>{};
    final p = _pickupPos;
    final d = _dropoffPos;
    if (p != null) {
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: p,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Pickup'),
      ));
    }
    if (d != null) {
      markers.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: d,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Drop-off'),
      ));
    }

    final polylines = <Polyline>{};
    if (p != null && d != null) {
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: const Color(0xFF4DB6AC),
        width: 3,
        points: [p, d],
      ));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: double.infinity,
        height: 160.h,
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: _center, zoom: 12),
          markers: markers,
          polylines: polylines,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }
}

// ── Tracking Timeline ─────────────────────────────────────────────────────────

class _TrackingTimeline extends StatelessWidget {
  final List<TrackingEvent> events;
  const _TrackingTimeline({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(events.length, (i) {
        final e = events[i];
        final isLast = i == events.length - 1;
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
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
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
                        text: e.status,
                        fontsize: 13.sp,
                        fontWeight: isLast
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: e.isDone
                            ? AppColors.primaryTextColor
                            : AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      if (e.location != null && e.location!.isNotEmpty)
                        CustomText(
                          text: e.location!,
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                    ],
                  ),
                ),
              ),
              if (e.timestamp.isNotEmpty)
                CustomText(
                  text: _formatTs(e.timestamp),
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.end,
                ),
            ],
          ),
        );
      }),
    );
  }

  String _formatTs(String ts) {
    try {
      final dt = DateTime.parse(ts).toLocal();
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '${months[dt.month - 1]} ${dt.day}, $h:$m $ampm';
    } catch (_) {
      return ts;
    }
  }
}

// ── Package Card ──────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  final String label;
  final String value;
  const _PackageCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.6),
      ),
      child: Column(
        children: [
          CustomText(
            text: label,
            fontsize: 10.sp,
            color: AppColors.secondaryTextColor,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

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
