import 'package:get/get.dart';
import '../../manager_home/manager_controller/manager_home_controller.dart';
import '../../manager_home/manager_controller/manager_po_controller.dart';
import '../../managerinventory/controller/manager_inventory_controller.dart';
import '../../managershipment/controller/shipmentcontroller.dart';

class ManagerMainNavController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    _refreshTab(index);
  }

  void _refreshTab(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<ManagerHomeController>()) {
          final c = Get.find<ManagerHomeController>();
          if (!c.isLoading.value) c.fetchOverview();
        }
        break;
      case 1:
        if (Get.isRegistered<ManagerInventoryController>()) {
          final c = Get.find<ManagerInventoryController>();
          if (!c.isLoadingStats.value) c.refresh();
        }
        break;
      case 2:
        if (Get.isRegistered<ManagerPOController>()) {
          final c = Get.find<ManagerPOController>();
          if (!c.isLoading.value) c.fetchOrders();
        }
        break;
      case 3:
        if (Get.isRegistered<ShipmentController>()) {
          final c = Get.find<ShipmentController>();
          if (!c.isLoadingList.value) c.fetchAll();
        }
        break;
    }
  }
}