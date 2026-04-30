import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/add_physicians_controller.dart';
import '../domain/model/physician_model.dart';

class AddPhysicianScreen extends StatefulWidget {
  final PhysicianModel? physician;
  const AddPhysicianScreen({super.key, this.physician});

  @override
  State<AddPhysicianScreen> createState() => _AddPhysicianScreenState();
}

class _AddPhysicianScreenState extends State<AddPhysicianScreen> {
  late AddPhysicianController _c;

  @override
  void initState() {
    super.initState();
    Get.delete<AddPhysicianController>(force: true);
    _c = Get.put(AddPhysicianController());
    if (widget.physician != null) {
      _c.prefillForEdit(widget.physician!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.physician != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: isEdit ? 'Edit Physician' : 'Add Physician',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(text: 'Basic Information'),

                  _FieldLabel(text: 'Full Name'),
                  CustomTextField(
                    controller: _c.fullNameController,
                    hintText: 'Dr. Jane Smith',
                    prefixIcon: SvgPicture.asset(
                      'assets/icons/user.svg',
                      width: 16.r,
                      height: 16.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.secondaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  _FieldLabel(text: 'Practice Name'),
                  CustomTextField(
                    controller: _c.practiceNameController,
                    hintText: 'Central Orthopedics',
                  ),

                  _FieldLabel(text: 'Location'),
                  CustomTextField(
                    controller: _c.locationController,
                    hintText: 'New York',
                  ),

                  _FieldLabel(text: 'Specialty'),
                  Obx(() => _SpecialtyChips(
                        specialties: _c.specialties,
                        selected: _c.selectedSpecialty.value,
                        onSelect: _c.selectSpecialty,
                      )),

                  SizedBox(height: 24.h),


                  _SectionTitle(text: 'Contact'),

                  _FieldLabel(text: 'Phone Number'),
                  CustomTextField(
                    controller: _c.phoneController,
                    hintText: '(555) 000-0000',
                    keyboardType: TextInputType.phone,
                  ),

                  _FieldLabel(text: 'Cell'),
                  CustomTextField(
                    controller: _c.cellController,
                    hintText: '(555) 000-0000',
                    keyboardType: TextInputType.phone,
                  ),

                  _FieldLabel(text: 'Email Address'),
                  CustomTextField(
                    controller: _c.emailController,
                    hintText: 'physician@example.com',
                    keyboardType: TextInputType.emailAddress,
                    isEmail: true,
                    readOnly: isEdit,
                  ),

                  _FieldLabel(text: 'Date of Birth'),
                  _DOBField(
                    controller: _c.dobController,
                    onTap: () => _c.pickDOB(context),
                  ),

                  SizedBox(height: 24.h),

                  Row(
                    children: [
                      CustomText(
                        text: 'Documents ',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        text: '(optional)',
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Business Card upload
                  Obx(() => _c.businessCard.value != null
                      ? _UploadedPreview(
                          file: _c.businessCard.value!,
                          isPdf: _c.businessCardIsPdf.value,
                          onRemove: _c.removeBusinessCard,
                        )
                      : GestureDetector(
                          onTap: () => _c.pickBusinessCard(context),
                          child: const _UploadBox(
                            icon: Icons.badge_outlined,
                            title: 'Business Card',
                            subtitle: 'Upload scan, photo or PDF',
                          ),
                        )),

                  SizedBox(height: 10.h),

                  // Profile Picture upload
                  Obx(() => _c.profilePicture.value != null
                      ? _UploadedPreview(
                          file: _c.profilePicture.value!,
                          isPdf: false,
                          onRemove: _c.removeProfilePicture,
                        )
                      : GestureDetector(
                          onTap: () => _c.pickProfilePicture(context),
                          child: const _UploadBox(
                            icon: Icons.person_outline,
                            title: 'Profile Picture',
                            subtitle: 'JPG, PNG up to 5MB',
                          ),
                        )),

                  SizedBox(height: 24.h),

                  _SectionTitle(text: 'Note'),

                  _FieldLabel(text: 'Note to Self'),
                  CustomTextField(
                    controller: _c.noteController,
                    hintText: 'Add private notes about this physician...',
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

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),

          Container(
            color: AppColors.backgroundColor,
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
            child: Column(
              children: [
                Obx(() => CustomButton(
                      title: isEdit ? 'Update Physician' : 'Save Physician',
                      titlecolor: const Color(0xFF1E2121),
                      loading: _c.isSubmitting.value,
                      onpress: () => _c.submitPhysician(
                        context,
                        physicianId: widget.physician?.id,
                      ),
                      suffixIcon: SvgPicture.asset(
                        'assets/icons/createjob.svg',
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E2121),
                          BlendMode.srcIn,
                        ),
                      ),
                    )),

                SizedBox(height: 10.h),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Cancel',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: CustomText(
        text: text,
        fontsize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
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
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: text,
        fontsize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _SpecialtyChips extends StatelessWidget {
  final List<String> specialties;
  final String selected;
  final ValueChanged<String> onSelect;

  const _SpecialtyChips({
    required this.specialties,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: specialties.map((s) {
        final isActive = s == selected;
        return GestureDetector(
          onTap: () => onSelect(s),
          child: SizedBox(
            width: 72.05,
            height: 38,
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment:
                      isActive ? Alignment.centerLeft : const Alignment(-0.99, 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isActive ? 72.05 : 0,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C5DA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Container(
                  width: 72.05,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF00C5DA)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF00C5DA),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      text: s,
                      fontsize: 13.sp,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isActive ? Colors.black : const Color(0xFF00C5DA),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DOBField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const _DOBField({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: const Color(0x1A4A4A4A),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFD4D4D4), width: 0.8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  onTap: onTap,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.sp,
                    color: AppColors.primaryTextColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'mm/dd/yyyy',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              Icon(Icons.calendar_today_outlined,
                  color: AppColors.secondaryTextColor, size: 16.r),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _UploadBox({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
          style: BorderStyle.solid,
        ),
      ),
      child: CustomPaint(
        painter: _DashedPainter(
          color: const Color(0xFF3A3A3A),
          borderRadius: 10,
          dashWidth: 6,
          dashSpace: 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.secondaryTextColor, size: 26.r),
            SizedBox(height: 6.h),
            CustomText(
              text: title,
              fontsize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.center,
            ),
            CustomText(
              text: subtitle,
              fontsize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadedPreview extends StatelessWidget {
  final File file;
  final bool isPdf;
  final VoidCallback onRemove;

  const _UploadedPreview({
    required this.file,
    required this.isPdf,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF00C5DA), width: 1),
      ),
      child: Row(
        children: [
          if (!isPdf)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(file,
                  width: 52.r, height: 52.r, fit: BoxFit.cover),
            )
          else
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.picture_as_pdf,
                  color: Colors.redAccent, size: 28.r),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: file.path.split('/').last.split('\\').last,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: isPdf ? 'PDF Document' : 'Image',
                  fontsize: 11.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close,
                color: AppColors.secondaryTextColor, size: 18.r),
          ),
        ],
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  const _DashedPainter({
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + dashWidth), paint);
        d += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedPainter o) => false;
}
