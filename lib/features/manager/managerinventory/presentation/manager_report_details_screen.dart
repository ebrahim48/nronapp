import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_missing_report_controller.dart';

class ManagerReportDetailsScreen extends StatelessWidget {
  final MissingReportItem item;

  const ManagerReportDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: AppColors.primaryTextColor, size: 18.r)),
        title: CustomText(text: 'Report Details', fontsize: 16.sp,
            fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
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
                  _VendorNotifiedBanner(),
                  SizedBox(height: 12.h),
                  _TrayDetailsCard(),
                  SizedBox(height: 12.h),
                  _IssueInfoCard(),
                  SizedBox(height: 12.h),
                  _UploadedEvidenceCard(),
                  SizedBox(height: 16.h),
                  _SyncNote(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
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
                CustomButton(
                  title: 'Send to Vendor Email',
                  onpress: () {

                  },
                  suffixIcon:
                  SvgPicture.asset('assets/icons/createjob.svg',
                      width: 18.r,
                      height: 18.r,
                      colorFilter:
                      const ColorFilter.mode(Colors.black,
                          BlendMode.srcIn)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorNotifiedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A3A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r, height: 36.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            child: Center(child: Icon(Icons.check, color: Colors.white, size: 18.r)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CustomText(text: 'Vendor Notified', fontsize: 14.sp,
                      fontWeight: FontWeight.w700, color: AppColors.primaryColor, textAlign: TextAlign.start),
                  SizedBox(width: 4.w),
                  const Text('✅'),
                ]),
                SizedBox(height: 2.h),
                CustomText(text: 'Notification sent to Medical Logistics Service on Oct 24, 2023',
                    fontsize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start, textHeight: 1.4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrayDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      headerIcon: Icons.inventory_2_outlined,
      headerIconColor: const Color(0xFF137FEC),
      title: 'Tray Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(label: 'ID', value: 'TR-8829'),
          SizedBox(height: 12.h),
          _DetailRow(label: 'Facility', value: 'City Hospital'),
          SizedBox(height: 12.h),
          _DetailRow(label: 'Location', value: 'Central Sterile Zone A'),
        ],
      ),
    );
  }
}

class _IssueInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      headerIcon: Icons.warning_amber_rounded,
      headerIconColor: const Color(0xFFEC0101),
      title: 'Issue Info',
      badge: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: const Color(0xFFEC0101),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: CustomText(text: 'MISSING', fontsize: 10.sp, fontWeight: FontWeight.w700,
            color: Colors.white, textAlign: TextAlign.center),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(label: 'Instrument', value: 'Gibbon Lees Custom'),
          SizedBox(height: 12.h),
          _DetailRow(label: 'Notes', value: "'2 forceps and 1 scissors missing from tray.'"),
        ],
      ),
    );
  }
}

class _UploadedEvidenceCard extends StatelessWidget {
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
        children: [
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.image_outlined, color: AppColors.primaryColor, size: 18.r),
                  SizedBox(width: 8.w),
                  CustomText(text: 'Uploaded\nEvidence', fontsize: 13.sp,
                      fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                ]),
                CustomText(text: 'Captured Oct 24, 08:12 AM', fontsize: 11.sp,
                    fontWeight: FontWeight.w400, color: AppColors.secondaryTextColor, textAlign: TextAlign.end),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
            child: Image.asset(
              'assets/images/tray.jpg',
              width: double.infinity,
              height: 180.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180.h,
                color: const Color(0xFF2A3A3A),
                child: Center(child: Icon(Icons.image_outlined, color: AppColors.secondaryTextColor, size: 40.r)),
              ),
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
          text: 'Last synchronized with inventory management system 4 minutes ago.',
          fontsize: 11.sp, fontWeight: FontWeight.w400,
          color: AppColors.secondaryTextColor, textAlign: TextAlign.center, textHeight: 1.4,
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
                CustomText(text: title, fontsize: 14.sp, fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor, textAlign: TextAlign.start),
              ]),
              if (badge != null) badge!,
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: const Color(0xFF3A3A3A), thickness: 0.5, height: 1),
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
            textAlign: TextAlign.start),
        SizedBox(height: 2.h),
        CustomText(
            text: value,
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start),
      ],
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OutlinedActionButton({required this.icon, required this.label, required this.onTap});

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
          CustomText(text: label, fontsize: 14.sp, fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}