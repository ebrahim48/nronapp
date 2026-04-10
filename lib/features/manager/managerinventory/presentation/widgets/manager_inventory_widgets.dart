import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class ManagerStatCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final Color valueColor;

  const ManagerStatCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 24.r, height: 24.r,
                colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
            SizedBox(height: 6.h),
            CustomText(text: label, fontsize: 11.sp, fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor, textAlign: TextAlign.center),
            SizedBox(height: 2.h),
            CustomText(text: value, fontsize: 20.sp, fontWeight: FontWeight.w700,
                color: valueColor, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ManagerAlertCard extends StatelessWidget {
  final String iconPath;
  final int count;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ManagerAlertCard({
    super.key,
    required this.iconPath,
    required this.count,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2E2E),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.r, height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(iconPath, width: 18.r, height: 18.r,
                      colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
                ),
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: '$count ${title.split(' ').first}',
                fontsize: 13.sp, fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor, textAlign: TextAlign.start,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: title.contains(' ') ? title.substring(title.indexOf(' ') + 1) : '',
                fontsize: 12.sp, fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor, textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: subtitle,
                fontsize: 10.sp, fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor, textAlign: TextAlign.start,
                textHeight: 1.4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryDistributionCard extends StatelessWidget {
  final String selectedLine;
  final List<String> lines;
  final List<Map<String, dynamic>> items;
  final ValueChanged<String?> onChanged;

  const InventoryDistributionCard({
    super.key,
    required this.selectedLine,
    required this.lines,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Inventory\nDistribution',
                  fontsize: 15.sp, fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor, textAlign: TextAlign.start),
              Container(
                height: 32.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLine,
                    dropdownColor: const Color(0xFF1E2121),
                    icon: Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextColor, size: 16.r),
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11.sp, color: AppColors.primaryTextColor),
                    items: lines.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Center(
            child: SizedBox(
              width: 160.r,
              height: 160.r,
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 18.r,
                      backgroundColor: const Color(0xFF2A2A2A),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: '1.2k', fontsize: 28.sp,
                            fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.center),
                        CustomText(text: 'Items', fontsize: 12.sp,
                            fontWeight: FontWeight.w400, color: AppColors.secondaryTextColor, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(width: 8.r, height: 8.r, decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(item['color'] as int))),
                      SizedBox(width: 8.w),
                      CustomText(text: item['name'] as String, fontsize: 13.sp,
                          fontWeight: FontWeight.w400, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                    ]),
                    CustomText(text: '${item['percent']}%', fontsize: 13.sp,
                        fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(height: 4.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: (item['percent'] as int) / 100,
                    minHeight: 4.h,
                    backgroundColor: const Color(0xFF2A2A2A),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(item['color'] as int)),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class RecentMovementCard extends StatelessWidget {
  final String activeTab;
  final List<double> data;
  final List<String> days;
  final ValueChanged<String> onTabChange;

  const RecentMovementCard({
    super.key,
    required this.activeTab,
    required this.data,
    required this.days,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(text: 'Recent Movement', fontsize: 15.sp,
                  fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
              SizedBox(width: 12.w),
              _Tab(label: 'WEEKLY', isActive: activeTab == 'WEEKLY', onTap: () => onTabChange('WEEKLY')),
              SizedBox(width: 8.w),
              _Tab(label: 'MONTHLY', isActive: activeTab == 'MONTHLY', onTap: () => onTabChange('MONTHLY')),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((e) {
                final isHighlight = e.value >= 0.9;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: e.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isHighlight ? AppColors.primaryColor : const Color(0xFF2A3A3A),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        CustomText(
                          text: days[e.key], fontsize: 9.sp,
                          fontWeight: FontWeight.w400, color: AppColors.secondaryTextColor, textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: isActive ? BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.5)),
        ) : null,
        child: CustomText(
          text: label, fontsize: 11.sp,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          color: isActive ? AppColors.primaryColor : AppColors.secondaryTextColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}