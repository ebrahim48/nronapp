import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/settings_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserProfileModel profile;
  final bool showRating;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    this.showRating = false,
  });

  Future<void> _pickImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with camera icon
        Stack(
          children: [
            CircleAvatar(
              radius: 46.r,
              backgroundImage: profile.avatarAsset != null
                  ? AssetImage(profile.avatarAsset!)
                  : null,
              backgroundColor: const Color(0xFF3A3A3A),
              child: profile.avatarAsset == null
                  ? Icon(Icons.person,
                  size: 40.r, color: AppColors.secondaryTextColor)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
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
          text: profile.name,
          fontsize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
        ),

        SizedBox(height: 4.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            text: profile.role,
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
        ),

        SizedBox(height: 4.h),

        CustomText(
          text: profile.company,
          fontsize: 13.sp,
          color: AppColors.secondaryTextColor,
        ),
      ],
    );
  }
}