import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';

class DeliveryNotesField extends StatelessWidget {
  final TextEditingController controller;

  const DeliveryNotesField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            color: AppColors.secondaryTextColor,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2121),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 4,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              color: AppColors.primaryTextColor,
            ),
            decoration: InputDecoration(
              hintText: 'Add any special notes or observations...',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                color: AppColors.secondaryTextColor,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14.r),
            ),
          ),
        ),
      ],
    );
  }
}