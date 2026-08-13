import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app-routes/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/rep_bottomnavbar_controller.dart';

/// Reusable bottom navigation bar for the representative section.
///
/// - Inside [RepBottomNavBar] it just switches the [IndexedStack] page.
/// - On standalone (drawer-pushed) screens it jumps back to the main shell
///   at the tapped tab. Pass [standalone] `true` for those screens.
class RepMainBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  /// When true, tapping a tab navigates to the main shell at that index
  /// (used on drawer-pushed screens that have no bottom bar of their own).
  final bool standalone;

  const RepMainBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.standalone = false,
  });

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }
    if (standalone) {
      final navC = Get.isRegistered<RepMainNavController>()
          ? Get.find<RepMainNavController>()
          : Get.put(RepMainNavController());
      navC.changePage(index);
      context.go(AppRoutes.repBottomNavBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        border: Border(
          top: BorderSide(color: const Color(0xFF3A3A3A), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(
            iconPath: 'assets/icons/home.svg',
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => _handleTap(context, 0),
          ),
          _NavItem(
            iconPath: 'assets/icons/implantsinventory.svg',
            label: 'Inventory',
            isActive: currentIndex == 1,
            onTap: () => _handleTap(context, 1),
          ),
          _QrNavItem(
            isActive: currentIndex == 2,
            onTap: () => _handleTap(context, 2),
          ),
          _NavItem(
            iconPath: 'assets/icons/purchase.svg',
            label: 'P. Order',
            isActive: currentIndex == 3,
            onTap: () => _handleTap(context, 3),
          ),
          _NavItem(
            iconPath: 'assets/icons/profile.svg',
            label: 'Profile',
            isActive: currentIndex == 4,
            onTap: () => _handleTap(context, 4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22.r,
              height: 22.r,
              colorFilter: ColorFilter.mode(
                isActive
                    ? AppColors.primaryColor
                    : AppColors.secondaryTextColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: label,
              fontsize: 10.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? AppColors.primaryColor
                  : AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Container(
              width: 4.r,
              height: 4.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primaryColor
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrNavItem extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _QrNavItem({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryColor
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryColor
                      : const Color(0xFF3A3A3A),
                  width: 1,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/scanitem.svg',
                  width: 22.r,
                  height: 22.r,
                  colorFilter: ColorFilter.mode(
                    isActive ? Colors.black : AppColors.primaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: 'QR Scan',
              fontsize: 10.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? AppColors.primaryColor
                  : AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
