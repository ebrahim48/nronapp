import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../controller/driver_map_controller.dart';

class MapActionButtons extends StatelessWidget {
  const MapActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverMapController>();

    return Column(
      children: [
        // Center on current GPS location
        Obx(() {
          final hasPosition = c.currentPosition.value != null;
          return GestureDetector(
            onTap: () {
              final pos = c.currentPosition.value;
              if (pos != null) {
                c.mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(pos, 16),
                );
              }
            },
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: hasPosition
                    ? AppColors.primaryColor.withValues(alpha: 0.15)
                    : const Color(0xFF2A2A2A).withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: hasPosition
                      ? AppColors.primaryColor
                      : const Color(0xFF3A3A3A),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.my_location,
                color: hasPosition
                    ? AppColors.primaryColor
                    : AppColors.secondaryTextColor,
                size: 20.r,
              ),
            ),
          );
        }),

        SizedBox(height: 10.h),

        // Zoom in
        _ActionButton(
          icon: Icons.add,
          onTap: () => c.mapController
              ?.animateCamera(CameraUpdate.zoomIn()),
        ),

        SizedBox(height: 8.h),

        // Zoom out
        _ActionButton(
          icon: Icons.remove,
          onTap: () => c.mapController
              ?.animateCamera(CameraUpdate.zoomOut()),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3A3A3A), width: 1.2),
        ),
        child: Icon(icon, color: AppColors.primaryTextColor, size: 20.r),
      ),
    );
  }
}