import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class DarkDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const DarkDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryTextColor,
            ),
          ),
        if (label.isNotEmpty) SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: (value?.isEmpty ?? true) ? null : value,
              hint: Text(
                hint,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                  color: AppColors.secondaryTextColor,
                ),
              ),
              isExpanded: true,
              dropdownColor: const Color(0xFF2A2A2A),
              icon: Icon(Icons.keyboard_arrow_down,
                  color: AppColors.secondaryTextColor, size: 20.r),
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}