import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class DriverAvatar extends StatelessWidget {
  final String initial;
  final bool isOnline;
  final double size;

  const DriverAvatar({
    super.key,
    required this.initial,
    required this.isOnline,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size.r,
          height: size.r,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomText(
              text: initial,
              fontsize: (size * 0.4).sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        // Online dot
        Positioned(
          bottom: 2.r,
          right: 2.r,
          child: Container(
            width: 14.r,
            height: 14.r,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF4ADE80)
                  : AppColors.secondaryTextColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.backgroundColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}