import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/sales_model.dart';

class AddRepresentativeController extends GetxController {
  final nameController = TextEditingController(text: 'Alex Johnson');
  final commissionController = TextEditingController();
  final selectedRole = 'Assist'.obs;

  final roles = ['Primary', 'Assist', 'Manager'];

  RepresentativeModel build() {
    return RepresentativeModel(
      name: nameController.text,
      role: selectedRole.value,
      commissionPercent: int.tryParse(
        commissionController.text.replaceAll(RegExp(r'[^\d]'), ''),
      ) ??
          0,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    commissionController.dispose();
    super.onClose();
  }
}