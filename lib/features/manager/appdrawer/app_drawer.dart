import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../ representative/settingsprofile/controller/setting_controller.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../manager_home/manager_controller/manager_home_controller.dart';
import '../manager_bottomnavbar/controller/manager_main_nav_controller.dart';
import 'app_drwaer_controller.dart';

class ManagerAppDrawer extends StatelessWidget {
  const ManagerAppDrawer({super.key});

  void _switchShellTab(BuildContext context, int tabIndex) {
    final navC = Get.isRegistered<ManagerMainNavController>()
        ? Get.find<ManagerMainNavController>()
        : Get.put(ManagerMainNavController());
    navC.changePage(tabIndex);
    context.go(AppRoutes.managerBottomNavBar);
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0: // Manager Purchase (main shell tab 2)
        _switchShellTab(context, 2);
        break;
      case 1: // Expenses
        context.pushNamed(AppRoutes.managerExpenseScreen);
        break;
      case 2: // Sales
        context.pushNamed(AppRoutes.managerSalesScreen);
        break;
      case 3: // Commission
        context.pushNamed(AppRoutes.commissionDashboardScreen);
        break;
      case 4: // Shipments (main shell tab 3)
        _switchShellTab(context, 3);
        break;
      case 5: // Activity
        context.pushNamed(AppRoutes.activityLogScreen);
        break;
      case 6: // Setting & Profile
        context.pushNamed(AppRoutes.settingProfileScreen);
        break;
      case 7: // Contact Support
        context.pushNamed(AppRoutes.contactSupportScreen);
        break;
      case 8: // About App
        context.pushNamed(AppRoutes.aboutHoleScreen);
        break;
      case 9: // Terms & Conditions
        context.pushNamed(AppRoutes.termsConditionsScreen);
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
          _DrawerHeader(onEditProfile: () => c.editProfile(context)),
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
    final settingsCtrl = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : null;
    final homeCtrl = Get.isRegistered<ManagerHomeController>()
        ? Get.find<ManagerHomeController>()
        : null;

    return Container(
      width: double.infinity,
      // Add the safe-area inset on top of the content height so the notch /
      // Dynamic Island doesn't squeeze the inner column (was overflowing).
      height: 120.h + MediaQuery.of(context).padding.top,
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
          // Avatar — only reactive if settingsCtrl is available
          if (settingsCtrl != null)
            Obx(() {
              final url = settingsCtrl.profile.value?.profileUrl ?? '';
              return _buildAvatar(url.isNotEmpty ? url : null);
            })
          else
            _buildAvatar(null),

          SizedBox(width: 12.w),

          // Name + Edit Profile
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (settingsCtrl != null)
                  Obx(() {
                    final name = settingsCtrl.profile.value?.fullName ?? '';
                    return _buildName(name.isNotEmpty ? name : 'Manager');
                  })
                else if (homeCtrl != null)
                  Obx(() => _buildName(
                        homeCtrl.userName.value.isNotEmpty
                            ? homeCtrl.userName.value
                            : 'Manager',
                      ))
                else
                  _buildName('Manager'),

                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: onEditProfile,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? url) => Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: ClipOval(
          child: url != null
              ? Image.network(url, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _defaultAvatar())
              : _defaultAvatar(),
        ),
      );

  Widget _buildName(String name) => CustomText(
        text: name,
        fontsize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      );

  Widget _defaultAvatar() => Container(
        color: const Color(0xFF3A3A3A),
        child: const Icon(Icons.person, color: Colors.white54),
      );
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