import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class TrayFacilityDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const TrayFacilityDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          hint: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/map.svg',
                width: 14.r,
                height: 14.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 10.w),
              CustomText(
                text: 'Select Facility',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          selectedItemBuilder: (context) => options
              .map((o) => Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/map.svg',
                        width: 14.r,
                        height: 14.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.secondaryTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          o,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.sp,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ))
              .toList(),
          dropdownColor: const Color(0xFF1E2121),
          isExpanded: true,
          icon: SvgPicture.asset(
            'assets/icons/chevron.svg',
            width: 16.r,
            height: 16.r,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryTextColor,
              BlendMode.srcIn,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            color: AppColors.primaryTextColor,
          ),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class TraySystemTypeDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const TraySystemTypeDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          hint: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/systemtype.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 10.w),
              CustomText(
                text: 'Select System',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          dropdownColor: const Color(0xFF1E2121),
          isExpanded: true,
          icon: SvgPicture.asset(
            'assets/icons/chevron.svg',
            width: 16.r,
            height: 16.r,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryTextColor,
              BlendMode.srcIn,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            color: AppColors.primaryTextColor,
          ),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
