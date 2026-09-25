import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

/// Bottom sheet listing "All" + [options].
/// Returns '' for All, the chosen option, or null when dismissed.
Future<String?> showStatusFilterSheet(
  BuildContext context, {
  required String title,
  required List<String> options,
  required String selected,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: const Color(0xFF1E2121),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (ctx) {
      Widget tile(String label, String value) {
        final isSelected = value == selected;
        return InkWell(
          onTap: () => Navigator.pop(ctx, value),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: label,
                    fontsize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check, color: AppColors.primaryColor, size: 20.r),
              ],
            ),
          ),
        );
      }

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
              child: CustomText(
                text: title,
                fontsize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ),
            tile('All', ''),
            ...options.map((o) => tile(o, o)),
            SizedBox(height: 8.h),
          ],
        ),
      );
    },
  );
}
