import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/physicians_controller.dart';
import 'widgets/physician_profile_widgets.dart';

class PhysicianProfileScreen extends StatelessWidget {
  final PhysicianItem physician;

  const PhysicianProfileScreen({super.key, required this.physician});

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
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Physician Profile',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
        child: Column(
          children: [
            // ── Profile photo ───────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100.r,
                    height: 100.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 3,
                      ),
                      color: const Color(0xFF1A3A3A),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        physician.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF2A3A3A),
                          child: Icon(Icons.person,
                              color: AppColors.primaryColor, size: 48.r),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4.h,
                    right: 4.w,
                    child: Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF137FEC),
                      ),
                      child:
                          Icon(Icons.check, color: Colors.white, size: 13.r),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            CustomText(
              text: physician.name,
              fontsize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomText(
                text: physician.specialty,
                fontsize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 24.h),

            // ── Basic Info ──────────────────────────────────────────
            SectionTitle(text: 'Basic Info'),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoItem(
                      label: 'Practice Name',
                      value: 'City Hospital, New York'),
                  SizedBox(height: 12.h),
                  InfoItem(label: 'Phone', value: '(212) 555-0198'),
                  SizedBox(height: 12.h),
                  InfoItem(label: 'Cell', value: '(917) 555-0123'),
                  SizedBox(height: 12.h),
                  InfoItem(
                      label: 'Email Address',
                      value: 'j.smith@cityhospital.org'),
                  SizedBox(height: 12.h),
                  InfoItem(label: 'Birthday', value: 'March 14, 1978'),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ── Notes ───────────────────────────────────────────────
            SectionTitle(text: 'Notes'),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: CustomText(
                text:
                    'Highly preferred for complex spinal fusions. Efficient with surgical time and maintains excellent patient outcomes. Follows up personally within 24 hours post-op.',
                fontsize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
                textHeight: 1.6,
              ),
            ),

            SizedBox(height: 20.h),

            // ── Documents ───────────────────────────────────────────
            SectionTitle(text: 'Documents'),

            DocumentRow(
              iconColor: const Color(0xFFEC0101),
              icon: Icons.picture_as_pdf,
              fileName: 'Surgical_Report_Jenkins.pdf',
              fileSize: '1.1 MB',
            ),

            SizedBox(height: 10.h),

            DocumentRow(
              iconColor: const Color(0xFF137FEC),
              icon: Icons.description_outlined,
              fileName: 'Facility_Auth_Letter.docx',
              fileSize: '842 KB',
            ),
          ],
        ),
      ),
    );
  }
}
