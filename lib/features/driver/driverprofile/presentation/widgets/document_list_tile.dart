import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/profile_model.dart';


class DocumentListTile extends StatelessWidget {
  final DocumentItemModel document;
  final VoidCallback onTap;
  final bool isLast;

  const DocumentListTile({
    super.key,
    required this.document,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUploaded = document.status == DocumentStatus.uploaded;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline dots + line
          SizedBox(
            width: 24.w,
            child: Column(
              children: [
                Container(
                  width: 10.r,
                  height: 10.r,
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? AppColors.primaryColor
                        : AppColors.secondaryTextColor
                        .withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: isUploaded
                        ? null
                        : Border.all(
                      color: AppColors.secondaryTextColor,
                      width: 1,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5.w,
                      color: const Color(0xFF3A3A3A),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Card
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    // Document image
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2427),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          document.imageAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.description_outlined,
                            color: AppColors.primaryColor,
                            size: 22.r,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Title + status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: document.title,
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 3.h),
                          CustomText(
                            text: isUploaded
                                ? 'Uploaded'
                                : 'Not Uploaded',
                            fontsize: 11.sp,
                            color: isUploaded
                                ? const Color(0xFF4ADE80)
                                : AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),

                    // Checkmark or arrow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isUploaded)
                          Container(
                            width: 20.r,
                            height: 20.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ADE80),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check,
                                color: Colors.white, size: 12.r),
                          )
                        else
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.secondaryTextColor,
                              size: 14.r),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}