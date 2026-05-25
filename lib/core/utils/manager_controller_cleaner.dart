import 'package:get/get.dart';
import '../../features/ representative/settingsprofile/controller/setting_controller.dart';
import '../../features/manager/manager_bottomnavbar/controller/manager_main_nav_controller.dart';
import '../../features/manager/manager_home/manager_controller/manager_home_controller.dart';
import '../../features/manager/manager_home/manager_controller/manager_po_controller.dart';
import '../../features/manager/managerinventory/controller/manager_inventory_controller.dart';
import '../../features/manager/managershipment/controller/shipmentcontroller.dart';

/// Deletes all manager section controllers so they are recreated fresh
/// when a new user logs in (or the same user re-logs in).
///
/// Call this before navigating to managerBottomNavBar.
class ManagerControllerCleaner {
  ManagerControllerCleaner._();

  static void clear() {
    _delete<ManagerHomeController>();
    _delete<ManagerInventoryController>();
    _delete<ManagerPOController>();
    _delete<ShipmentController>();
    _delete<ManagerMainNavController>();
    _delete<SettingsController>();
  }

  static void _delete<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>(force: true);
    }
  }
}
