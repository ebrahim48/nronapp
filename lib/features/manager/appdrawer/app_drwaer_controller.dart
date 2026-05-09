import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import 'sign_out_dialog.dart';

class ManagerAppDrawerController extends GetxController {
  final selectedIndex = 0.obs;

  final menuItems = [
    {'icon': 'assets/icons/purchase.svg', 'label': 'Purchase Order'},
    {'icon': 'assets/icons/expense.svg', 'label': 'Expenses'},
    {'icon': 'assets/icons/sales.svg', 'label': 'Sales'},
    {'icon': 'assets/icons/commission.svg', 'label': 'Commission'},
    {'icon': 'assets/icons/shipmentsicon.svg', 'label': 'Shipments'},
    {'icon': 'assets/icons/activity.svg', 'label': 'Activity Log'},
    {'icon': 'assets/icons/settings.svg', 'label': 'Setting & Profile'},
    {'icon': 'assets/icons/contact.svg', 'label': 'Contact Support'},
    {'icon': 'assets/icons/about.svg', 'label': 'About App'},
    {'icon': 'assets/icons/terms.svg', 'label': 'Terms & Conditions'},
  ];

  void selectItem(int index) {
    selectedIndex.value = index;
    // Removed Get.back() to avoid contextless navigation error
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SignOutDialog(
        onConfirm: () {
          Navigator.of(dialogContext).pop(); // Close dialog first
          context.go(AppRoutes.roleSelection);
        },
      ),
    );
  }

  void editProfile() {
    // Navigate to profile edit
  }
}