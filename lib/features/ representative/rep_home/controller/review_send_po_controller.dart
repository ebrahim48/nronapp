import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewSendPoController extends GetxController {
  // Step info
  final RxInt currentStep = 2.obs;
  final RxInt totalSteps = 2.obs;

  // PO details
  final RxString poNumber = 'PO #88234'.obs;
  final RxString poType = 'Emergency'.obs;
  final RxString poStatus = 'Draft'.obs;
  final RxString poTitle = 'Urgent Surgical Supplies'.obs;

  final RxString patientId = '1002120JSC2254S'.obs;
  final RxString facility = 'City Hospital'.obs;
  final RxString facilityEmail = 'example@gmial.com'.obs;
  final RxString surgeon = 'Dr. Michael Lee'.obs;
  final RxString surgeonSpecialty = 'Orthopedic Surgery'.obs;
  final RxString dateOfSurgery = 'Feb 14, 2024'.obs;
  final RxString surgeryTime = '08:30 AM EST'.obs;
  final RxString vendor = 'MedTech Inc.'.obs;
  final RxString vendorEmail = 'example@gmi...'.obs;
  final RxDouble totalAmount = 4250.00.obs;

  // Handwritten PO image
  final RxString handwrittenPoImage = 'assets/images/review.png'.obs;
  final RxString handwrittenPoFileName = 'PO_scan_88234.jpg'.obs;

  // Documents
  final RxList<Map<String, dynamic>> documents = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'PO_889_Final.pdf',
      'size': '1.2 MB',
      'date': 'FEB 15',
      'type': 'pdf',
    },
    {
      'id': '2',
      'name': 'Implant_Serial_Photo.jpg',
      'size': '3.4 MB',
      'date': 'FEB 15',
      'type': 'image',
    },
  ].obs;

  final RxBool isLoading = false.obs;

  Future<void> saveAndSend() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.snackbar(
      'Success',
      'PO saved and sent to vendor successfully',
      backgroundColor: const Color(0xff00C2CB),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewHandwrittenPo() {
    Get.snackbar('View', 'Opening handwritten PO...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void viewDocument(Map<String, dynamic> doc) {
    Get.snackbar('View', 'Opening ${doc['name']}...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void addNote() {
    Get.snackbar('Note', 'Add note tapped',
        snackPosition: SnackPosition.BOTTOM);
  }
}


