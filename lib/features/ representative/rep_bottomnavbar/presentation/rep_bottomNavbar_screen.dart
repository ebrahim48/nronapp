import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../purchaseorder/presentation/purchase_order_screen.dart';
import '../../rep_home/presentation/representative_home_screen.dart';
import '../../rep_inventory/presentation/rep_inventory_screen.dart';
import '../../rep_qrscan/rep_qr_scan_screen.dart';
import '../../settingsprofile/presentation/settings_profile_screen.dart';
import '../controller/rep_bottomnavbar_controller.dart';


class RepBottomNavBar extends StatelessWidget {
  const RepBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RepMainNavController());

    final pages = [
      const RepresentativeHomeScreen(),
      const InventoryScreen(),
      const QrScanScreen(),
      const PurchaseOrderScreen(),
      const SettingProfileScreen(),
    ];

    return Obx(() => Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(
        index: c.currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: _AppBottomNavBar(
        currentIndex: c.currentIndex.value,
        onTap: c.changePage,
      ),
    ));
  }
}

class _AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

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
            onTap: () => onTap(0),
          ),
          _NavItem(
            iconPath: 'assets/icons/implantsinventory.svg',
            label: 'Inventory',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),


          _QrNavItem(
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),

          _NavItem(
            iconPath: 'assets/icons/purchase.svg',
            label: 'P. Order',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavItem(
            iconPath: 'assets/icons/profile.svg',
            label: 'Profile',
            isActive: currentIndex == 4,
            onTap: () => onTap(4),
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
            // Active dot indicator
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
            // QR icon box — square with rounded corners
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