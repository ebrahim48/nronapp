import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/driver_map_controller.dart';

class MapActionButtons extends StatelessWidget {
  const MapActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverMapController>();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            c.mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(
                DriverMapController.initialCamera.target,
                14,
              ),
            );
          },
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A).withValues(alpha: 0.9),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Icon(Icons.my_location,
                color: AppColors.primaryTextColor, size: 18.r),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withValues(alpha: 0.9),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Icon(Icons.layers_outlined,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
      ],
    );
  }
}