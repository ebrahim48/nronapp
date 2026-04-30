import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/detail_section_header.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/radiology_detail_grid.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_attachment_tile.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_info_table.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_material_list.dart';
import '../../../../core/helpers/pdf_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../physicions/presentation/physicions_profile_screen.dart';
import '../controller/surgery_controller.dart';
import '../model/surgery_model.dart';
import 'add_surgery_screen.dart';

class SurgeryDetailScreen extends StatelessWidget {
  const SurgeryDetailScreen({super.key});

  String _formatDate(String iso) {
    if (iso.isEmpty) return '—';
    try {
      return DateFormat('MM/dd/yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  List<SurgeryMaterialGroup> _buildMaterials(SurgeryDetailModel d) {
    final groups = <SurgeryMaterialGroup>[];
    if (d.screws.isNotEmpty) {
      groups.add(SurgeryMaterialGroup(category: 'SCREWS', detail: d.screws));
    }
    if (d.plates.isNotEmpty) {
      groups.add(SurgeryMaterialGroup(category: 'PLATES', detail: d.plates));
    }
    if (d.rodsOrConnectors.isNotEmpty) {
      groups.add(SurgeryMaterialGroup(
          category: 'RODS/CONNECTORS', detail: d.rodsOrConnectors));
    }
    if (d.implants.isNotEmpty) {
      groups.add(SurgeryMaterialGroup(category: 'IMPLANTS', detail: d.implants));
    }
    return groups;
  }

  List<RadiologyImage> _buildRadiology(SurgeryDetailModel d) {
    return [
      RadiologyImage(
          label: 'PATIENT STICKER',
          networkUrl: d.patientSticker.isEmpty ? null : d.patientSticker),
      RadiologyImage(
          label: 'AP PRE',
          networkUrl: d.preOpAP.isEmpty ? null : d.preOpAP),
      RadiologyImage(
          label: 'AP POST',
          networkUrl: d.postOpAP.isEmpty ? null : d.postOpAP),
      RadiologyImage(
          label: 'LATERAL PRE',
          networkUrl: d.preOpLateral.isEmpty ? null : d.preOpLateral),
      RadiologyImage(
          label: 'LATERAL POST',
          networkUrl: d.postOpLateral.isEmpty ? null : d.postOpLateral),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();

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
        actions: [
          Obx(() => GestureDetector(
            onTap: c.isDeleting.value
                ? null
                : () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF1E2427),
                        title: Text(
                          'Delete Surgery',
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete this surgery?',
                          style: TextStyle(
                            color: AppColors.secondaryTextColor,
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: AppColors.secondaryTextColor,
                                    fontFamily: 'Poppins')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Delete',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      final id = c.detail.value?.id ?? '';
                      final deleted = await c.deleteSurgery(id);
                      if (deleted && context.mounted) Navigator.pop(context, true);
                    }
                  },
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: c.isDeleting.value
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.red),
                    )
                  : Icon(Icons.delete_outline,
                      color: Colors.red, size: 22.r),
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (c.isLoadingDetail.value) {
          return const _DetailShimmer();
        }
        final d = c.detail.value;
        if (d == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    color: AppColors.secondaryTextColor, size: 48.r),
                SizedBox(height: 12.h),
                CustomText(
                  text: 'Failed to load surgery details',
                  fontsize: 14.sp,
                  color: AppColors.secondaryTextColor,
                ),
              ],
            ),
          );
        }

        final materials = _buildMaterials(d);
        final radiologyImages = _buildRadiology(d);
        final attachments = d.files
            .map((url) => SurgeryAttachment(
                  fileName: url.split('/').last,
                  isPdf: url.toLowerCase().endsWith('.pdf'),
                  url: url,
                ))
            .toList();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        c.prefillForEdit(d);
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  AddSurgeryScreen(surgeryId: d.id)),
                        );
                        if (result == true) {
                          await c.fetchDetail(d.id);
                        }
                      },
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () => PdfHelper.shareSurgeryPdf(d),
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
                                color: AppColors.primaryTextColor, size: 16.r),
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
                            backgroundColor: const Color(0xFF3A3A3A),
                            child: d.physicianProfileUrl.isNotEmpty
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: d.physicianProfileUrl,
                                      width: 80.r,
                                      height: 80.r,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => Icon(
                                          Icons.person,
                                          size: 36.r,
                                          color:
                                              AppColors.secondaryTextColor),
                                    ),
                                  )
                                : Icon(Icons.person,
                                    size: 36.r,
                                    color: AppColors.secondaryTextColor),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Obx(() => GestureDetector(
                              onTap: c.isLoadingPhysician.value
                                  ? null
                                  : () async {
                                      final physician = await c.fetchPhysicianById(d.physicianId);
                                      if (physician != null && context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PhysicianProfileScreen(physician: physician),
                                          ),
                                        );
                                      }
                                    },
                              child: c.isLoadingPhysician.value
                                  ? SizedBox(
                                      width: 18.r,
                                      height: 18.r,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : Icon(Icons.remove_red_eye_outlined,
                                      color: AppColors.primaryColor, size: 18.r),
                            )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: d.physicianName.isNotEmpty ? d.physicianName : '—',
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
                SurgeryInfoRow('Physician',
                    d.physicianName.isNotEmpty ? d.physicianName : '—'),
                SurgeryInfoRow(
                    'PT ID', d.patientId.isNotEmpty ? d.patientId : '—'),
                SurgeryInfoRow('Facility',
                    d.facilityName.isNotEmpty ? d.facilityName : '—'),
                SurgeryInfoRow('Date of Surgery', _formatDate(d.dateOfSurgery)),
                SurgeryInfoRow('Surgery Type',
                    d.surgeryType.isNotEmpty ? d.surgeryType : '—'),
              ]),

              SizedBox(height: 16.h),

              // ── Notes ──────────────────────────────────────────────
              Container(
                width: double.infinity,
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
                      title: 'Notes',
                    ),
                    SizedBox(height: 8.h),
                    d.caseNotes.isNotEmpty
                        ? CustomText(
                            text: d.caseNotes,
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                            textHeight: 1.6,
                          )
                        : CustomText(
                            text: 'No notes added.',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ── Documents ──────────────────────────────────────────
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
                      title: 'Documents',
                    ),
                    if (attachments.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: CustomText(
                          text: 'No documents attached.',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      )
                    else
                      ...attachments.map(
                          (att) => SurgeryAttachmentTile(attachment: att)),
                  ],
                ),
              ),

              if (materials.isNotEmpty) ...[
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
                        trailing: '${materials.length} ITEMS LOGGED',
                      ),
                      SurgeryMaterialsList(materials: materials),
                    ],
                  ),
                ),
              ],

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
                    RadiologyDetailGrid(images: radiologyImages),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              GestureDetector(
                onTap: () {

                },
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
        );
      }),
    );
  }
}

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2E2E),
      highlightColor: const Color(0xFF3A3E3E),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: _shimmerBox(height: 40.h,
                        radius: 8.r)),
                SizedBox(width: 10.w),
                Expanded(
                    child: _shimmerBox(height: 40.h,
                        radius: 8.r)),
              ],
            ),
            SizedBox(height: 16.h),
            _shimmerBox(height: 130.h, radius: 14.r),
            SizedBox(height: 16.h),
            _shimmerBox(height: 24.h, width: 120.w, radius: 4.r),
            SizedBox(height: 8.h),
            _shimmerBox(height: 160.h, radius: 10.r),
            SizedBox(height: 16.h),
            _shimmerBox(height: 24.h, width: 140.w, radius: 4.r),
            SizedBox(height: 8.h),
            _shimmerBox(height: 120.h, radius: 10.r),
            SizedBox(height: 16.h),
            _shimmerBox(height: 24.h, width: 160.w, radius: 4.r),
            SizedBox(height: 8.h),
            _shimmerBox(height: 200.h, radius: 10.r),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(
      {required double height, double? width, required double radius}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
