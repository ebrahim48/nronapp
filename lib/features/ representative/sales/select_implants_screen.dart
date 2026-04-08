import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../core/custom_widgets/custom_button.dart';
import 'controller/sales_controller.dart';
import 'model/sales_model.dart';


class SelectImplantsScreen extends StatelessWidget {
  const SelectImplantsScreen({super.key});

  Color _availabilityColor(ImplantAvailability a) {
    switch (a) {
      case ImplantAvailability.available:
        return const Color(0xFF1DB954);
      case ImplantAvailability.inStock:
        return AppColors.primaryColor;
      case ImplantAvailability.backordered:
        return AppColors.redColorFF1D1D;
    }
  }

  String _availabilityLabel(ImplantAvailability a) {
    switch (a) {
      case ImplantAvailability.available:
        return 'Available';
      case ImplantAvailability.inStock:
        return 'In Stock';
      case ImplantAvailability.backordered:
        return 'Backordered';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SaleController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Select Implants',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(10.r),
                      border:
                      Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: TextField(
                      onChanged: (v) => c.implantSearchQuery.value = v,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search name Serial number ...',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.secondaryTextColor,
                        ),
                        prefixIcon: Icon(Icons.search,
                            color: AppColors.secondaryTextColor,
                            size: 18.r),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 13.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Icon(Icons.tune,
                      color: AppColors.secondaryTextColor, size: 20.r),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => ListView.separated(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 4.h),
              itemCount: c.filteredImplants.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final item = c.filteredImplants[index];
                final realIndex = c.allImplants.indexOf(item);
                return GestureDetector(
                  onTap: () => c.toggleImplant(realIndex),
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF242424),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: item.isSelected
                            ? AppColors.primaryColor
                            : const Color(0xFF3A3A3A),
                        width: item.isSelected ? 1.5 : 0.8,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkbox
                        Container(
                          width: 22.r,
                          height: 22.r,
                          decoration: BoxDecoration(
                            color: item.isSelected
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(4.r),
                            border: Border.all(
                              color: item.isSelected
                                  ? AppColors.primaryColor
                                  : const Color(0xFF5A5A5A),
                              width: 1.5,
                            ),
                          ),
                          child: item.isSelected
                              ? Icon(Icons.check,
                              color: AppColors.blackColor,
                              size: 14.r)
                              : null,
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: item.name,
                                    fontsize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: _availabilityColor(
                                          item.availability)
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                      BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      _availabilityLabel(
                                          item.availability),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        color: _availabilityColor(
                                            item.availability),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomText(
                                text:
                                '${item.serial} • ${item.material}',
                                fontsize: 11.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color:
                                      AppColors.secondaryTextColor,
                                      size: 13.r),
                                  SizedBox(width: 4.w),
                                  CustomText(
                                    text: item.location,
                                    fontsize: 11.sp,
                                    color: AppColors.secondaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Obx(() => CustomButton(
              title:
              '+ Add Selected Items (${c.selectedImplantCount})',
              onpress: () {
                c.confirmSelectedImplants();
                Navigator.pop(context);
              },
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            )),
          ),
          SizedBox(height: 100.h)


        ],
      ),
    );
  }
}