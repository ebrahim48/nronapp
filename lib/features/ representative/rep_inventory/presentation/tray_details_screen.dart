import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/tray_details_widgets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/tray_details_controller.dart';


class TrayDetailsScreen extends StatelessWidget {
  const TrayDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(TrayDetailsController());

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
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrayInfoCard(
                    imagePath: c.imagePath.value,
                    trayId: c.trayId.value,
                    trayName: c.trayName.value,
                    updatedAgo: c.updatedAgo.value,
                  ),

                  SizedBox(height: 16.h),

                  TrayTagRow(
                    inventoryModel: c.inventoryModel.value,
                    status: c.status.value,
                  ),

                  SizedBox(height: 12.h),

                  TrayLocationCard(
                    location: c.currentLocation.value,
                  ),

                  SizedBox(height: 24.h),

                  TrayMovementHistory(
                    items: c.movementHistory,
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
      ),
    );
  }
}