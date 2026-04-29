import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/surgery_model.dart';

class SurgeryCard extends StatelessWidget {
  final SurgeryModel surgery;
  final VoidCallback? onTap;

  const SurgeryCard({super.key, required this.surgery, this.onTap});

  String _formatDate(String iso) {
    if (iso.isEmpty) return '—';
    try {
      return DateFormat('MM/dd/yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

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
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
              child: Image.asset(
                'assets/images/surgery.png',
                width: double.infinity,
                height: 160.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 160.h,
                  color: const Color(0xFF2A2A2A),
                  child: Icon(Icons.medical_services_outlined,
                      color: const Color(0xFF3A3A3A), size: 40.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: surgery.patientId.isNotEmpty ? surgery.patientId : '—',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: surgery.surgeryType.isNotEmpty ? surgery.surgeryType : '—',
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: AppColors.secondaryTextColor, size: 13.r),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: CustomText(
                          text: surgery.facilityName.isNotEmpty ? surgery.facilityName : '—',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.calendar_today_outlined,
                          color: AppColors.secondaryTextColor, size: 13.r),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: _formatDate(surgery.dateOfSurgery),
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
