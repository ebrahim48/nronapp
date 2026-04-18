import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/attached_files_section.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/job_detailed_earnings_card.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/navigation_button.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/route_information_card.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/shipment_summary_card.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/status_eta_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../driver_home/presentation/widgets/job_package_card.dart';
import '../../driver_home/presentation/widgets/special_instructions_card.dart';
import '../controller/driver_job_controller.dart';



class DriverJobDetailsScreen extends StatelessWidget {
  const DriverJobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DriverJobController>();
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
              text: 'Job Details',
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: job.shipmentId,
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
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  StatusEtaBar(status: job.status, eta: job.eta),

                  SizedBox(height: 12.h),

                  ShipmentSummaryCard(
                    shipmentId: job.shipmentSummaryId,
                    type: job.type,
                    priority: job.priority,
                  ),

                  SizedBox(height: 12.h),

                  RouteInformationCard(
                    pickupLocation: job.pickupLocation,
                    pickupAddress: job.pickupAddress,
                    pickupContact: job.pickupContact,
                    pickupPhone: job.pickupPhone,
                    pickupDate: job.pickupDate,
                    pickupInstructions: job.pickupInstructions,
                    dropoffLocation: job.dropoffLocation,
                    dropoffAddress: job.dropoffAddress,
                    dropoffFacility: job.dropoffFacility,
                    dropoffContact: job.dropoffContact,
                    dropoffPhone: job.dropoffPhone,
                    dropoffInstructions: job.dropoffInstructions,
                  ),

                  SizedBox(height: 12.h),

                  JobPackageCard(
                    serviceType: job.serviceType,
                    weight: job.weight,
                    dimensions: job.dimensions,
                  ),

                  SizedBox(height: 12.h),

                  SpecialInstructionsCard(
                      instructions: job.specialInstructions),

                  SizedBox(height: 12.h),

                  AttachedFilesSection(files: job.attachedFiles),

                  SizedBox(height: 12.h),

                  JobDetailEarningsCard(
                    deliveryFee: job.deliveryFee,
                    yourPayout: job.yourPayout,
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: NavigateButton(onTap: c.navigateJob),
          ),
        ],
      ),
    );
  }
}