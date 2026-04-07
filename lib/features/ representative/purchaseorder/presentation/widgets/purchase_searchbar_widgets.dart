import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/purchase_order_controller.dart';

class PoSearchBar extends StatelessWidget {
  const PoSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PurchaseOrderController>();

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        onChanged: controller.onSearchChanged,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.primaryTextColor,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: 'Search by PO#, Surgeon, or facility',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: AppColors.secondaryTextColor,
            fontFamily: 'Poppins',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.secondaryTextColor,
            size: 20.r,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 17.h),
        ),
      ),
    );
  }
}