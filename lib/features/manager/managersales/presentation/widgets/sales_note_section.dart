import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SaleNoteSection extends StatelessWidget {
  final String note;

  const SaleNoteSection({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/note.svg',
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryTextColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6.w),
            CustomText(
              text: 'Note',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Text(
            note,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              color: AppColors.secondaryTextColor,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}