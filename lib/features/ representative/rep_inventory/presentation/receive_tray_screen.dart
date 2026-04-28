import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../controller/receive_tray_controller.dart';

class ReceiveTrayScreen extends StatelessWidget {
  const ReceiveTrayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ReceiveTrayController());

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
                    text: 'Receive Tray',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Initial Tray Photo
              _SectionLabel(text: 'Initial Tray Photo'),
              Obx(() => c.initialPhoto.value != null
                  ? _ImageUploadPreview(
                      imageFile: c.initialPhoto.value!,
                      onRemove: c.removeInitialPhoto,
                    )
                  : GestureDetector(
                      onTap: c.captureInitialPhoto,
                      child: _DashedBox(
                        width: double.infinity,
                        height: 100.h,
                        child: Row(
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
                            SizedBox(width: 12.w),
                            CustomText(
                              text: 'Capture Initial Photo',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    )),

              SizedBox(height: 20.h),

              // Broken Instruments
              _SectionLabel(text: 'Broken Instruments'),
              Obx(() => Wrap(
                spacing: 9.w,
                runSpacing: 9.h,
                children: [
                  GestureDetector(
                    onTap: c.addBrokenPhoto,
                    child: SizedBox(
                      width: 160.w,
                      height: 160.h,
                      child: CustomPaint(
                        painter: _DashedPainter(
                          color: const Color(0x331AC8DB),
                          borderRadius: 24,
                          dashWidth: 6,
                          dashSpace: 4,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0x0D1AC8DB),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/camera.svg',
                                width: 28.r,
                                height: 26.r,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CustomText(
                                text: 'Add Photo',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...c.brokenPhotos.asMap().entries.map((e) => _ImageUploadPreview(
                        imageFile: e.value,
                        onRemove: () => c.removeBrokenPhoto(e.key),
                      )),
                ],
              )),

              SizedBox(height: 20.h),

              // Broken Instruments Notes
              _SectionLabel(text: 'Broken Instruments Notes'),
              CustomTextField(
                controller: c.brokenNotesController,
                hintText: 'Add any specific case details or instructions...',
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

              SizedBox(height: 20.h),

              // Report Missing Instrument Button
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.missingInstrumentScreen),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0x331AC8DB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/camera.svg',
                        width: 20.r,
                        height: 20.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: 'Report Missing Instrument',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Confirm Button
              CustomButton(
                title: 'Confirm Tray Receive',
                onpress: c.confirmReceive,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: 'Verified by Central Sterile Services',
                fontsize: 12.sp,
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
          borderRadius: BorderRadius.circular(16.r),
          child: Image.file(
            imageFile,
            width: 160.w,
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: CustomText(
        text: text,
        fontsize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _DashedBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _DashedBox({
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