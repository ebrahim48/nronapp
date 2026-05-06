import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/missing_instrument_details_widgets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/missing_instrument_detail_controller.dart';

class MissingInstrumentDetailScreen extends StatelessWidget {
  final String id;
  const MissingInstrumentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MissingInstrumentDetailController());
    WidgetsBinding.instance.addPostFrameCallback((_) => c.loadDetail(id));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryTextColor,
            size: 18.r,
          ),
        ),
        title: CustomText(
          text: 'Report Details',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),

      body: Obx(() {
        if (c.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
              child: Column(
                children: List.generate(
                  4,
                  (_) => Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
                child: Column(
                  children: [

                    VendorNotifiedBanner(
                      notified: c.vendorNotified.value,
                      message: c.vendorNotified.value
                          ? 'Notification sent to vendor successfully.'
                          : 'Vendor has not been notified yet.',
                    ),

                    SizedBox(height: 16.h),

                    ReportTrayDetailsCard(
                      trayId: c.trayId.value,
                      facility: c.facility.value,
                      location: c.location.value,
                    ),

                    SizedBox(height: 16.h),

                    ReportIssueInfoCard(
                      instrumentName: c.instrumentName.value,
                      notes: c.notes.value,
                      status: c.status.value,
                    ),

                    SizedBox(height: 16.h),

                    if (c.evidenceFiles.isNotEmpty || c.capturedAt.value != null)
                      ReportEvidenceCard(
                        files: c.evidenceFiles,
                        capturedAt: c.capturedAt.value ?? DateTime.now(),
                      ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            Container(
              color: AppColors.backgroundColor,
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 16.h),
              child: Column(
                children: [
                  ReportActionButtons(
                    onDownloadPdf: () => c.downloadPdf(context),
                    onSendEmail: () => c.sendToVendorEmail(context),
                    isSending: c.isSending.value,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
