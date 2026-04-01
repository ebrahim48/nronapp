import 'package:get/get.dart';

class InventoryController extends GetxController {
  // Stats
  final serializedImplants = 85.obs;
  final totalTrays = 85.obs;
  final bioInventory = 85.obs;
  final lowStockAlert = 85.obs;

  // Search
  final searchQuery = ''.obs;

  // Active tab — 0: Implants, 1: Trays, 2: Bio
  final activeTab = 0.obs;

  final tabs = ['Implants', 'Trays', 'Bio'];

  // Inventory list — empty state shown when this is empty
  final inventoryItems = <Map<String, dynamic>>[].obs;

  bool get isEmpty => inventoryItems.isEmpty;

  void onSearch(String val) => searchQuery.value = val;

  void selectTab(int index) => activeTab.value = index;

  void startReceivingSession() {
    // Navigate to receiving session screen
  }

  void viewFullList() {
    // Navigate to full inventory list
  }

  void openFilter() {
    // Show filter bottom sheet
  }
}