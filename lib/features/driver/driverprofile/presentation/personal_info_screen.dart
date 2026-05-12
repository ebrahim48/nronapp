import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/personal_info_contrlller.dart';
import 'documents_screen.dart';


class PersonalInfoScreen extends StatefulWidget {
  final bool isSetupMode;

  const PersonalInfoScreen({super.key, this.isSetupMode = false});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final PersonalInfoController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PersonalInfoController();
    _ctrl.loadProfile();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _dropdownField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Gender*',
            fontsize: 12.sp,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
            left: 2.w,
            bottom: 6.h,
          ),
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0x1A4A4A4A),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: AppColors.dotButtonInactiveColor, width: 0.8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _ctrl.selectedGender,
                isExpanded: true,
                dropdownColor: const Color(0xFF252525),
                iconEnabledColor: AppColors.secondaryTextColor,
                style: TextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                ),
                onChanged: (v) {
                  if (v != null) _ctrl.setGender(v);
                },
                items: _ctrl.genders
                    .map((g) =>
                        DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
              ),
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
          text: 'Personal Information',
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
                      EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 110.h),
                  child: Column(
                    children: [
                      // Avatar
                      Center(
                        child: GestureDetector(
                          onTap: _ctrl.pickProfileImage,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 80.r,
                                height: 80.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _ctrl.profileImagePath != null
                                      ? Image.file(
                                          File(_ctrl.profileImagePath!),
                                          fit: BoxFit.cover,
                                        )
                                      : (_ctrl.existingProfileUrl != null &&
                                              _ctrl.existingProfileUrl!
                                                  .isNotEmpty)
                                          ? Image.network(
                                              _ctrl.existingProfileUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Icon(
                                                Icons.person_outline,
                                                color:
                                                    AppColors.primaryColor,
                                                size: 40.r,
                                              ),
                                            )
                                          : Icon(
                                              Icons.person_outline,
                                              color: AppColors.primaryColor,
                                              size: 40.r,
                                            ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 24.r,
                                  height: 24.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryTextColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.edit,
                                      size: 13.r,
                                      color: AppColors.backgroundColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),

                      CustomTextField(
                        controller: _ctrl.fullNameController,
                        labelText: 'Full Name*',
                        hintText: 'Full Name',
                      ),
                      CustomTextField(
                        controller: _ctrl.addressController,
                        labelText: 'Address',
                        hintText: 'Street address',
                      ),
                      CustomTextField(
                        controller: _ctrl.phoneController,
                        labelText: 'Phone*',
                        hintText: 'Phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      CustomTextField(
                        controller: _ctrl.dobController,
                        labelText: 'Date of birth*',
                        hintText: 'dd/mm/yyyy',
                        readOnly: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: AppColors.primaryColor,
                                  surface: const Color(0xFF242424),
                                  onSurface: AppColors.primaryTextColor,
                                ),
                                dialogBackgroundColor:
                                    const Color(0xFF1E2427),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            _ctrl.dobController.text =
                                '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                          }
                        },
                        suffixIcon: Icon(Icons.calendar_today,
                            size: 16.r,
                            color: AppColors.secondaryTextColor),
                      ),

                      _dropdownField(),

                      // Documents row — only in edit mode
                      if (!widget.isSetupMode)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Documents',
                                fontsize: 12.sp,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                                left: 2.w,
                                bottom: 6.h,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DocumentsScreen(
                                      isSetupMode: false,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  height: 50.h,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0x1A4A4A4A),
                                    borderRadius:
                                        BorderRadius.circular(8.r),
                                    border: Border.all(
                                        color:
                                            AppColors.dotButtonInactiveColor,
                                        width: 0.8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        color: AppColors.secondaryTextColor,
                                        size: 16.r,
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: CustomText(
                                          text: 'My Documents',
                                          fontsize: 13.sp,
                                          color: AppColors.primaryTextColor,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right,
                                          color:
                                              AppColors.secondaryTextColor,
                                          size: 18.r),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _ctrl.bioController,
                            labelText: 'Bio*',
                            hintText: 'Write about yourself...',
                            maxLine: 4,
                            onChanged: (_) => _ctrl.notifyListeners(),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              text:
                                  '${_ctrl.bioCharCount}/40 caracteres',
                              fontsize: 10.sp,
                              color: AppColors.secondaryTextColor,
                              right: 2.w,
                            ),
                          ),
                        ],
                      ),

                      if (_ctrl.errorMessage.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: CustomText(
                            text: _ctrl.errorMessage,
                            fontsize: 12.sp,
                            color: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                ),

                // Sticky button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    child: CustomButton(
                      title: widget.isSetupMode ? 'Next' : 'Update Profile',
                      loading: _ctrl.isLoading,
                      onpress: () async {
                        final ok = await _ctrl.saveProfile();
                        if (ok && context.mounted) {
                          if (widget.isSetupMode) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DocumentsScreen(
                                  isSetupMode: true,
                                ),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
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
