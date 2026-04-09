import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/app-routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/surgery_controller.dart';


class PhysicianDropdown extends StatelessWidget {
  const PhysicianDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Physician',
          fontsize: 13.sp,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
          bottom: 6.h,
          left: 2.w,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color(0x1A4A4A4A),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
                color: AppColors.dotButtonInactiveColor, width: 0.8),
          ),
          child: Row(
            children: [
              Icon(Icons.person_outline,
                  color: AppColors.secondaryTextColor, size: 18.r),
              SizedBox(width: 8.w),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: c.selectedPhysician.value.isEmpty
                        ? null
                        : c.selectedPhysician.value,
                    hint: Text(
                      'Dr. Jane Smith',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2A2A2A),
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: AppColors.secondaryTextColor, size: 20.r),
                    items: c.physicians
                        .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ))
                        .toList(),
                    onChanged: (v) {
                      c.selectedPhysician.value = v ?? '';
                      context.pushNamed(AppRoutes.surgeryDetailScreen);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
      ],
    ));
  }
}