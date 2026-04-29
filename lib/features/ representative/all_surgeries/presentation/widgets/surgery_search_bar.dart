import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../controller/surgery_controller.dart';

class SurgerySearchBar extends StatelessWidget {
  const SurgerySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: TextField(
        onChanged: c.onSearch,
        style: TextStyle(
          fontSize: 13.sp,
          fontFamily: 'Poppins',
          color: AppColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: 'Search by patient, facility or procedure...',
          hintStyle: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            color: AppColors.secondaryTextColor,
          ),
          prefixIcon: Icon(Icons.search,
              color: AppColors.secondaryTextColor, size: 20.r),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 17.h),
        ),
      ),
    );
  }
}