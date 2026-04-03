import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class NewTrayController extends GetxController {
  // Photo
  final selectedPhoto = Rxn<File>();
  final _picker = ImagePicker();

  // Form fields
  final trayIdController = TextEditingController();
  final facilityController = TextEditingController();
  final vendorController = TextEditingController();
  final returnDateController = TextEditingController();
  final additionalNotesController = TextEditingController();

  // Dropdowns
  final selectedFacility = ''.obs;
  final selectedVendor = ''.obs;
  final selectedSystemType = ''.obs;

  // Inventory model — 0: Loaner, 1: Consignment
  final inventoryModelIndex = 0.obs;

  // Status — 0: Down Rack, 1: Wrapped, 2: Warehouse
  final statusIndex = 0.obs;

  final facilityOptions = [
    'City General Hospital',
    'Ortho Health Center',
    'Advanced Care Clinic',
    'Joint Rehabilitation Center',
    'Central Medical Complex',
    'Sunrise Surgical Hospital',
    'Metro Bone & Joint Clinic',
    'National Orthopedic Institute',
  ];

  final vendorOptions = ['Vendor A', 'Vendor B', 'Vendor C'];
  final systemTypeOptions = ['Type A', 'Type B', 'Type C'];

  Future<void> pickPhotoFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (image != null) selectedPhoto.value = File(image.path);
  }

  Future<void> pickPhotoFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) selectedPhoto.value = File(image.path);
  }

  void removePhoto() => selectedPhoto.value = null;

  void selectFacility(String val) => selectedFacility.value = val;

  void selectVendor(String val) => selectedVendor.value = val;
  void selectSystemType(String val) => selectedSystemType.value = val;
  void selectInventoryModel(int i) => inventoryModelIndex.value = i;
  void selectStatus(int i) => statusIndex.value = i;

  void pickReturnDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF00C5DA)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      returnDateController.text =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void createTrayRecord() {
    // Submit logic
  }

  @override
  void onClose() {
    trayIdController.dispose();
    facilityController.dispose();
    vendorController.dispose();
    returnDateController.dispose();
    additionalNotesController.dispose();
    super.onClose();
  }
}
