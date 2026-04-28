import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

enum AttachmentType { pdf, docx, image }

class AttachmentTile extends StatelessWidget {
  final String fileName;
  final String? meta;
  final AttachmentType type;
  final bool showPreview;
  final VoidCallback? onDownload;
  final VoidCallback? onPreview;

  const AttachmentTile({
    super.key,
    required this.fileName,
    this.meta,
    this.type = AttachmentType.pdf,
    this.showPreview = false,
    this.onDownload,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    if (showPreview) return _previewCard(context);
    return _listRow(context);
  }


  Widget _previewCard(BuildContext context) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          // Thumbnail placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              height: 110.h,
              color: const Color(0xFF3A3A3A),
              child: Center(
                child: Icon(Icons.picture_as_pdf,
                    color: AppColors.secondaryTextColor, size: 36.r),
              ),
            ),
          ),
          // Eye icon top-right
          Positioned(
            top: 6.r,
            right: 6.r,
            child: GestureDetector(
              onTap: onPreview,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.remove_red_eye_outlined,
                    color: AppColors.primaryColor, size: 14.r),
              ),
            ),
          ),
          // File info at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: fileName,
                    fontsize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                    maxline: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  if (meta != null)
                    CustomText(
                      text: meta!,
                      fontsize: 8.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _listRow(BuildContext context) {
    final Color iconColor =
    type == AttachmentType.pdf ? Colors.red : AppColors.primaryColor;
    final IconData icon =
    type == AttachmentType.pdf ? Icons.picture_as_pdf : Icons.description;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, color: iconColor, size: 16.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: fileName,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                if (meta != null)
                  CustomText(
                    text: meta!,
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDownload,
            child: Icon(Icons.download_outlined,
                color: AppColors.secondaryTextColor, size: 18.r),
          ),
        ],
      ),
    );
  }
}