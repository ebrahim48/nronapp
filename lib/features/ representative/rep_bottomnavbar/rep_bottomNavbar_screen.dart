import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/representative_home_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/custom_widgets/custom_text.dart';
import '../rep_qrscan/rep_qr_scan_screen.dart';
import 'controller/rep_bottomnavbar_controller.dart';

class RepBottomNavBar extends StatefulWidget {
  const RepBottomNavBar({super.key});

  @override
  State<RepBottomNavBar> createState() => _RepBottomNavBarState();
}

class _RepBottomNavBarState extends State<RepBottomNavBar> {
  final List<Widget> screens = [
    RepresentativeHomeScreen(),
  ];

  late final RepBottomNavController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RepBottomNavController());
  }

  final List<Map<String, String>> _navItems = [
    {'icon': 'assets/icons/home.svg', 'label': 'Home'},
    {'icon': 'assets/icons/inventory.svg', 'label': 'Inventory'},
    {'icon': 'assets/icons/qrscan.svg', 'label': 'QR Scan'},
    {'icon': 'assets/icons/purchaseOrder.svg', 'label': 'P. Order'},
    {'icon': 'assets/icons/analytics.svg', 'label': 'Analytics'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      body: screens[controller.currentIndex],
      bottomNavigationBar: Container(
        width: 393.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: AppColors.roleCardBaseDark,
          border: Border(
            top: BorderSide(
              color: const Color(0xFF3A3A3A),
              width: 1,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(1, 2),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SizedBox(
              height: 54.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _navItems.length,
                      (index) => _buildNavItem(
                    index,
                    _navItems[index]['icon']!,
                    _navItems[index]['label']!,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    return Obx(() {
      final isSelected = index == controller.currentIndex;

      return GestureDetector(
        onTap: () => controller.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 54.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24.w,
                height: 24.w,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? AppColors.primaryColor
                      : AppColors.secondaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: label,
                fontsize: 10.sp,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.secondaryTextColor,
              ),
              SizedBox(height: 6.h),
              Container(
                width: 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primaryColor  // #00C5DA
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}