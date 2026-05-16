import 'package:get/get.dart';

class ScannedItem {
  final String productId; // DB _id of the product record
  final String name;
  final String price;
  final String serial; // scanned barcode / slName

  const ScannedItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.serial,
  });
}

class ScanSessionController extends GetxController {
  final items = <ScannedItem>[].obs;

  void add(ScannedItem item) => items.add(item);

  void remove(int index) => items.removeAt(index);

  void clear() => items.clear();

  int get count => items.length;
}
