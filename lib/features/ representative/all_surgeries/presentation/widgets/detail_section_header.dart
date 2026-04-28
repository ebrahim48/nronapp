import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';

class DetailSectionHeader extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? trailing;

  const DetailSectionHeader({
    super.key,
    required this.iconPath,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 18.r,
            height: 18.r,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'Poppins',
                color: AppColors.secondaryTextColor,
              ),
            ),
        ],
      ),
    );
  }
}