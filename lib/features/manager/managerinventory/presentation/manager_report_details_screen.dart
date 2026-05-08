import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_missing_report_controller.dart';

class ManagerReportDetailsScreen extends StatelessWidget {
  final MissingReportItem item;

  const ManagerReportDetailsScreen({super.key, required this.item});

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerMissingReportController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Column(
                children: [
                  // ── Vendor notified banner ───────────────────────────
                  _VendorNotifiedBanner(isSent: item.isSentToVendor),
                  SizedBox(height: 12.h),

                  // ── Tray details ─────────────────────────────────────
                  _SectionCard(
                    headerIcon: Icons.inventory_2_outlined,
                    headerIconColor: const Color(0xFF137FEC),
                    title: 'Tray Details',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                            label: 'Tray ID',
                            value: item.trayTitle ?? item.trayId),
                        SizedBox(height: 12.h),
                        _DetailRow(
                            label: 'Facility', value: item.facilityName),
                        SizedBox(height: 12.h),
                        _DetailRow(
                            label: 'Reported By', value: item.user),
                        SizedBox(height: 12.h),
                        _DetailRow(
                            label: 'Date',
                            value: _formatDate(item.date)),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Issue info ───────────────────────────────────────
                  _SectionCard(
                    headerIcon: Icons.warning_amber_rounded,
                    headerIconColor: const Color(0xFFEC0101),
                    title: 'Issue Info',
                    badge: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC0101),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: CustomText(
                        text: item.issueType.toUpperCase(),
                        fontsize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                            label: 'Instrument',
                            value: item.instrumentName),
                        if ((item.descriptionAndNotes ?? '').isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          _DetailRow(
                              label: 'Notes',
                              value: item.descriptionAndNotes!),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Vendor info ──────────────────────────────────────
                  if (item.vendorName != null)
                    _SectionCard(
                      headerIcon: Icons.business_outlined,
                      headerIconColor: AppColors.primaryColor,
                      title: 'Vendor Info',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailRow(
                              label: 'Name',
                              value: item.vendorName ?? ''),
                          if ((item.vendorEmail ?? '').isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            _DetailRow(
                                label: 'Email',
                                value: item.vendorEmail!),
                          ],
                          if ((item.vendorPhone ?? '').isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            _DetailRow(
                                label: 'Phone',
                                value: item.vendorPhone!),
                          ],
                        ],
                      ),
                    ),

                  if (item.vendorName != null) SizedBox(height: 12.h),

                  // ── Uploaded evidence ────────────────────────────────
                  if (item.files.isNotEmpty)
                    _UploadedEvidenceCard(files: item.files),

                  if (item.files.isNotEmpty) SizedBox(height: 16.h),

                  _SyncNote(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),

          // ── Bottom actions ───────────────────────────────────────────
          Container(
            color: AppColors.backgroundColor,
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
            child: Column(
              children: [
                _OutlinedActionButton(
                  icon: Icons.download_outlined,
                  label: 'Download PDF',
                  onTap: () {},
                ),
                SizedBox(height: 10.h),
                Obx(() => CustomButton(
                      title: item.isSentToVendor
                          ? 'Already Sent to Vendor'
                          : 'Send to Vendor Email',
                      loading: c.isSendingMail.value,
                      onpress: item.isSentToVendor
                          ? () {}
                          : () => c.sendVendorMail(item.id),
                      suffixIcon: SvgPicture.asset(
                        'assets/icons/createjob.svg',
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _VendorNotifiedBanner extends StatelessWidget {
  final bool isSent;
  const _VendorNotifiedBanner({required this.isSent});

  @override
  Widget build(BuildContext context) {
    final color = isSent ? AppColors.primaryColor : AppColors.secondaryTextColor;
    final label = isSent ? 'Vendor Notified ✅' : 'Vendor Not Yet Notified';
    final subtitle = isSent
        ? 'Notification has been sent to the vendor.'
        : 'Tap "Send to Vendor Email" below to notify the vendor.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(
              child: Icon(
                isSent ? Icons.check : Icons.info_outline,
                color: Colors.white,
                size: 18.r,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: label,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: subtitle,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  textHeight: 1.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadedEvidenceCard extends StatelessWidget {
  final List<String> files;
  const _UploadedEvidenceCard({required this.files});

  bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Icon(Icons.image_outlined,
                    color: AppColors.primaryColor, size: 18.r),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Uploaded Evidence',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: files.map((url) {
                if (_isImage(url)) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      url,
                      width: 80.r,
                      height: 80.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80.r,
                        height: 80.r,
                        color: const Color(0xFF2A2A2A),
                        child: Icon(Icons.broken_image_outlined,
                            color: Colors.white24, size: 24.r),
                      ),
                    ),
                  );
                }
                // Non-image file (PDF etc.)
                return Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insert_drive_file_outlined,
                          color: AppColors.primaryColor, size: 28.r),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: 'File',
                        fontsize: 10.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.history, color: AppColors.secondaryTextColor, size: 16.r),
        SizedBox(height: 4.h),
        CustomText(
          text:
              'Last synchronized with inventory management system 4 minutes ago.',
          fontsize: 11.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.center,
          textHeight: 1.4,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData headerIcon;
  final Color headerIconColor;
  final String title;
  final Widget child;
  final Widget? badge;

  const _SectionCard({
    required this.headerIcon,
    required this.headerIconColor,
    required this.title,
    required this.child,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(headerIcon, color: headerIconColor, size: 18.r),
                SizedBox(width: 8.w),
                CustomText(
                  text: title,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ]),
              if (badge != null) badge!,
            ],
          ),
          SizedBox(height: 12.h),
          Divider(
              color: const Color(0xFF3A3A3A), thickness: 0.5, height: 1),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontsize: 11.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 2.h),
        CustomText(
          text: value.isNotEmpty ? value : '—',
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OutlinedActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: AppColors.primaryTextColor, size: 18.r),
          SizedBox(width: 8.w),
          CustomText(
            text: label,
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }
}
