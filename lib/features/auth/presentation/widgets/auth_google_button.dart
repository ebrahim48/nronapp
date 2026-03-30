import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nron_app/core/constants/app_colors.dart';

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 345.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.secondaryTextColor.withValues(alpha: 0.4), width: 0.8),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset('assets/icons/google.svg', width: 18.r, height: 18.r),
          SizedBox(width: 10.w),
          Text(
            'Continue with Google',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.primaryTextColor),
          ),
        ]),
      ),
    );
  }
}
