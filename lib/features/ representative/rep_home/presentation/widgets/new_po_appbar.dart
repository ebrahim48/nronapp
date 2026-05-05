import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app-routes/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../../core/custom_widgets/custom_text.dart';

class NewPoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewPoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1E2427),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 56.w,
      leading: GestureDetector(
        onTap: () => context.goNamed(AppRoutes.purchaseOrderScreen),
        child: Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryTextColor,
            size: 20.r,
          ),
        ),
      ),
      title: CustomText(
        text: 'New Purchase Order',
        fontsize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(52.h);
}