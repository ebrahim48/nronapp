import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../manager_home/presentation/manager_home_screen.dart';
import '../../manager_home/presentation/manager_purchase_order_screen.dart';
import '../../managerinventory/presentation/manager_inventory_screen.dart';
import '../../managershipment/presentation/shipments_screen.dart';
import '../controller/manager_main_nav_controller.dart';
import 'widgets/manager_main_bottom_bar.dart';



class ManagerBottomNavBar extends StatelessWidget {
  const ManagerBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse an existing controller so a preserved tab index (set when jumping
    // back from a drawer-pushed screen) is not reset to 0.
    final c = Get.isRegistered<ManagerMainNavController>()
        ? Get.find<ManagerMainNavController>()
        : Get.put(ManagerMainNavController());

    final pages = [
      const ManagerHomeScreen(),
      const ManagerInventoryScreen(),
      const ManagerPurchaseOrderScreen(),
      const ManagerShipmentsScreen(),
    ];

    return Obx(() => Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(
        index: c.currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: ManagerMainBottomBar(
        currentIndex: c.currentIndex.value,
        onTap: c.changePage,
      ),
    ));
  }
}

