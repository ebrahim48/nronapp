import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/utils/app_colors.dart';

class LocationPickResult {
  final String address;
  final double lat;
  final double lng;
  const LocationPickResult({
    required this.address,
    required this.lat,
    required this.lng,
  });
}

class MapLocationPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;
  const MapLocationPickerScreen({super.key, this.initialPosition});

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  static const _apiKey = 'AIzaSyDFiKLw_sSi4BAjNEBe1HYIqG-FDAs86Kk';
  static const _defaultPos = LatLng(37.7749, -122.4194);

  late LatLng _pickedPos;
  String _address = 'Move the map to select a location';
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _pickedPos = widget.initialPosition ?? _defaultPos;
    _fetchAddress(_pickedPos);
  }

  Future<void> _fetchAddress(LatLng pos) async {
    setState(() => _isFetching = true);
    try {
      final res = await Dio().get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '${pos.latitude},${pos.longitude}',
          'key': _apiKey,
        },
      );
      final results = res.data['results'] as List? ?? [];
      if (results.isNotEmpty) {
        setState(() {
          _address = results.first['formatted_address']?.toString() ??
              'Unknown location';
        });
      }
    } catch (_) {
      setState(() => _address = 'Could not fetch address');
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map ────────────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedPos,
              zoom: 15,
            ),
            onCameraMove: (pos) => _pickedPos = pos.target,
            onCameraIdle: () => _fetchAddress(_pickedPos),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          ),

          // ── Center pin ─────────────────────────────────────────────────────
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: Icon(
                  Icons.location_pin,
                  color: AppColors.primaryColor,
                  size: 48.r,
                ),
              ),
            ),
          ),

          // ── Back button ────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2427),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back_ios_new,
                    color: AppColors.primaryTextColor, size: 16.r),
              ),
            ),
          ),

          // ── Bottom card ────────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w,
                  MediaQuery.of(context).padding.bottom + 16.h),
              decoration: const BoxDecoration(
                color: Color(0xFF1E2427),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          color: AppColors.primaryColor, size: 18.r),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _isFetching
                            ? CustomText(
                                text: 'Fetching address...',
                                fontsize: 13.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              )
                            : CustomText(
                                text: _address,
                                fontsize: 13.sp,
                                color: AppColors.primaryTextColor,
                                maxline: 3,
                                textAlign: TextAlign.start,
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: _isFetching
                        ? null
                        : () => Navigator.pop(
                              context,
                              LocationPickResult(
                                address: _address,
                                lat: _pickedPos.latitude,
                                lng: _pickedPos.longitude,
                              ),
                            ),
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: _isFetching
                            ? AppColors.primaryColor.withValues(alpha: 0.4)
                            : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Confirm Location',
                          fontsize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
