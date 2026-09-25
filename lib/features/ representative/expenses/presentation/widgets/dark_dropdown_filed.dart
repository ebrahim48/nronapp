import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';

class DarkDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final List<String>? values;
  final void Function(String?) onChanged;
  final String? currentHighlight; // marks "current" item with a badge

  const DarkDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.values,
    this.currentHighlight,
  });

  List<DropdownMenuItem<String>> _buildItems() {
    final seen = <String>{};
    final result = <DropdownMenuItem<String>>[];
    for (int i = 0; i < items.length; i++) {
      final itemValue = (values != null && i < values!.length)
          ? values![i]
          : items[i];
      if (seen.add(itemValue)) {
        final isCurrent = currentHighlight != null && itemValue == currentHighlight;
        result.add(DropdownMenuItem(
          value: itemValue,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  items[i],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    color: isCurrent
                        ? AppColors.primaryColor
                        : AppColors.primaryTextColor,
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Current',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ));
      }
    }
    return result;
  }

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
              items: _buildItems(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}