import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../domain/model/physician_model.dart';

class PhysicianCard extends StatelessWidget {
  final PhysicianModel physician;
  final VoidCallback onTap;
  final VoidCallback onAddSurgeries;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PhysicianCard({
    super.key,
    required this.physician,
    required this.onTap,
    required this.onAddSurgeries,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: physician.profileUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: physician.profileUrl,
                      width: 56.r,
                      height: 56.r,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _avatarPlaceholder(),
                      errorWidget: (_, __, ___) => _avatarPlaceholder(),
                    )
                  : _avatarPlaceholder(),
            ),
            SizedBox(width: 12.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: physician.fullName,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: _specialtyDisplay(physician.specialty),
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/map.svg',
                        width: 11.r,
                        height: 11.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.secondaryTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: CustomText(
                          text: physician.practice,
                          fontsize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 3-dot popup menu
            _PhysicianPopupMenu(
              onAddSurgeries: onAddSurgeries,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 56.r,
      height: 56.r,
      decoration: BoxDecoration(
        color: const Color(0xFF2A3A3A),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(Icons.person, color: AppColors.primaryColor, size: 28.r),
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
}

class _PhysicianPopupMenu extends StatelessWidget {
  final VoidCallback onAddSurgeries;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PhysicianPopupMenu({
    required this.onAddSurgeries,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_vert,
        color: AppColors.secondaryTextColor,
        size: 20.r,
      ),
      color: const Color(0xFF1E2121),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      constraints: BoxConstraints(minWidth: 122.w, maxWidth: 122.w),
      onSelected: (value) {
        if (value == 'surgeries') onAddSurgeries();
        if (value == 'edit') onEdit();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (ctx) => [
        PopupMenuItem<String>(
          value: 'surgeries',
          padding: EdgeInsets.zero,
          height: 32.h,
          child: Container(
            width: 122.w,
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: const BoxDecoration(
              color: Color(0x4D00D5ED),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.medical_services_outlined,
                    size: 14.r, color: const Color(0xFF00D5ED)),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Add Surgeries',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF00D5ED),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          padding: EdgeInsets.zero,
          height: 32.h,
          child: Container(
            width: 122.w,
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            color: const Color(0xFF2A2E2E),
            child: Row(
              children: [
                Icon(Icons.edit_outlined,
                    size: 14.r, color: const Color(0xFFF2F2F2)),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Edit Physician',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF2F2F2),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          padding: EdgeInsets.zero,
          height: 32.h,
          child: Container(
            width: 122.w,
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: const BoxDecoration(
              color: Color(0xFF2A2E2E),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.delete_outline,
                    size: 14.r, color: const Color(0xFFFF4D4F)),
                SizedBox(width: 8.w),
                CustomText(
                  text: 'Delete',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF4D4F),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
