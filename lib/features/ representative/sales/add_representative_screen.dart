import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import 'controller/add_representative_controller.dart';
import 'controller/sales_controller.dart';


class AddRepresentativeScreen extends StatelessWidget {
  const AddRepresentativeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repC = Get.put(AddRepresentativeController());
    final saleC = Get.find<SaleController>();

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
          text: 'Add Representative',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: repC.nameController,
              labelText: 'Representative Name',
              hintText: 'Alex Johnson',
              prefixIcon: Icon(
                Icons.person_outline,
                color: AppColors.secondaryTextColor,
                size: 18.r,
              ),
            ),

            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Rep Role',
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
                        color: AppColors.dotButtonInactiveColor,
                        width: 0.8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: repC.selectedRole.value,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2A2A2A),
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: AppColors.secondaryTextColor,
                          size: 20.r),
                      items: repC.roles
                          .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(
                          r,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (v) =>
                      repC.selectedRole.value = v ?? 'Assist',
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
              ],
            )),
            CustomTextField(
              controller: repC.commissionController,
              labelText: 'Commission %',
              hintText: '\$00.00',
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 50.h),

            CustomButton(
              title: 'Add Representative',
              onpress: () {
                saleC.addRepresentative(repC.build());
                Navigator.pop(context);
              },
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w700,
            ),

            SizedBox(height: 14.h),

            Text(
              'A team is needed when multiple representatives are involved in different parts of the same sales process.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                color: AppColors.secondaryTextColor,
              ),
            ),

            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}