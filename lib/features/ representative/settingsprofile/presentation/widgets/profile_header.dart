import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/setting_controller.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final SettingsController c;

  const ProfileHeaderWidget({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final p = c.profile.value;
      final picked = c.selectedImage.value;

      ImageProvider? imageProvider;
      if (picked != null) {
        imageProvider = FileImage(picked);
      } else if (p?.profileUrl != null && p!.profileUrl!.isNotEmpty) {
        imageProvider = NetworkImage(p.profileUrl!);
      }

      return Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 46.r,
                backgroundColor: const Color(0xFF3A3A3A),
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(Icons.person,
                        size: 40.r, color: AppColors.secondaryTextColor)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: c.pickImage,
                  child: Container(
                    width: 26.r,
                    height: 26.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.backgroundColor, width: 2),
                    ),
                    child: Icon(Icons.camera_alt,
                        color: AppColors.blackColor, size: 13.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: p?.fullName ?? '',
            fontsize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
          SizedBox(height: 4.h),
          if ((p?.role ?? '').isNotEmpty)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomText(
                text: p!.role,
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          if ((p?.designation ?? '').isNotEmpty) ...[
            SizedBox(height: 4.h),
            CustomText(
              text: p!.designation!,
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
            ),
          ],
        ],
      );
    });
  }
}
