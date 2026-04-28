import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/bulk_purchase_controller.dart';

class BulkPoStepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const BulkPoStepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return SizedBox(
      width: 342.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Step 01 of 03"
          CustomText(
            text: 'Step 0$currentStep of 0$totalSteps',
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 4.h),

          // Row: "Select Order Type"  |  "2/3"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: 'Select Order Type',
                fontsize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              // "2/3" — blue number + grey /3
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                  ),
                  children: [
                    TextSpan(
                      text: '$currentStep',
                      style: const TextStyle(
                        color: Color(0xFF137FEC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: '/$totalSteps',
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Progress bar — width 195, height 6, teal
          ClipRRect(
            borderRadius: BorderRadius.circular(9999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: const Color(0xFF3A3A3A),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bulk BIO Order card — header with "+ Add Products" button ─────────────────
class BulkBioOrderCard extends StatelessWidget {
  final VoidCallback onAddProducts;

  const BulkBioOrderCard({super.key, required this.onAddProducts});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 74.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0x1A137FEC), // #137FEC at 10%
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left — title + subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Bulk BIO Order',
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF00C5DA),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: 'Specific products required',
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),

          // Right — "+ Add Products" button
          GestureDetector(
            onTap: onAddProducts,
            child: Container(
              width: 153.w,
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0x4D00C5DA),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: const Color(0xFF00C5DA), size: 14.r),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'Add Products',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00C5DA),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BulkProductRow extends StatelessWidget {
  final BulkProductItem item;
  final VoidCallback onRemove;

  const BulkProductRow({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Row(
        children: [

          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: const Color(0x1A1AC8DB),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                item.iconPath,
                width: 22.r,
                height: 22.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Name + detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item.name,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: item.detail,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),

          // Price + Remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: item.price,
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: onRemove,
                child: CustomText(
                  text: 'Remove',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF2828),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BulkAttachDocumentBox extends StatelessWidget {
  final VoidCallback onUploadPDF;
  final VoidCallback onTakePhoto;

  const BulkAttachDocumentBox({
    super.key,
    required this.onUploadPDF,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
        color: const Color(0x1A4A4A4A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: const Color(0xFF00C5DA),
          borderRadius: 8,
          dashWidth: 5,
          dashSpace: 5,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Attach PO Document',
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AttachButton(
                    icon: 'assets/icons/document.svg',
                    label: 'Upload PDF',
                    onTap: onUploadPDF,
                  ),
                  SizedBox(width: 12.w),
                  _AttachButton(
                    icon: 'assets/icons/photocamera.svg',
                    label: 'Take Photo',
                    onTap: onTakePhoto,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _AttachButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 147.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: const Color(0xFF192633),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFF324D67)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryTextColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: label,
              fontsize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  const _DashedBorderPainter({
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

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => false;
}