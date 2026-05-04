import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoDocumentTile extends StatelessWidget {
  final Map<String, dynamic> doc;
  final VoidCallback onView;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;

  const PoDocumentTile({
    super.key,
    required this.doc,
    required this.onView,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPdf = doc['type'] == 'pdf';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          // File icon
          Container(
            width: 40.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: isPdf
                  ? const Color(0xff2A1010)
                  : const Color(0xff101A2A),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: isPdf
                    ? Colors.red.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPdf ? Icons.picture_as_pdf : Icons.image_outlined,
                  color: isPdf ? Colors.red : Colors.blueAccent,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${doc['size']} • ${doc['date']}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Eye icon
          GestureDetector(
            onTap: onView,
            child: Icon(
              Icons.remove_red_eye_outlined,
              size: 22.sp,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}