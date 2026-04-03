import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../../core/custom_widgets/custom_text_field.dart';

class TrayFieldLabel extends StatelessWidget {
  final String text;
  final bool isTeal;

  const TrayFieldLabel({super.key, required this.text, this.isTeal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: text,
        fontsize: 13.sp,
        fontWeight: FontWeight.w600,
        color: isTeal ? AppColors.primaryColor : AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class TrayIconTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? iconPath;
  final double iconSize;
  final bool hasDropdown;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const TrayIconTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.iconPath,
    this.iconSize = 16,
    this.hasDropdown = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLine: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      prefixIcon: iconPath != null
          ? SvgPicture.asset(
              iconPath!,
              width: iconSize.r,
              height: iconSize.r,
              colorFilter: const ColorFilter.mode(
                AppColors.secondaryTextColor,
                BlendMode.srcIn,
              ),
            )
          : null,
      suffixIcon: hasDropdown
          ? SvgPicture.asset(
              'assets/icons/chevron.svg',
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                AppColors.secondaryTextColor,
                BlendMode.srcIn,
              ),
            )
          : null,
    );
  }
}

class TrayReturnDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const TrayReturnDateField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0x331AC8DB), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: true,
              onTap: onTap,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  color: AppColors.secondaryTextColor,
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/icons/calendar.svg',
            width: 16.r,
            height: 16.r,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryTextColor,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
