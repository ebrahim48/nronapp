import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/core/constants/app_colors.dart';

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Divider(color: AppColors.secondaryTextColor.withValues(alpha: 0.4), thickness: 0.5)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Text(
          'Or login with',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp, color: AppColors.secondaryTextColor),
        ),
      ),
      Expanded(child: Divider(color: AppColors.secondaryTextColor.withValues(alpha: 0.4), thickness: 0.5)),
    ]);
  }
}
