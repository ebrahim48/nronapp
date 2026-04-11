import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import 'app_drwaer_controller.dart';

class ManagerAppDrawer extends StatelessWidget {
  const ManagerAppDrawer({super.key});

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0: // Manager Purchase
        context.pushNamed(AppRoutes.managerPurchaseOrderScreen);
        break;
      case 1: // Purchase Order
        context.pushNamed(AppRoutes.managerExpenseScreen);
        break;
      case 2: // Sales
        context.pushNamed(AppRoutes.managerSalesScreen);
        break;
      case 3: // Commission
        // context.pushNamed(AppRoutes.commissionScreen);
        break;
      case 4: // Shipments
        // context.pushNamed(AppRoutes.shipmentsScreen);
        break;
      case 5: // Activity
        // context.pushNamed(AppRoutes.activityLogScreen);
        break;
      case 6: // Setting & Profile
        context.pushNamed(AppRoutes.settingProfileScreen);
        break;
      case 7: // Contact Support
        context.pushNamed(AppRoutes.contactSupportScreen);
        break;
      case 8: // About App
        // context.pushNamed(AppRoutes.aboutAppScreen);
        break;
      case 9: // Terms & Conditions
        // context.pushNamed(AppRoutes.termsScreen);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerAppDrawerController());

    return Drawer(
      width: 285.w,
      backgroundColor: AppColors.backgroundColor,
      child: Column(
        children: [
          _DrawerHeader(onEditProfile: c.editProfile),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Obx(() => Column(
                children: c.menuItems.asMap().entries.map((e) {
                  final isActive = c.selectedIndex.value == e.key;
                  return _DrawerMenuItem(
                    iconPath: e.value['icon']!,
                    label: e.value['label']!,
                    isActive: isActive,
                    onTap: () {
                      Navigator.pop(context); // Close drawer using context
                      c.selectItem(e.key);
                      _handleNavigation(context, e.key);
                    },
                  );
                }).toList(),
              )),
            ),
          ),

          Divider(
            color: const Color(0xFF3A3A3A),
            thickness: 0.5,
            indent: 16.w,
            endIndent: 16.w,
          ),

          SizedBox(height: 8.h),

          _DrawerMenuItem(
            iconPath: 'assets/icons/logout.svg',
            label: 'Sign Out',
            isActive: false,
            onTap: () => c.showSignOutDialog(context),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final VoidCallback onEditProfile;

  const _DrawerHeader({required this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      color: const Color(0xFF1E2427),
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: MediaQuery.of(context).padding.top + 16.h,
        bottom: 16.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with teal border
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Name + Edit Profile
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Albert Flamingo',
                fontsize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: onEditProfile,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/edit.svg',
                      width: 12.r,
                      height: 12.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.secondaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: 'Edit Profile',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        margin: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          // Active: teal-ish dark bg
          color: isActive
              ? const Color(0xFF1E3A3A)
              : Colors.transparent,
          // Active: left teal indicator bar
          border: isActive
              ? Border(
            left: BorderSide(
              color: AppColors.primaryColor,
              width: 3,
            ),
          )
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                isActive
                    ? AppColors.primaryColor
                    : AppColors.primaryTextColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 16.w),
            CustomText(
              text: label,
              fontsize: 14.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? AppColors.primaryColor
                  : AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}