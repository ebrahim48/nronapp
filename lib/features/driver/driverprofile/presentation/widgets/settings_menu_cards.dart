import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class SettingsMenuCard extends StatelessWidget {
  final List<SettingsMenuItem> items;

  const SettingsMenuCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _MenuRow(item: item),
              if (i < items.length - 1)
                Divider(
                  color: const Color(0xFF3A3A3A),
                  height: 1,
                  thickness: 0.5,
                  indent: 16.w,
                  endIndent: 16.w,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class SettingsMenuItem {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const SettingsMenuItem({
    required this.icon,
    required this.label,
    this.iconColor,
    required this.onTap,
  });
}

class _MenuRow extends StatelessWidget {
  final SettingsMenuItem item;
  const _MenuRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        color: Colors.transparent,
        padding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        child: Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: (item.iconColor ?? AppColors.primaryColor)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor ?? AppColors.primaryColor,
                size: 16.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                text: item.label,
                fontsize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.secondaryTextColor, size: 18.r),
          ],
        ),
      ),
    );
  }
}