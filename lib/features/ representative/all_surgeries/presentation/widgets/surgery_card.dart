import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/surgery_model.dart';

class SurgeryCard extends StatelessWidget {
  final SurgeryModel surgery;
  final VoidCallback? onTap;

  const SurgeryCard({super.key, required this.surgery, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
              child: surgery.imageAsset != null
                  ? Image.asset(
                surgery.imageAsset!,
                width: double.infinity,
                height: 160.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/surgery.png',
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                'assets/images/surgery.png',
                width: double.infinity,
                height: 160.h,
                fit: BoxFit.cover,
              ),
            ),

            // Info
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: surgery.patientName,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: surgery.procedureName,
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: AppColors.secondaryTextColor,
                          size: 13.r),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: surgery.facility,
                        fontsize: 11.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.calendar_today_outlined,
                          color: AppColors.secondaryTextColor,
                          size: 13.r),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: surgery.dateTime,
                        fontsize: 11.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}