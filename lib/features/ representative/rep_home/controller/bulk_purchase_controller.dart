import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';

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
  final attachedDocs = <File>[].obs;

  final statusOptions = ['Op', 'Lost', 'Complete'];

  void toggleVendorEmail(bool val) => sendVendorEmail.value = val;

  void removeProduct(int index) => bulkProducts.removeAt(index);

  void addProduct(BuildContext context) {
   context.pushNamed(AppRoutes.addProductScreen);
  }

  void deleteDoc(int index) => attachedDocs.removeAt(index);

  final _picker = ImagePicker();
  final isUploading = false.obs;

  Future<void> uploadPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        for (final f in result.files) {
          if (f.path != null) attachedDocs.add(File(f.path!));
        }
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
      if (photo != null) attachedDocs.add(File(photo.path));
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