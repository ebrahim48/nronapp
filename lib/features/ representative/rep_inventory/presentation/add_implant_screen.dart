import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/dotted_upload_box.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/add_implant_controller.dart';


class AddImplantScreen extends StatefulWidget {
  const AddImplantScreen({super.key});

  @override
  State<AddImplantScreen> createState() => _AddImplantScreenState();
}

class _AddImplantScreenState extends State<AddImplantScreen> {
  late final AddImplantController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(AddImplantController());
  }

  Widget _dropdownField({
    required String hint,
    required String? svgIcon,
    required List<String>? items,
    required String? value,
    required ValueChanged<String?> onChanged,
    String? label,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            CustomText(
              text: label,
              fontsize: 12.sp,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
              left: 2.w,
              bottom: 6.h,
            ),
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0x1A4A4A4A),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: AppColors.dotButtonInactiveColor, width: 0.8),
            ),
            child: Row(
              children: [
                if (svgIcon != null)
                  SvgPicture.asset(
                    svgIcon,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: ColorFilter.mode(
                      AppColors.secondaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                SizedBox(width: 10.w),
                Expanded(
                  child: items != null
                      ? DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: value,
                            hint: CustomText(
                              text: hint,
                              fontsize: 13.sp,
                              color: AppColors.secondaryTextColor,
                            ),
                            isExpanded: true,
                            dropdownColor: const Color(0xFF252525),
                            iconEnabledColor: AppColors.secondaryTextColor,
                            style: TextStyle(
                              color: AppColors.primaryTextColor,
                              fontSize: 13.sp,
                              fontFamily: 'Poppins',
                            ),
                            onChanged: onChanged,
                            items: items
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          ),
                        )
                      : CustomText(
                          text: hint,
                          fontsize: 13.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    color: AppColors.secondaryTextColor, size: 18.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageGrid(List<File> images, void Function(int) onRemove) {
    if (images.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: images.asMap().entries.map((e) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  e.value,
                  width: 80.r,
                  height: 80.r,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => onRemove(e.key),
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 12.r),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Add Serialized Implant',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Obx(() {
        return Form(
          key: _ctrl.formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Facility dropdown from API
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Facility / Location',
                            fontsize: 12.sp,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                            left: 2.w,
                            bottom: 6.h,
                          ),
                          Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: const Color(0x1A4A4A4A),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: AppColors.dotButtonInactiveColor,
                                  width: 0.8),
                            ),
                            child: _ctrl.isLoadingFacilities.value
                                ? Row(children: [
                                    SvgPicture.asset(
                                      'assets/icons/location.svg',
                                      width: 16.r,
                                      height: 16.r,
                                      colorFilter: ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn),
                                    ),
                                    SizedBox(width: 10.w),
                                    CustomText(
                                      text: 'Loading facilities...',
                                      fontsize: 13.sp,
                                      color: AppColors.secondaryTextColor,
                                      textAlign: TextAlign.start,
                                    ),
                                  ])
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _ctrl.selectedFacilityId.value,
                                      hint: Row(children: [
                                        SvgPicture.asset(
                                          'assets/icons/location.svg',
                                          width: 16.r,
                                          height: 16.r,
                                          colorFilter: ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          'Search Facility (e.g., City Hospital)',
                                          style: TextStyle(fontSize: 13.sp, color: AppColors.secondaryTextColor, fontFamily: 'Poppins'),
                                        ),
                                      ]),
                                      selectedItemBuilder: (context) => _ctrl.facilities
                                          .map((f) => Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/location.svg',
                                                    width: 16.r,
                                                    height: 16.r,
                                                    colorFilter: ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Flexible(
                                                    child: Text(
                                                      f.name,
                                                      style: TextStyle(fontSize: 13.sp, color: AppColors.primaryTextColor, fontFamily: 'Poppins'),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ]),
                                              ))
                                          .toList(),
                                      isExpanded: true,
                                      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextColor, size: 18.r),
                                      dropdownColor: const Color(0xFF252525),
                                      style: TextStyle(color: AppColors.primaryTextColor, fontSize: 13.sp, fontFamily: 'Poppins'),
                                      onChanged: (val) {
                                        if (val == null) return;
                                        final f = _ctrl.facilities.firstWhere((f) => f.id == val);
                                        _ctrl.selectFacility(f.id, f.name);
                                      },
                                      items: _ctrl.facilities
                                          .map((f) => DropdownMenuItem(value: f.id, child: Text(f.name)))
                                          .toList(),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    // Vendor dropdown from API
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Vendor',
                            fontsize: 12.sp,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                            left: 2.w,
                            bottom: 6.h,
                          ),
                          Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: const Color(0x1A4A4A4A),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.dotButtonInactiveColor, width: 0.8),
                            ),
                            child: _ctrl.isLoadingVendors.value
                                ? Row(children: [
                                    SvgPicture.asset(
                                      'assets/icons/vendor.svg',
                                      width: 16.r,
                                      height: 16.r,
                                      colorFilter: ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn),
                                    ),
                                    SizedBox(width: 10.w),
                                    CustomText(text: 'Loading vendors...', fontsize: 13.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                                  ])
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _ctrl.selectedVendorId.value,
                                      hint: Row(children: [
                                        SvgPicture.asset(
                                          'assets/icons/vendor.svg',
                                          width: 16.r,
                                          height: 16.r,
                                          colorFilter: ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text('Select vendor', style: TextStyle(fontSize: 13.sp, color: AppColors.secondaryTextColor, fontFamily: 'Poppins')),
                                      ]),
                                      selectedItemBuilder: (context) => _ctrl.vendors
                                          .map((v) => Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/vendor.svg',
                                                    width: 16.r,
                                                    height: 16.r,
                                                    colorFilter: ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Flexible(child: Text(v.name, style: TextStyle(fontSize: 13.sp, color: AppColors.primaryTextColor, fontFamily: 'Poppins'), overflow: TextOverflow.ellipsis)),
                                                ]),
                                              ))
                                          .toList(),
                                      isExpanded: true,
                                      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextColor, size: 18.r),
                                      dropdownColor: const Color(0xFF252525),
                                      style: TextStyle(color: AppColors.primaryTextColor, fontSize: 13.sp, fontFamily: 'Poppins'),
                                      onChanged: (val) {
                                        if (val == null) return;
                                        final v = _ctrl.vendors.firstWhere((v) => v.id == val);
                                        _ctrl.selectVendor(v.id, v.name);
                                      },
                                      items: _ctrl.vendors.map((v) => DropdownMenuItem(value: v.id, child: Text(v.name))).toList(),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    // System Type — 2 dropdowns side by side
                    CustomText(
                      text: 'System Type',
                      fontsize: 12.sp,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      left: 2.w,
                      bottom: 6.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Container(
                              height: 50.h,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: const Color(0x1A4A4A4A),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                    color: AppColors.dotButtonInactiveColor,
                                    width: 0.8),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/systemtype.svg',
                                    width: 16.r,
                                    height: 16.r,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.secondaryTextColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _ctrl.selectedSystemType.value,
                                        hint: CustomText(
                                          text: 'System',
                                          fontsize: 12.sp,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                        isExpanded: true,
                                        dropdownColor: const Color(0xFF252525),
                                        iconEnabledColor: AppColors.secondaryTextColor,
                                        style: TextStyle(
                                          color: AppColors.primaryTextColor,
                                          fontSize: 12.sp,
                                          fontFamily: 'Poppins',
                                        ),
                                        onChanged: _ctrl.setSystemType,
                                        items: _ctrl.systemTypes
                                            .map((e) => DropdownMenuItem(
                                                value: e, child: Text(e)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Container(
                              height: 50.h,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: const Color(0x1A4A4A4A),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                    color: AppColors.dotButtonInactiveColor,
                                    width: 0.8),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/systemtype.svg',
                                    width: 16.r,
                                    height: 16.r,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.secondaryTextColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _ctrl.selectedSystemSubType.value,
                                        hint: CustomText(
                                          text: 'Sub-Type',
                                          fontsize: 12.sp,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                        isExpanded: true,
                                        dropdownColor: const Color(0xFF252525),
                                        iconEnabledColor: AppColors.secondaryTextColor,
                                        style: TextStyle(
                                          color: AppColors.primaryTextColor,
                                          fontSize: 12.sp,
                                          fontFamily: 'Poppins',
                                        ),
                                        onChanged: _ctrl.setSystemSubType,
                                        items: _ctrl.systemSubTypes
                                            .map((e) => DropdownMenuItem(
                                                value: e, child: Text(e)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Recipient Email
                    CustomTextField(
                      controller: _ctrl.recipientEmailController,
                      labelText: 'Recipient Email',
                      hintText: 'Enter recipient email',
                      keyboardType: TextInputType.emailAddress,
                      isEmail: true,
                      prefixIcon: Icon(Icons.email_outlined,
                          color: AppColors.secondaryTextColor, size: 16.r),
                    ),

                    // Serial Information
                    Container(
                      padding: EdgeInsets.all(14.r),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                            color: AppColors.primaryColor.withValues(alpha: 0.4),
                            width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.qr_code,
                                  color: AppColors.primaryColor, size: 18.r),
                              SizedBox(width: 8.w),
                              CustomText(
                                text: 'Serial Information',
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          CustomTextField(
                            controller: _ctrl.serial1Controller,
                            labelText: 'Serial Number 1',
                            hintText: 'Enter SN1 or scan barcode',
                          ),
                          CustomTextField(
                            controller: _ctrl.serial2Controller,
                            labelText: 'Serial Number 2 (Optional)',
                            hintText: 'Enter SN2',
                            validator: (_) => null,
                          ),
                        ],
                      ),
                    ),

                    // Inbound Image Upload
                    CustomText(
                      text: 'Inbound Image',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 8.h,
                    ),
                    _imageGrid(_ctrl.inboundImages.toList(), _ctrl.removeInboundImage),
                    DottedUploadBox(
                      label: 'Inbound Image Upload',
                      subtitle: 'Tap to capture or select from gallery',
                      onTap: () => _ctrl.pickInboundImage(context),
                    ),
                    SizedBox(height: 14.h),

                    // Additional Notes
                    CustomTextField(
                      controller: _ctrl.additionalNotesController,
                      labelText: 'Additional Notes',
                      hintText:
                          'Enter any specific details, packaging condition, or handling instructions...',
                      maxLine: 4,
                      validator: (v) {
                        if ((v?.length ?? 0) < 80) {
                          return 'Write at least 80 characters.';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: 'Write at least 80 characters.',
                        fontsize: 10.sp,
                        color: AppColors.secondaryTextColor,
                        right: 2.w,
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Broken Instruments Upload
                    CustomText(
                      text: 'Broken Instruments',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                      bottom: 8.h,
                    ),
                    _imageGrid(_ctrl.brokenImages.toList(), _ctrl.removeBrokenImage),
                    DottedUploadBox(
                      label: 'Broken Instrument Image',
                      subtitle: 'Tap to capture or select from gallery',
                      onTap: () => _ctrl.pickBrokenImage(context),
                    ),
                    SizedBox(height: 14.h),

                    // Additional Notes (broken)
                    CustomTextField(
                      controller: _ctrl.brokenNotesController,
                      labelText: 'Additional Notes',
                      hintText:
                          'Add any specific case details or instructions...',
                      maxLine: 4,
                      validator: (_) => null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: 'Write at least 80 characters.',
                        fontsize: 10.sp,
                        color: AppColors.secondaryTextColor,
                        right: 2.w,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.backgroundColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: CustomButton(
                    title: 'Save Implant',
                    loading: _ctrl.isSaving.value,
                    prefixIcon: Icon(Icons.save_outlined,
                        color: AppColors.primaryTextColor, size: 18.r),
                    onpress: () async {
                      final ok = await _ctrl.save();
                      if (ok && context.mounted) context.pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
