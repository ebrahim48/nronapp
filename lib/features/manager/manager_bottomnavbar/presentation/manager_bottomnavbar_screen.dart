import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../manager_home/presentation/manager_home_screen.dart';
import '../../manager_home/presentation/manager_purchase_order_screen.dart';
import '../../managerinventory/presentation/manager_inventory_screen.dart';
import '../controller/manager_main_nav_controller.dart';



class ManagerBottomNavBar extends StatelessWidget {
  const ManagerBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerMainNavController());

    final pages = [
      const ManagerHomeScreen(),
      const ManagerInventoryScreen(),
      const ManagerPurchaseOrderScreen(),
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
            iconPath: 'assets/icons/dashboard.svg',
            label: 'Dashboard',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            iconPath: 'assets/icons/implantsinventory.svg',
            label: 'Inventory',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),

          _NavItem(
            iconPath: 'assets/icons/purchase.svg',
            label: 'P. Order',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            iconPath: 'assets/icons/shipments.svg',
            label: 'Shipments',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
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

