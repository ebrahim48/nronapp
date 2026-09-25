import 'package:get/get.dart';

import '../../driver_map/controller/driver_map_controller.dart';

class DriverMainNavController extends GetxController {
  static const mapTabIndex = 2;

  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    // Map tab: pick up a newly accepted job if none is loaded yet
    if (index == mapTabIndex && Get.isRegistered<DriverMapController>()) {
      final map = Get.find<DriverMapController>();
      if (map.mapJob.value == null) map.loadActiveJob();
    }
  }
}
