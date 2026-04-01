import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddedProduct {
  final String iconPath;
  final String name;
  final String detail;
  final double price;

  AddedProduct({
    required this.iconPath,
    required this.name,
    required this.detail,
    required this.price,
  });
}

class AddProductController extends GetxController {
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();

  final addedItems = <AddedProduct>[
    AddedProduct(
      iconPath: 'assets/icons/bulk.svg',
      name: 'Bulk Quinoa',
      detail: '50kg × \$4.50',
      price: 225.00,
    ),
    AddedProduct(
      iconPath: 'assets/icons/bulk.svg',
      name: 'Flax Seeds',
      detail: '20kg × \$3.20',
      price: 64.00,
    ),
  ].obs;

  double get totalEstCost =>
      addedItems.fold(0.0, (sum, item) => sum + item.price);

  void addProduct() {
    final name = itemNameController.text.trim();
    final qty = int.tryParse(quantityController.text.trim()) ?? 0;
    final price = double.tryParse(unitPriceController.text.trim()) ?? 0.0;
    if (name.isEmpty || qty == 0 || price == 0.0) return;

    addedItems.add(AddedProduct(
      iconPath: 'assets/icons/bulk.svg',
      name: name,
      detail: '${qty}kg × \$${price.toStringAsFixed(2)}',
      price: qty * price,
    ));

    itemNameController.clear();
    quantityController.clear();
    unitPriceController.clear();
  }

  void removeItem(int index) => addedItems.removeAt(index);

  void addToPO() => Get.back(result: addedItems.toList());

  @override
  void onClose() {
    itemNameController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    super.onClose();
  }
}