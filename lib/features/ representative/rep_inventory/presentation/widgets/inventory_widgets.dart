import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class InventoryStatCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const InventoryStatCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      height: 110.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 28.r,
            height: 28.r,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: label,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StartReceivingButton extends StatelessWidget {
  final VoidCallback onTap;

  const StartReceivingButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 345.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: CustomText(
            text: 'Start Receiving Session',
            fontsize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class InventorySearchBar extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onFilter;

  const InventorySearchBar({
    super.key,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 18.r,
                    height: 18.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      onChanged: onSearch,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search Serial, lot, or name ....',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Filter button
          GestureDetector(
            onTap: onFilter,
            child: Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/drawer1.svg',
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryTabRow extends StatelessWidget {
  final int activeIndex;
  final List<String> tabs;
  final ValueChanged<int> onSelect;

  const InventoryTabRow({
    super.key,
    required this.activeIndex,
    required this.tabs,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF332F2F),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: EdgeInsets.all(4.r),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final isActive = e.key == activeIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: CustomText(
                    text: e.value,
                    fontsize: 13.sp,
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? Colors.black
                        : AppColors.primaryTextColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class InventoryEmptyState extends StatelessWidget {
  const InventoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 199.w,
          height: 190.h,
          decoration: BoxDecoration(
            color: const Color(0x4D1E293B),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor,
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 95.h,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                    border: Border.all(
                      color: AppColors.backgroundColor,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/check1.svg',
                      width: 32.r,
                      height: 32.r,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 32.h),

        // Text
        CustomText(
          text: 'No Inventory Assigned',
          fontsize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 12.h),

        SizedBox(
          width: 320.w,
          child: CustomText(
            text:
            'Your personal inventory is currently empty. Contact your manager to assign implants to your profile or use the scanner to add items manually.',
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.center,
            textHeight: 1.5,
          ),
        ),
      ],
    );
  }
}

class ViewFullListButton extends StatelessWidget {
  final VoidCallback onTap;

  const ViewFullListButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Center(
          child: CustomText(
            text: 'View full List',
            fontsize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E2121),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}