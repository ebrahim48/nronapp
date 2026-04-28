import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/add_bio_inventory_controller.dart';

class AddBioInventoryScreen extends StatelessWidget {
  const AddBioInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddBioInventoryController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              SizedBox(height: 12.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios,
                        color: AppColors.primaryTextColor, size: 18.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'Add Bio Inventory Item',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Item Name
              _FieldLabel(text: 'Item Name'),
              CustomTextField(
                controller: c.itemNameController,
                hintText: 'e.g. Reagent A',
              ),

              SizedBox(height: 16.h),

              // Vendor
              _FieldLabel(text: 'Vendor'),
              Obx(() => _VendorDropdown(
                value: c.selectedVendor.value,
                options: c.vendorOptions,
                onChanged: c.selectVendor,
              )),

              SizedBox(height: 16.h),

              // Lot Number
              _FieldLabel(text: 'Lot Number'),
              CustomTextField(
                controller: c.lotNumberController,
                hintText: 'e.g. LOT-12345',
              ),

              SizedBox(height: 16.h),

              // Quantity
              _FieldLabel(text: 'Quantity'),
              CustomTextField(
                controller: c.quantityController,
                hintText: 'e.g. 500 ml',
              ),

              SizedBox(height: 16.h),

              // Expiry Date
              _FieldLabel(text: 'Expiry Date'),
              Obx(() => _ExpiryDateField(
                selectedDate: c.expiryDate.value,
                onTap: () => c.pickExpiryDate(context),
              )),

              SizedBox(height: 16.h),

              // Location
              _FieldLabel(text: 'Location'),
              CustomTextField(
                controller: c.locationController,
                hintText: 'Enter location',
              ),

              SizedBox(height: 16.h),

              // Additional Notes
              _FieldLabel(text: 'Additional Notes'),
              CustomTextField(
                controller: c.additionalNotesController,
                hintText:
                    'Add any specific case details or instructions...',
                maxLine: 5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: 'Write at least 80 characters.',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.end,
                ),
              ),

              SizedBox(height: 24.h),

              // Save Button
              CustomButton(
                title: 'Save Bio Inventory',
                onpress: c.saveBioInventory,
                color: AppColors.primaryColor,
                titlecolor: Colors.black,
              ),

              SizedBox(height: 12.h),

              // Disclaimer
              CustomText(
                text: 'Ensure all biohazard labels are up to date...',
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: text,
        fontsize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _VendorDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _VendorDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/implantsinventory.svg',
            width: 18.r,
            height: 18.r,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryTextColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: CustomText(
                  text: 'Select Vendor',
                  fontsize: 13.sp,
                  color: AppColors.secondaryTextColor,
                ),
                isExpanded: true,
                dropdownColor: const Color(0xFF1E2121),
                icon: Icon(Icons.keyboard_arrow_down,
                    color: AppColors.secondaryTextColor, size: 20.r),
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: CustomText(
                      text: option,
                      fontsize: 13.sp,
                      color: AppColors.primaryTextColor,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryDateField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _ExpiryDateField({
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                color: AppColors.secondaryTextColor, size: 18.r),
            SizedBox(width: 10.w),
            CustomText(
              text: selectedDate != null
                  ? DateFormat('MM/dd/yyyy').format(selectedDate!)
                  : 'mm/dd/yyyy',
              fontsize: 13.sp,
              color: selectedDate != null
                  ? AppColors.primaryTextColor
                  : AppColors.secondaryTextColor,
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down,
                color: AppColors.secondaryTextColor, size: 20.r),
          ],
        ),
      ),
    );
  }
}
