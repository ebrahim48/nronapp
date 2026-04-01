import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BulkProductItem {
  final String iconPath;
  final String name;
  final String detail; 
  final String price;

  BulkProductItem({
    required this.iconPath,
    required this.name,
    required this.detail,
    required this.price,
  });
}

class BulkPurchaseController extends GetxController {
  // Step indicator
  final currentStep = 2.obs;
  final totalSteps = 3.obs;

  // Form fields
  final selectedStatus = 'Complete'.obs;
  final patientIdController = TextEditingController();
  final surgeonNameController = TextEditingController();
  final facilityController = TextEditingController();
  final facilityEmailController = TextEditingController();
  final procedureDateController = TextEditingController();
  final poNumberController = TextEditingController(text: 'PO-0000');
  final vendorNameController = TextEditingController();
  final vendorEmailController = TextEditingController();
  final additionalNotesController = TextEditingController();

  // Send vendor email toggle
  final sendVendorEmail = true.obs;

  // Bulk products list
  final bulkProducts = <BulkProductItem>[
    BulkProductItem(
      iconPath: 'assets/icons/bulk.svg',
      name: 'Bulk Quinoa',
      detail: '50kg × \$4.50',
      price: '\$225.00',
    ),
    BulkProductItem(
      iconPath: 'assets/icons/bulk.svg',
      name: 'Flax Seeds',
      detail: '20kg × \$3.20',
      price: '\$64.00',
    ),
  ].obs;

  // Attached documents
  final attachedDocs = <Map<String, String>>[
    {'name': 'rep_sheet_INV43.pdf', 'time': 'Uploaded 2m ago'},
  ].obs;

  final statusOptions = ['Complete', 'Pending', 'In Progress', 'Cancelled'];

  void toggleVendorEmail(bool val) => sendVendorEmail.value = val;

  void removeProduct(int index) => bulkProducts.removeAt(index);

  void addProduct() {
    // Navigate to product search / add product flow
  }

  void deleteDoc(int index) => attachedDocs.removeAt(index);

  final _picker = ImagePicker();
  final isUploading = false.obs;

  String _uploadedAt() {
    final now = DateTime.now();
    return 'Uploaded at ${DateFormat('hh:mm a').format(now)}';
  }

  Future<void> uploadPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        attachedDocs.add({
          'name': file.name,
          'time': _uploadedAt(),
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not pick file. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E2121),
        colorText: Colors.white,
      );
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        final name = photo.name.isNotEmpty
            ? photo.name
            : 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        attachedDocs.add({
          'name': name,
          'time': _uploadedAt(),
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open camera. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E2121),
        colorText: Colors.white,
      );
    }
  }

  void saveOrder() {}
  void continueOrder() {}

  @override
  void onClose() {
    patientIdController.dispose();
    surgeonNameController.dispose();
    facilityController.dispose();
    facilityEmailController.dispose();
    procedureDateController.dispose();
    poNumberController.dispose();
    vendorNameController.dispose();
    vendorEmailController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}