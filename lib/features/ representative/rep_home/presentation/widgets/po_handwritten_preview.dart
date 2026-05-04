import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoHandwrittenPreview extends StatelessWidget {
  final String imagePath;
  final String fileName;
  final VoidCallback onView;

  final Color cardColor;
  final Color cardBorder;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const PoHandwrittenPreview({
    super.key,
    required this.imagePath,
    required this.fileName,
    required this.onView,
    required this.cardColor,
    required this.cardBorder,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Uploaded Handwritten PO',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onView,
              child: Row(
                children: [
                  Icon(Icons.open_in_full,
                      size: 14.sp, color: accentColor),
                  SizedBox(width: 4.w),
                  Text(
                    'View',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Preview container
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: const Color(0xff2A2A2A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: cardBorder),
          ),
          child: Stack(
            children: [
              // Background image (handwritten note style)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                ),
              ),

              // Centered white note card with filename
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image_outlined,
                          size: 16.sp,
                          color: const Color(0xff424242)),
                      SizedBox(width: 6.w),
                      Text(
                        fileName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff424242),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}