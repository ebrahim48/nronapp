import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/surgery_model.dart';

class SurgeryAttachmentTile extends StatelessWidget {
  final SurgeryAttachment attachment;

  const SurgeryAttachmentTile({super.key, required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3A),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF2A3A4A)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/attachments.svg',
            width: 18.r,
            height: 18.r,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              text: attachment.fileName,
              fontsize: 13.sp,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          Icon(Icons.download_outlined,
              color: AppColors.primaryColor, size: 20.r),
        ],
      ),
    );
  }
}
