import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/surgery_controller.dart';

class FacilityDropdown extends StatelessWidget {
  const FacilityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SurgeryController>();

    return Obx(() {
      if (c.isLoadingFacilities.value) {
        return Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFF2A2E2E),
            highlightColor: const Color(0xFF3A3E3E),
            child: Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2E2E),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Facility',
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
                Icon(Icons.local_hospital_outlined,
                    color: AppColors.secondaryTextColor, size: 18.r),
                SizedBox(width: 8.w),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: c.selectedFacilityId.value.isEmpty
                          ? null
                          : c.selectedFacilityId.value,
                      hint: Text(
                        c.facilities.isEmpty
                            ? 'No facilities available'
                            : 'Select a facility',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2A2A2A),
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: AppColors.secondaryTextColor, size: 20.r),
                      items: c.facilities
                          .map((f) => DropdownMenuItem<String>(
                                value: f.id,
                                child: Text(
                                  f.name,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (id) {
                        if (id == null) return;
                        final facility =
                            c.facilities.firstWhere((f) => f.id == id);
                        c.selectFacility(id, facility.name);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
        ],
      );
    });
  }
}
