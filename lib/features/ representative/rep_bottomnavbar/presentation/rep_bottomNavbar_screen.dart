import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../purchaseorder/presentation/purchase_order_screen.dart';
import '../../rep_home/presentation/representative_home_screen.dart';
import '../../rep_inventory/presentation/rep_inventory_screen.dart';
import '../../rep_qrscan/rep_qr_scan_screen.dart';
import '../../settingsprofile/presentation/settings_profile_screen.dart';
import '../controller/rep_bottomnavbar_controller.dart';
import 'widgets/rep_main_bottom_bar.dart';


class RepBottomNavBar extends StatelessWidget {
  const RepBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse an existing controller so a preserved tab index (set when jumping
    // back from a drawer-pushed screen) is not reset to 0.
    final c = Get.isRegistered<RepMainNavController>()
        ? Get.find<RepMainNavController>()
        : Get.put(RepMainNavController());

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
      bottomNavigationBar: RepMainBottomBar(
        currentIndex: c.currentIndex.value,
        onTap: c.changePage,
      ),
    ));
  }
}
