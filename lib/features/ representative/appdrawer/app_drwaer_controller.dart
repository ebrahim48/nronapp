import 'package:get/get.dart';

class AppDrawerController extends GetxController {
  final selectedIndex = 0.obs;

  final menuItems = [
    {'icon': 'assets/icons/scanimplant.svg', 'label': 'Scan Implant'},
    {'icon': 'assets/icons/purchase.svg', 'label': 'Purchase Order'},
    {'icon': 'assets/icons/expense.svg', 'label': 'Expenses'},
    {'icon': 'assets/icons/sales.svg', 'label': 'Sales'},
    {'icon': 'assets/icons/commission.svg', 'label': 'Commission'},
    {'icon': 'assets/icons/shipmentsicon.svg', 'label': 'Shipments'},
    {'icon': 'assets/icons/physicians.svg', 'label': 'Physicians'},
    {'icon': 'assets/icons/surgeries.svg', 'label': 'All Surgeries'},
    {'icon': 'assets/icons/settings.svg', 'label': 'Setting & Profile'},
    {'icon': 'assets/icons/contact.svg', 'label': 'Contact Support'},
    {'icon': 'assets/icons/about.svg', 'label': 'About App'},
    {'icon': 'assets/icons/terms.svg', 'label': 'Terms & Conditions'},
  ];

  void selectItem(int index) {
    selectedIndex.value = index;
    // Removed Get.back() to avoid contextless navigation error
  }

  void signOut() {
    // Sign out logic
  }

  void editProfile() {
    // Navigate to profile edit
  }
}