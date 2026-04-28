import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/job_details_action_buttons.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/job_earnings_card.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/job_location_card.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/job_package_card.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/job_shipment_header.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/special_instructions_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/driver_home_controller.dart';



class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverHomeController>();
    final job = c.jobDetail;

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
              text: 'New Delivery',
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: 'Job Request',
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
                  JobShipmentHeader(
                    shipmentId: job.shipmentId,
                    isUrgent: job.isUrgent,
                  ),

                  SizedBox(height: 14.h),

                  JobEarningsCard(
                    earnings: job.earnings,
                    distanceKm: job.distanceKm,
                  ),

                  SizedBox(height: 14.h),

                  JobLocationCard(
                    pickupName: job.pickupName,
                    pickupAddress: job.pickupAddress,
                    pickupContact: job.pickupContact,
                    pickupPhone: job.pickupPhone,
                    dropoffName: job.dropoffName,
                    dropoffAddress: job.dropoffAddress,
                    dropoffContact: job.dropoffContact,
                    dropoffPhone: job.dropoffPhone,
                  ),

                  SizedBox(height: 14.h),

                  JobPackageCard(
                    serviceType: job.serviceType,
                    weight: job.weight,
                    dimensions: job.dimensions,
                  ),

                  SizedBox(height: 14.h),

                  SpecialInstructionsCard(
                    instructions: job.specialInstructions,
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          JobDetailActionButtons(
            onDecline: c.declineJob,
            onAccept: c.acceptJob,
          ),
        ],
      ),
    );
  }
}