import 'package:get/get.dart';

class ManagerInventoryController extends GetxController {
  final serializedImplants = 85.obs;
  final totalTrays = 85.obs;
  final bioInventory = 85.obs;
  final lowStockAlert = 85.obs;
  final missingCount = 8.obs;
  final pendingTransferCount = 8.obs;

  final selectedProductLine = 'All Product Lines'.obs;
  final productLines = ['All Product Lines', 'Orthopedic', 'Cardiac', 'Neuro'];

  final distributionItems = [
    {'name': 'City Hospital',   'percent': 45, 'color': 0xFF00C5DA},
    {'name': 'Mercy Medical',   'percent': 32, 'color': 0xFF00C5DA},
    {'name': 'St. Jude Center', 'percent': 23, 'color': 0xFF3A3A3A},
  ].obs;

  final movementTab = 'WEEKLY'.obs;

  final weeklyData = [0.4, 0.6, 0.5, 1.0, 0.7, 0.9, 0.8].obs;
  final weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  void selectProductLine(String v) => selectedProductLine.value = v;
  void selectMovementTab(String v) => movementTab.value = v;
}