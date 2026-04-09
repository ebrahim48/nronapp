import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/dotted_upload_box.dart';
import '../../../../core/constants/app_colors.dart';
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
  final _ctrl = AddImplantController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _dropdownField({
    required String hint,
    required IconData icon,
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
          if (label != null) ...[
            CustomText(
              text: label,
              fontsize: 12.sp,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
              left: 2.w,
              bottom: 6.h,
            ),
          ],
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
                Icon(icon, color: AppColors.secondaryTextColor, size: 16.r),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return Form(
            key: _ctrl.formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding:
                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Facility
                      _dropdownField(
                        hint: 'Search Facility (e.g., City Hospital)',
                        icon: Icons.add,
                        items: null,
                        value: null,
                        onChanged: (_) {},
                        label: 'Facility / Location',
                      ),

                      // Vendor
                      CustomTextField(
                        controller: _ctrl.vendorController,
                        labelText: 'Vendor',
                        hintText: 'Vendor',
                        prefixIcon: Icon(Icons.business_outlined,
                            color: AppColors.secondaryTextColor, size: 16.r),
                      ),

                      // System Type
                      _dropdownField(
                        hint: 'Select System',
                        icon: Icons.settings_outlined,
                        items: _ctrl.systemTypes,
                        value: _ctrl.selectedSystemType,
                        onChanged: _ctrl.setSystemType,
                        label: 'System Type',
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
                              validator: (_) => null, // optional
                            ),
                          ],
                        ),
                      ),

                      CustomText(
                        text: 'Inbound Image',
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                        bottom: 8.h,
                      ),
                      DottedUploadBox(
                        onTap: () => _ctrl.addInboundImage('placeholder'),
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

                      CustomText(
                        text: 'Broken Instruments',
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                        bottom: 8.h,
                      ),
                      DottedUploadBox(
                        onTap: () => _ctrl.addBrokenImage('placeholder'),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    child: CustomButton(
                      title: 'Save Implant',
                      prefixIcon: Icon(Icons.save_outlined,
                          color: AppColors.primaryTextColor, size: 18.r),
                      onpress: () {
                        if (_ctrl.save()) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}