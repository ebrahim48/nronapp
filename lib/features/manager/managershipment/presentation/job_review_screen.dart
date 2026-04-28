import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/manager/managershipment/presentation/widgets/job_action_button.dart';
import 'package:nron_app/features/manager/managershipment/presentation/widgets/job_map_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipmentcontroller.dart';
import 'widgets/job_status_header.dart';
import 'widgets/job_info_card.dart';
import 'widgets/pickup_dropoff_section.dart';
import 'widgets/package_details_row.dart';


class JobReviewScreen extends StatelessWidget {
  const JobReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ShipmentController>();
    final job = c.jobReview;

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
          text: 'Job Review',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobStatusHeader(
              status: job.status,
              jobId: job.jobId,
            ),

            SizedBox(height: 16.h),

            JobInfoCard(
              packageName: job.packageName,
              packageType: job.packageType,
              onAssignDriver: c.assignDriver,
            ),

            SizedBox(height: 20.h),

            CustomText(
              text: 'Active Shipments',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 10.h),

            ShipmentMapWidget(status: job.status),

            SizedBox(height: 20.h),

            PickupDropoffSection(
              pickupDate: job.pickupDate,
              pickupTime: job.pickupTime,
              pickupLocation: job.pickupLocation,
              pickupBuilding: job.pickupBuilding,
              pickupNote: job.pickupNote,
              dropoffEstTime: job.dropoffEstTime,
              dropoffLocation: job.dropoffLocation,
              dropoffBuilding: job.dropoffBuilding,
              dropoffNote: job.dropoffNote,
            ),

            SizedBox(height: 20.h),

            PackageDetailsRow(
              items: job.items,
              weight: job.weight,
              service: job.service,
            ),

            SizedBox(height: 24.h),

            JobActionButtons(
              onSendCourierOrder: c.sendCourierOrder,
              onCloseJob: c.closeJob,
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}