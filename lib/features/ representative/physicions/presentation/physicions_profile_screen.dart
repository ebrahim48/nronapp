import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../domain/model/physician_model.dart';
import 'widgets/physician_profile_widgets.dart';

class PhysicianProfileScreen extends StatelessWidget {
  final PhysicianModel physician;

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
                      child: physician.profileUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: physician.profileUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => _profilePlaceholder(),
                              errorWidget: (_, __, ___) =>
                                  _profilePlaceholder(),
                            )
                          : _profilePlaceholder(),
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
              text: physician.fullName,
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
                text: _specialtyDisplay(physician.specialty),
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
                    value: physician.practice.isNotEmpty
                        ? physician.practice
                        : '—',
                  ),
                  SizedBox(height: 12.h),
                  InfoItem(
                    label: 'Phone',
                    value: physician.contactInfo.phoneNumber.isNotEmpty
                        ? physician.contactInfo.phoneNumber
                        : '—',
                  ),
                  SizedBox(height: 12.h),
                  InfoItem(
                    label: 'Cell',
                    value: physician.contactInfo.cellNumber.isNotEmpty
                        ? physician.contactInfo.cellNumber
                        : '—',
                  ),
                  SizedBox(height: 12.h),
                  InfoItem(
                    label: 'Email Address',
                    value: physician.contactInfo.email.isNotEmpty
                        ? physician.contactInfo.email
                        : '—',
                  ),
                  SizedBox(height: 12.h),
                  InfoItem(
                    label: 'Birthday',
                    value: _formatDob(physician.contactInfo.dateOfBirth),
                  ),
                  if (physician.location.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    InfoItem(label: 'Location', value: physician.location),
                  ],
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ── Notes ───────────────────────────────────────────────
            if (physician.noteToSelf.isNotEmpty) ...[
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
                  text: physician.noteToSelf,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  textHeight: 1.6,
                ),
              ),
              SizedBox(height: 20.h),
            ],

            // ── Documents ───────────────────────────────────────────
            if (physician.documents.isNotEmpty) ...[
              SectionTitle(text: 'Documents'),
              ...physician.documents.asMap().entries.map((entry) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: DocumentRow(
                      iconColor: const Color(0xFF137FEC),
                      icon: Icons.image_outlined,
                      fileName: _fileNameFromUrl(entry.value),
                      fileSize: 'Document ${entry.key + 1}',
                      url: entry.value,
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _profilePlaceholder() {
    return Container(
      color: const Color(0xFF2A3A3A),
      child: Icon(Icons.person, color: AppColors.primaryColor, size: 48.r),
    );
  }

  String _specialtyDisplay(String specialty) {
    const map = {
      'ortho': 'Orthopedic',
      'neuro': 'Neuro',
      'pain': 'Pain',
      'ortho/spine': 'Ortho/Spine',
      'peds': 'Pediatrician',
      'dmp': 'DPM',
    };
    return map[specialty.toLowerCase()] ?? specialty;
  }

  String _formatDob(String isoDate) {
    if (isoDate.isEmpty) return '—';
    try {
      final dt = DateTime.parse(isoDate);
      return DateFormat('MMMM d, yyyy').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  String _fileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final segments = uri?.pathSegments ?? [];
    return segments.isNotEmpty ? segments.last : 'document';
  }
}
