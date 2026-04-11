import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_sales_model.dart';

class SaleAttachmentTile extends StatelessWidget {
  final SaleAttachmentItem attachment;

  const SaleAttachmentTile({super.key, required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: attachment.isPdf
                  ? AppColors.redColorFF1D1D.withValues(alpha: 0.15)
                  : AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              attachment.isPdf
                  ? Icons.picture_as_pdf_outlined
                  : Icons.image_outlined,
              color: attachment.isPdf
                  ? AppColors.redColorFF1D1D
                  : AppColors.primaryColor,
              size: 18.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: attachment.fileName,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: '${attachment.size} • ${attachment.date}',
                  fontsize: 10.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Icon(Icons.remove_red_eye_outlined,
              color: AppColors.primaryColor, size: 20.r),
        ],
      ),
    );
  }
}