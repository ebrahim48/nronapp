import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

// ── Section Title ─────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CustomText(
          text: text,
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

// ── Info item (label + value) ─────────────────────────────────────────────────
class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({super.key, required this.label, required this.value});

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

// ── Document row ──────────────────────────────────────────────────────────────
class DocumentRow extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String fileName;
  final String fileSize;
  final String? url;

  const DocumentRow({
    super.key,
    required this.iconColor,
    required this.icon,
    required this.fileName,
    required this.fileSize,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          if (url != null && url!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: CachedNetworkImage(
                imageUrl: url!,
                width: 36.r,
                height: 36.r,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 36.r,
                  height: 36.r,
                  color: const Color(0xFF252525),
                  child: Icon(icon, color: iconColor, size: 18.r),
                ),
                errorWidget: (_, __, ___) => Icon(icon,
                    color: iconColor, size: 24.r),
              ),
            )
          else
            Icon(icon, color: iconColor, size: 24.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: fileName,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: fileSize,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Icon(Icons.download_outlined,
              color: AppColors.secondaryTextColor, size: 20.r),
        ],
      ),
    );
  }
}
