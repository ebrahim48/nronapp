import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoProductItem {
  final String boxCode;
  final String description;
  final int itemCount;
  final List<String> serialRanges;

  PoProductItem({
    required this.boxCode,
    required this.description,
    required this.itemCount,
    this.serialRanges = const [],
  });
}

class PoDocumentItem {
  final String fileName;
  final String size;
  final String date;
  final String type;

  const PoDocumentItem({
    required this.fileName,
    required this.size,
    required this.date,
    required this.type,
  });
}

class ReviewSendPoController extends GetxController {
  final isLoading = false.obs;
  final expandedStates = <bool>[].obs;

  final String poNumber = '#88234';
  final String poType = 'Emergency';
  final String title = 'Urgent Surgical Supplies';
  final String heroImageAsset = 'assets/images/activeshipments.png';
  final String patientId = '1002120JSC2254S';
  final String facility = 'City Hospital';
  final String facilityEmail = 'example@gmial.com';
  final String surgeon = 'Dr. Michael Lee';
  final String surgeonSpecialty = 'Orthopedic Surgery';
  final String dateOfSurgery = 'Feb 14, 2024';
  final String surgeryTime = '08:30 AM EST';
  final String vendor = 'MedTech Inc.';
  final String vendorEmail = 'example@gmi...';
  final double totalAmount = 4250.00;

  final List<PoProductItem> products = [
    PoProductItem(
      boxCode: 'Box 4D-HC-02',
      description: 'Bone Cement - 40g Standard Pack',
      itemCount: 12,
      serialRanges: [
        'SN: jtaxy1331hj - jtaxy1342hj',
        'SN: jtaxy1331hj - jtaxy1342hj',
      ],
    ),
    PoProductItem(
      boxCode: 'Box 4D-HC-02',
      description: 'Bone Cement - 40g Standard Pack',
      itemCount: 12,
      serialRanges: ['SN: jtaxy1331hj - jtaxy1342hj'],
    ),
  ];

  final List<PoDocumentItem> documents = const [
    PoDocumentItem(fileName: 'PO_889_Final.pdf', size: '1.2 MB', date: 'FEB 15', type: 'pdf'),
    PoDocumentItem(fileName: 'Implant_Serial_Photo.jpg', size: '3.4 MB', date: 'FEB 15', type: 'image'),
  ];

  @override
  void onInit() {
    super.onInit();
    expandedStates.assignAll(List.generate(products.length, (_) => false));
  }

  void toggleProduct(int index) {
    expandedStates[index] = !expandedStates[index];
    expandedStates.refresh();
  }

  Future<void> saveAndSend() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isLoading.value = false;
    Get.back();
    Get.snackbar(
      'Success', 'PO sent to vendor successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00D5ED),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }
}