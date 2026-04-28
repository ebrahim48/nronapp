import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/detail_section_header.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/radiology_detail_grid.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_attachment_tile.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_info_table.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_material_list.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/surgery_controller.dart';




class SurgeryDetailScreen extends StatelessWidget {
  const SurgeryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();
    final d = c.surgeryDetail;

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
          text: 'Surgery Details',
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
            Row(
              children: [
                // Edit Surgery
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/edit.svg',
                            width: 14.r,
                            height: 14.r,
                            colorFilter: const ColorFilter.mode(
                              AppColors.blackColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Edit Surgery',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                // Download PDF
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download_outlined,
                              color: AppColors.primaryTextColor,
                              size: 16.r),
                          SizedBox(width: 6.w),
                          Text(
                            'Download PDF',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundImage: d.avatarAsset != null
                            ? AssetImage(d.avatarAsset!)
                            : null,
                        backgroundColor: const Color(0xFF3A3A3A),
                        child: d.avatarAsset == null
                            ? Icon(Icons.person,
                            size: 36.r,
                            color: AppColors.secondaryTextColor)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.physicianProfileScreen),
                          child: Icon(Icons.remove_red_eye_outlined,
                              color: AppColors.primaryColor, size: 18.r),
                        ),
                      ),
                    ],
                  ),
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: d.patientName,
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            DetailSectionHeader(
              iconPath: 'assets/icons/surgeryinfo.svg',
              title: 'Surgery Info',
            ),

            SurgeryInfoTable(rows: [
              SurgeryInfoRow('Physician', d.physician),
              SurgeryInfoRow('PT ID', d.ptId),
              SurgeryInfoRow('Facility', d.facility),
              SurgeryInfoRow('Date of Surgery', d.dateOfSurgery),
              SurgeryInfoRow('Surgery Type', d.surgeryType),
            ]),

            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailSectionHeader(
                    iconPath: 'assets/icons/attachments.svg',
                    title: 'Attachments',
                  ),
                  ...d.attachments.map(
                        (att) => SurgeryAttachmentTile(attachment: att),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailSectionHeader(
                    iconPath: 'assets/icons/surgeryinfo.svg',
                    title: 'Surgery Materials',
                    trailing:
                    '${d.materials.length} ITEMS LOGGED',
                  ),
                  SurgeryMaterialsList(materials: d.materials),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailSectionHeader(
                    iconPath: 'assets/icons/radiology.svg',
                    title: 'Radiology Images',
                  ),
                  RadiologyDetailGrid(images: d.radiologyImages),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2121),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send to Doctor Email',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00C5DA),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/createjob.svg',
                      width: 18.r,
                      height: 18.r,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF00C5DA),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}