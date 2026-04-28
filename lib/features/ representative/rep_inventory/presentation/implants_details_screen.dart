import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/attachment_tile.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../model/implant_model.dart';


class ImplantDetailsScreen extends StatelessWidget {
  final ImplantModel implant;

  const ImplantDetailsScreen({super.key, required this.implant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Implant Details',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 160.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: double.infinity,
                    height: 200.h,
                    color: const Color(0xFF252525),
                    child: implant.imageAsset != null
                        ? Image.asset(implant.imageAsset!, fit: BoxFit.cover)
                        : Image.asset(
                      'assets/images/implants.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                _SectionHeader(
                  title: 'General Information',
                  badge: _StatusBadge(status: implant.status),
                ),
                SizedBox(height: 10.h),
                _InfoCard(rows: [
                  _InfoRow(
                    icon: Icons.grid_view,
                    label: 'Serial Number',
                    value: implant.serialNumber,
                  ),
                  _InfoRow(
                    icon: Icons.tune,
                    label: 'System Type',
                    value: implant.systemType,
                  ),
                  _InfoRow(
                    icon: Icons.business_outlined,
                    label: 'Vendor',
                    value: implant.vendor,
                  ),
                  _InfoRow(
                    icon: Icons.info_outline,
                    label: 'Status',
                    value: 'Available',
                    valueColor: const Color(0xFF00D500),
                    valueDot: true,
                  ),
                ]),
                SizedBox(height: 16.h),

                _SectionHeader(title: 'Location & Logistics'),
                SizedBox(height: 10.h),
                _InfoCard(rows: [
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Facility',
                    value: implant.facility,
                  ),
                  _InfoRow(
                    icon: Icons.info_outline,
                    label: 'Recipient Email',
                    value: implant.recipientEmail,
                  ),
                ]),
                SizedBox(height: 16.h),
                _SectionHeader(title: 'Additional Note'),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: CustomText(
                    text: implant.additionalNote ??
                        'No additional notes available.',
                    fontsize: 12.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                    textHeight: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),

                _SectionHeader(title: 'Uploaded Files'),
                SizedBox(height: 10.h),
                ...() {
                  final inbound = implant.uploadedFiles
                      .where((f) => f.category == 'inbound_image')
                      .toList();
                  final broken = implant.uploadedFiles
                      .where((f) => f.category == 'broken_instruments')
                      .toList();

                  return [
                    if (inbound.isNotEmpty) ...[
                      CustomText(
                        text: 'Inbound Image',
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                        bottom: 6.h,
                      ),
                      ...inbound.map((f) => AttachmentTile(
                        fileName: f.fileName,
                        meta: '${f.size} • ${f.date}',
                        type: AttachmentType.pdf,
                        onDownload: () {},
                        onPreview: () {},
                      )),
                    ],
                    if (broken.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      CustomText(
                        text: 'Broken Instruments',
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                        bottom: 6.h,
                      ),
                      ...broken.map((f) => AttachmentTile(
                        fileName: f.fileName,
                        meta: '${f.size} • ${f.date}',
                        type: AttachmentType.pdf,
                        onDownload: () {},
                      )),
                    ],
                    if (implant.uploadedFiles.isEmpty)
                      CustomText(
                        text: 'No files uploaded.',
                        fontsize: 12.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                  ];
                }(),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.backgroundColor,
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Create Implant Sale
                  CustomButton(
                    title: 'Create Implant Sale',
                    prefixIcon: Icon(Icons.person_add_alt_1_outlined,
                        color: AppColors.primaryTextColor, size: 18.r),
                    onpress: () => context.pushNamed(
                      AppRoutes.createImplantSaleScreen,
                      extra: implant,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      // Ship
                      Expanded(
                        child: CustomButton(
                          title: 'Ship',
                          color: const Color(0xFF252525),
                          borderColor: AppColors.dotButtonInactiveColor,
                          prefixIcon: Icon(Icons.local_shipping_outlined,
                              color: AppColors.primaryTextColor, size: 16.r),
                          onpress: () => context.pushNamed(
                            AppRoutes.createShipmentFromImplantScreen,
                            extra: implant,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Transfer
                      Expanded(
                        child: CustomButton(
                          title: 'Transfer',
                          color: const Color(0xFF252525),
                          borderColor: AppColors.dotButtonInactiveColor,
                          prefixIcon: Icon(Icons.swap_horiz,
                              color: AppColors.primaryTextColor, size: 16.r),
                          onpress: () => context.pushNamed(
                            AppRoutes.transferImplantScreen,
                            extra: implant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? badge;

  const _SectionHeader({required this.title, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        if (badge != null) badge!,
      ],
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: rows
            .map((r) => Column(
          children: [
            r,
            if (rows.indexOf(r) < rows.length - 1)
              Divider(
                  color: const Color(0xFF3A3A3A),
                  height: 1,
                  thickness: 0.5),
          ],
        ))
            .toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueDot;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 16.r),
          SizedBox(width: 10.w),
          CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          const Spacer(),
          if (valueDot)
            Container(
              width: 7.r,
              height: 7.r,
              margin: EdgeInsets.only(right: 5.w),
              decoration: BoxDecoration(
                color: valueColor ?? const Color(0xFF00D500),
                shape: BoxShape.circle,
              ),
            ),
          CustomText(
            text: value,
            fontsize: 12.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.primaryTextColor,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bg = status == 'in_stock' || status == 'available'
        ? AppColors.primaryColor
        : AppColors.secondaryTextColor;
    final label = status == 'in_stock'
        ? 'In Stock'
        : status == 'available'
        ? 'In Stock'
        : status;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        border: Border.all(color: bg, width: 0.8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: label,
        fontsize: 11.sp,
        fontWeight: FontWeight.w600,
        color: bg,
      ),
    );
  }
}