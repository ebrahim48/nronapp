import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/sales_model.dart';

class AddRepresentativeController extends GetxController {
  final selectedRepId = ''.obs;
  final selectedRepName = ''.obs;
  final commissionController = TextEditingController();
  final selectedRole = 'Assist'.obs;

  final roles = ['Primary', 'Assist', 'Manager'];

  RepresentativeModel build() {
    return RepresentativeModel(
      id: selectedRepId.value,
      name: selectedRepName.value,
      role: selectedRole.value,
      commissionPercent: int.tryParse(
            commissionController.text.replaceAll(RegExp(r'[^\d]'), ''),
          ) ??
          0,
    );
  }

  @override
  void onClose() {
    commissionController.dispose();
    super.onClose();
  }
}
