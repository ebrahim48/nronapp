import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceivingBoxItem {
  final String boxCode;
  final String description;
  final int itemCount;
  final List<String> serialRanges;

  ReceivingBoxItem({
    required this.boxCode,
    required this.description,
    required this.itemCount,
    this.serialRanges = const [],
  });
}

class ReceivingSessionController extends GetxController {
  final totalItem = 50.obs;
  final missing = 0.obs;
  final lowStockAlert = 85.obs;
  final selectedMonth = DateTime(2025, 2).obs;

  final boxes = <ReceivingBoxItem>[
    ReceivingBoxItem(
      boxCode: 'Box 4D-HC-02',
      description: 'Knee Prosthesis - Titanium Grade 5',
      itemCount: 5,
      serialRanges: [
        'SN: jtaxy1331hj - jtaxy1342hj',
        'SN: jtaxy1331hj - jtaxy1342hj',
        'SN: jtaxy1331hj - jtaxy1342hj',
        'SN: jtaxy1331hj - jtaxy1342hj',
        'SN: jtaxy1331hj - jtaxy1342hj',
      ],
    ),
    ReceivingBoxItem(
      boxCode: 'Box 4D-HC-02',
      description: 'Bone Cement - 40g Standard Pack',
      itemCount: 12,
      serialRanges: ['SN: jtaxy1331hj - jtaxy1342hj'],
    ),
    ReceivingBoxItem(
      boxCode: 'Box 4D-HC-02',
      description: 'Knee Prosthesis - Titanium Grade 5',
      itemCount: 5,
      serialRanges: ['SN: jtaxy1331hj - jtaxy1342hj'],
    ),
  ].obs;

  final expandedStates = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    expandedStates.assignAll([true, false, true]);
  }

  void toggleBox(int index) {
    expandedStates[index] = !expandedStates[index];
    expandedStates.refresh();
  }

  void scanItem() {
    Get.snackbar(
      'Scan', 'Scanner opened',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00D5ED),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }
}

