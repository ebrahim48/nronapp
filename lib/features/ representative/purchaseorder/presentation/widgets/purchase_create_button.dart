import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app-routes/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../controller/purchase_order_controller.dart';


class PoCreateButton extends StatelessWidget {
  const PoCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PurchaseOrderController>();

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.newPoScreen);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: AppColors.primaryTextColor, size: 18.r),
            SizedBox(width: 6.w),
            Text(
              'Create PO',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}