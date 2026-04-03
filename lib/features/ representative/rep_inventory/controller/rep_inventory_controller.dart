import 'package:get/get.dart';

class InventoryController extends GetxController {

  final serializedImplants = 85.obs;
  final totalTrays = 85.obs;
  final bioInventory = 85.obs;
  final lowStockAlert = 85.obs;
  final searchQuery = ''.obs;
  final activeTab = 0.obs;

  final tabs = ['Implants', 'Trays', 'Bio'];

  final allInventoryItems = <Map<String, dynamic>>[
    {'name': 'Shoulder Implant', 'serial': '#SHO456', 'material': 'Polyethylene', 'status': 'Available', 'location': 'Advanced Care Clinic', 'type': 'Implants'},
    {'name': 'Knee Replacement', 'serial': '#KNE789', 'material': 'Titanium', 'status': 'In Stock', 'location': 'Ortho Health Center', 'type': 'Implants'},
    {'name': 'Hip Prosthesis', 'serial': '#HIP123', 'material': 'Ceramic', 'status': 'Shipped', 'location': 'Joint Rehabilitation Center', 'type': 'Implants'},
    {'name': 'Surgical Unit A', 'serial': 'TRAY-102', 'status': 'Available', 'location': 'Central General Hospital', 'type': 'Trays'},
    {'name': 'Surgical Unit B', 'serial': 'TRAY-205', 'status': 'In Stock', 'location': 'Ortho Health Center', 'type': 'Trays'},
    {'name': 'Bone Graft', 'serial': '#BIO001', 'material': 'Allograft', 'status': 'Available', 'location': 'Bio Storage', 'type': 'Bio'},
    {'name': 'Tissue Matrix', 'serial': '#BIO002', 'material': 'Dermal', 'status': 'In Stock', 'location': 'Bio Storage', 'type': 'Bio'},
  ].obs;

  List<Map<String, dynamic>> get inventoryItems {
    return allInventoryItems.where((item) => item['type'] == tabs[activeTab.value]).toList();
  }

  bool get isEmpty => inventoryItems.isEmpty;

  void onSearch(String val) => searchQuery.value = val;

  void selectTab(int index) => activeTab.value = index;

  void startReceivingSession() {

  }

  void viewFullList() {

  }

  void openFilter() {

  }
}