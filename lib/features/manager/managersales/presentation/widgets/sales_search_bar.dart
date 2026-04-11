import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/manager_sales_controller.dart';

class SalesSearchBar extends StatelessWidget {
  const SalesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerSaleController>();

    return Row(
      children: [
        Expanded(
          child: Container(
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
                hintText: 'Search Sale ID, Rep, or Doctor...',
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
          ),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/filter.svg',
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                AppColors.secondaryTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}