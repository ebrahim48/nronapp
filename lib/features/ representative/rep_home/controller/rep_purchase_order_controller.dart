
import 'package:get/get.dart';

enum OrderType { standard, bulkBio }

class NewPoController extends GetxController {
  final Rx<OrderType> selectedType = Rx<OrderType>(OrderType.standard);

  void selectType(OrderType type) {
    selectedType.value = type;
  }

  bool isSelected(OrderType type) => selectedType.value == type;

  void proceedToNext() {
    // Navigate to step 2
    // Get.toNamed(AppRoutePaths.newPoStep2);
  }
}