import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/utils/manager_controller_cleaner.dart';
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
        onConfirm: () async {
          Navigator.of(dialogContext).pop();
          await PrefsHelper.remove('auth_token');
          await PrefsHelper.remove('auth_refresh_token');
          await PrefsHelper.remove('user_role');
          ManagerControllerCleaner.clear();
          AppRoutes.goRouter.go(AppRoutes.roleSelection);
        },
      ),
    );
  }

  void editProfile(BuildContext context) {
    Navigator.pop(context);
    AppRoutes.goRouter.go(AppRoutes.settingProfileScreen);
  }
}