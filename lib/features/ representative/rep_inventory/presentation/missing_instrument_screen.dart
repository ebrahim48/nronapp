import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../controller/missing_instrument_controller.dart';

class _VendorDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _VendorDropdown({required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final safeValue = (value != null && options.contains(value)) ? value : null;
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          hint: CustomText(text: 'Select Vendor (optional)', fontsize: 13.sp, color: AppColors.secondaryTextColor),
          isExpanded: true,
          dropdownColor: const Color(0xFF1E2121),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextColor, size: 20.r),
          items: options.map((o) => DropdownMenuItem(
            value: o,
            child: CustomText(text: o, fontsize: 13.sp, color: AppColors.primaryTextColor),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _IssueTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _IssueTypeSelector({required this.selected, required this.onSelect});

  static const _options = [
    ('missing', 'Missing'),
    ('damage', 'Damage'),
    ('other', 'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _options.map((opt) {
        final isSelected = selected == opt.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(opt.$1),
            child: Container(
              margin: EdgeInsets.only(right: opt.$1 != 'other' ? 8.w : 0),
              height: 44.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.15) : const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : const Color(0xFF3A3A3A),
                ),
              ),
              child: Center(
                child: CustomText(
                  text: opt.$2,
                  fontsize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primaryColor : AppColors.secondaryTextColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class MissingInstrumentScreen extends StatefulWidget {
  final String trayId;
  const MissingInstrumentScreen({super.key, required this.trayId});

  @override
  State<MissingInstrumentScreen> createState() => _MissingInstrumentScreenState();
}

class _MissingInstrumentScreenState extends State<MissingInstrumentScreen> {
  late final MissingInstrumentController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(MissingInstrumentController())..trayId = widget.trayId;
  }

  @override
  void dispose() {
    // Children unmount before their parent, so the fields holding this
    // controller's TextEditingControllers are already gone by now. Deleting
    // it from a button handler instead threw "A TextEditingController was
    // used after being disposed".
    Get.delete<MissingInstrumentController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                    text: 'Missing Instrument Report',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Tray Mini Card
              _TrayMiniCard(trayId: widget.trayId),

              SizedBox(height: 20.h),

              // Instrument Details Header
              Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.primaryColor, size: 18.r),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'Instrument Details',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Instrument Name
              _FieldLabel(text: 'Instrument Name'),
              CustomTextField(
                controller: c.instrumentNameController,
                hintText: 'e.g. Retractor, Scalpel',
              ),

              SizedBox(height: 12.h),

              // Vendor
              _FieldLabel(text: 'Vendor'),
              Obx(() => _VendorDropdown(
                value: c.selectedVendorName.value,
                options: c.vendorOptions,
                onChanged: c.selectVendor,
              )),

              SizedBox(height: 12.h),

              // Issue Type
              _FieldLabel(text: 'Issue Type'),
              Obx(() => _IssueTypeSelector(
                selected: c.issueType.value,
                onSelect: c.setIssueType,
              )),

              SizedBox(height: 12.h),

              // Description & Notes
              _FieldLabel(text: 'Description & Notes'),
              CustomTextField(
                controller: c.descriptionController,
                hintText:
                    'Provide details about when and where it went missing, unique markings, or specific case details...',
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

              SizedBox(height: 16.h),

              // Instrument Photo
              _FieldLabel(text: 'Instrument Photo'),
              Obx(() => c.instrumentPhoto.value != null
                  ? _ImageUploadPreview(
                      imageFile: c.instrumentPhoto.value!,
                      onRemove: c.removePhoto,
                    )
                  : GestureDetector(
                      onTap: c.pickPhoto,
                      child: _DashedWhiteBox(
                        width: double.infinity,
                        height: 110.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/camera.svg',
                                  width: 18.r,
                                  height: 18.r,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.secondaryTextColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              text: 'Click to upload or drag and drop',
                              fontsize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )),

              SizedBox(height: 24.h),

              // Submit Button
              Obx(() => CustomButton(
                title: 'Submit Report',
                loading: c.isSubmitting.value,
                onpress: () async {
                  final instrumentId = await c.submitReport();
                  if (instrumentId != null && context.mounted) {
                    context.pushNamed(AppRoutes.reportSuccessScreen,
                        extra: instrumentId);
                  }
                },
                prefixIcon: Icon(
                  Icons.info_outline,
                  color: Colors.black,
                  size: 18.r,
                ),
              )),

              SizedBox(height: 12.h),

              // Disclaimer
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2121),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/implantsinventory.svg',
                      width: 16.r,
                      height: 16.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.secondaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomText(
                        text:
                            'By submitting this report, you confirm that the information provided is accurate. This data will be shared with our network of local instrument shops and law enforcement partners to assist in recovery.',
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                        textHeight: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageUploadPreview extends StatelessWidget {
  final File imageFile;
  final VoidCallback onRemove;

  const _ImageUploadPreview({
    required this.imageFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.file(
            imageFile,
            width: double.infinity,
            height: 160.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrayMiniCard extends StatelessWidget {
  final String trayId;
  const _TrayMiniCard({required this.trayId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.5),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72.w,
            height: 58.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A3A3A),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.medical_services_outlined,
                color: AppColors.primaryColor, size: 28.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: trayId.isNotEmpty ? trayId : 'Unknown Tray',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: const Color(0xFFEC5B13), size: 11.r),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: 'Reporting missing instrument',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
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
    );
  }
}

class _DashedWhiteBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _DashedWhiteBox({
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DashedPainter(
          color: const Color(0xFF3A3A3A),
          borderRadius: 12,
          dashWidth: 6,
          dashSpace: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
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
      padding: EdgeInsets.only(bottom: 6.h),
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
      ..strokeWidth = 1.5
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