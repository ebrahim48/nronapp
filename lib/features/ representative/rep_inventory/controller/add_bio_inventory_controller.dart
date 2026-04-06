import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBioInventoryController extends GetxController {
  final itemNameController = TextEditingController();
  final lotNumberController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final additionalNotesController = TextEditingController();

  final selectedVendor = Rxn<String>();
  final expiryDate = Rxn<DateTime>();

  final vendorOptions = [
    'BioTech Supplies Inc.',
    'MedLab Solutions',
    'Global Bio Resources',
    'Advanced Reagent Co.',
  ];

  void selectVendor(String? value) {
    selectedVendor.value = value;
  }

  Future<void> pickExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1AC8DB),
              onPrimary: Colors.white,
              surface: Color(0xFF1E2121),
              onSurface: Color(0xFFD4D4D4),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      expiryDate.value = picked;
    }
  }

  void saveBioInventory() {
    // TODO: Implement save logic
  }

  @override
  void onClose() {
    itemNameController.dispose();
    lotNumberController.dispose();
    quantityController.dispose();
    locationController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}
