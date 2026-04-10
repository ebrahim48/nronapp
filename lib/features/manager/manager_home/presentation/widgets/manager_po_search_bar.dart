import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../manager_controller/manager_po_controller.dart';

class ManagerPOSearchBar extends StatelessWidget {
  const ManagerPOSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerPOController>();

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: TextField(
        onChanged: c.onSearchChanged,
        style: TextStyle(
          fontSize: 13.sp,
          fontFamily: 'Poppins',
          color: AppColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: 'Search by PO#, Surgeon, or facility',
          hintStyle: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            color: AppColors.secondaryTextColor,
          ),
          prefixIcon: Icon(Icons.search,
              color: AppColors.secondaryTextColor, size: 20.r),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}