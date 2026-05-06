import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class VendorNotifiedBanner extends StatelessWidget {
  final bool notified;
  final String message;

  const VendorNotifiedBanner({
    super.key,
    required this.notified,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2218),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF1A4A2E)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Teal circle icon ──
          Container(
            width: 42.r,
            height: 42.r,
            decoration: const BoxDecoration(
              color: Color(0xFF007A6A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 22.r,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: 'Vendor Notified',
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00C97A),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 6.w),
                    const Text('✅', style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: message,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ReportTrayDetailsCard extends StatelessWidget {
  final String trayId;
  final String vendorName;
  final String issueType;

  const ReportTrayDetailsCard({
    super.key,
    required this.trayId,
    required this.vendorName,
    required this.issueType,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.content_paste_outlined,
                  size: 18.r, color: const Color(0xFF4A90D9)),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Tray Details',
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _DetailField(label: 'Tray ID', value: trayId),
          SizedBox(height: 12.h),
          _DetailField(label: 'Vendor', value: vendorName.isNotEmpty ? vendorName : '—'),
          SizedBox(height: 12.h),
          _DetailField(label: 'Issue Type', value: issueType.isNotEmpty ? issueType[0].toUpperCase() + issueType.substring(1) : '—'),
        ],
      ),
    );
  }
}

class ReportIssueInfoCard extends StatelessWidget {
  final String instrumentName;
  final String notes;
  final String status;

  const ReportIssueInfoCard({
    super.key,
    required this.instrumentName,
    required this.notes,
    this.status = 'MISSING',
  });

  @override
  Widget build(BuildContext context) {
    final label = status.isNotEmpty ? status.toUpperCase() : 'MISSING';
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 18.r, color: const Color(0xFFEC5B13)),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'Issue Info',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A0D0D),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: CustomText(
                  text: label,
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE53935),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          _DetailField(label: 'Instrument', value: instrumentName),
          SizedBox(height: 12.h),
          _DetailField(label: 'Notes', value: notes),
        ],
      ),
    );
  }
}

class ReportEvidenceCard extends StatelessWidget {
  final List<String> files;
  final DateTime capturedAt;

  const ReportEvidenceCard({
    super.key,
    required this.files,
    required this.capturedAt,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.image_outlined,
                      size: 18.r, color: const Color(0xFF4A90D9)),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Uploaded',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        text: 'Evidence',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
              CustomText(
                text: 'Captured ${DateFormat("MMM dd, hh:mm a").format(capturedAt)}',
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.end,
              ),
            ],
          ),

          SizedBox(height: 12.h),

          if (files.isEmpty)
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2E2E),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white24,
                  size: 40.r,
                ),
              ),
            )
          else
            Column(
              children: files.map((url) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF1A2E2E),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white24,
                              size: 40.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}


class ReportActionButtons extends StatelessWidget {
  final VoidCallback onDownloadPdf;
  final VoidCallback onSendEmail;
  final bool isSending;

  const ReportActionButtons({
    super.key,
    required this.onDownloadPdf,
    required this.onSendEmail,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Download PDF ──
        GestureDetector(
          onTap: onDownloadPdf,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2121),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_outlined,
                    size: 18.r, color: AppColors.primaryTextColor),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Download PDF',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // ── Send to Vendor Email ──
        GestureDetector(
          onTap: isSending ? null : onSendEmail,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: isSending
                ? Center(
              child: SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Send to Vendor Email',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 8.w),
                Icon(Icons.send_rounded,
                    size: 18.r, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class ReportSyncFooter extends StatelessWidget {
  final String syncAgo;

  const ReportSyncFooter({super.key, required this.syncAgo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded,
              size: 14.r, color: AppColors.secondaryTextColor),
          SizedBox(width: 6.w),
          CustomText(
            text:
            'Last synchronized with inventory management system $syncAgo.',
            fontsize: 11.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: child,
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  const _DetailField({required this.label, required this.value});

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
        SizedBox(height: 3.h),
        CustomText(
          text: value,
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}