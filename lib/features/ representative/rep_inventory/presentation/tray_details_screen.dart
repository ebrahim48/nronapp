import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/tray_details_widgets.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/tray_details_controller.dart';

class TrayDetailsScreen extends StatelessWidget {
  final String id;
  const TrayDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(TrayDetailsController());
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
          text: 'Tray Details',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          GestureDetector(
            onTap: () => context.pushNamed(AppRoutes.editTrayScreen, extra: id),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Row(
                children: [
                  CustomText(
                    text: 'Edit',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.edit_outlined,
                    size: 13.r,
                    color: AppColors.primaryTextColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (c.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Column(
                children: List.generate(
                  4,
                  (_) => Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    height: 100.h,
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
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TrayHeaderSection(
                      title: c.unitName.value,
                      location: c.unitLocation.value,
                    ),

                    SizedBox(height: 16.h),

                    TrayImageWithTags(
                      imagePath: c.imagePath.value,
                      inventoryModel: c.inventoryModel.value,
                      status: c.status.value,
                    ),

                    SizedBox(height: 20.h),

                    TrayGeneralInfoCard(
                      serialNumber: c.serialNumber.value,
                      systemType: c.systemType.value,
                      vendor: c.vendor.value,
                      availabilityStatus: c.availabilityStatus.value,
                    ),

                    SizedBox(height: 16.h),

                    TrayLocationCard(
                      location: c.currentLocation.value,
                    ),

                    SizedBox(height: 24.h),

                    TrayAdditionalNote(
                      note: c.additionalNote.value,
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            Container(
              color: AppColors.backgroundColor,
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 50.h),
              child: TrayActionButtons(
                onSendTray: c.sendTray,
                onReceiveTray: c.receiveTray,
                onReportMissing: c.reportMissingInstrument,
              ),
            ),
          ],
        );
      }),
    );
  }
}
