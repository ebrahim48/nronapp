import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/complete_delivery_button.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/delivery_notes_field.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/photo_capture_section.dart';
import 'package:nron_app/features/driver/driver_map/presentation/widgets/pickup_details_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/driver_map_controller.dart';



class CompleteDeliveryScreen extends StatelessWidget {
  const CompleteDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverMapController>();

    return Obx(() {
      final job = c.mapJob.value;
      final shipmentId = job?.shipmentId ?? '';
      final pickupLocation = job?.pickup.name ?? '—';
      final dropoffLocation = job?.destination.name ?? '—';
      final distance = job?.distanceMi ?? '—';

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          toolbarHeight: 60.h,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios,
                color: AppColors.primaryTextColor, size: 18.r),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Complete Delivery',
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: shipmentId.isNotEmpty ? shipmentId : 'Delivery',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Column(
                  children: [
                    PickupDetailsCard(
                      location: pickupLocation,
                      recipient: dropoffLocation,
                      items: distance,
                    ),

                    SizedBox(height: 14.h),

                    const PhotoCaptureSection(),

                    SizedBox(height: 14.h),

                    DeliveryNotesField(controller: c.deliveryNotes),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            Obx(() => Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              child: CompleteDeliveryButton(
                isLoading: c.isCompleting.value,
                onTap: () => c.completeDelivery(context),
              ),
            )),
          ],
        ),
      );
    });
  }
}