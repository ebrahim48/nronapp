import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';

class MovementHistoryItem {
  final String title;
  final String subtitle;
  final bool isActive;

  const MovementHistoryItem({
    required this.title,
    required this.subtitle,
    required this.isActive,
  });
}

class TrayDetailsController extends GetxController {
  // Tray info
  final trayId = 'TRAY-8829'.obs;
  final trayName = 'Ortho-Major Set B'.obs;
  final updatedAgo = 'Updated 10 mins ago'.obs;
  final imagePath = 'assets/images/tray.jpg'.obs;

  final inventoryModel = 'Loaner'.obs;
  final status = 'Down Rack'.obs;

  final currentLocation = 'Central Sterile – Zone A'.obs;

  final movementHistory = <MovementHistoryItem>[
    const MovementHistoryItem(
      title: 'Arrived at Sterilization',
      subtitle: 'Today, 10:24 AM • Operator: J. Doe',
      isActive: true,
    ),
    const MovementHistoryItem(
      title: 'Decontamination Complete',
      subtitle: 'Today, 09:15 AM • Station 04',
      isActive: false,
    ),
    const MovementHistoryItem(
      title: 'Received from OR Room 12',
      subtitle: 'Today, 08:30 AM • Case #8821',
      isActive: false,
    ),
  ].obs;

  void sendTray(BuildContext context) {
    context.pushNamed(AppRoutes.sendTrayScreen);
  }
  void receiveTray(BuildContext context) {
    context.pushNamed(AppRoutes.receiveTrayScreen);
  }
  void reportMissingInstrument(BuildContext context) {
    context.pushNamed(AppRoutes.missingInstrumentScreen);
  }
}