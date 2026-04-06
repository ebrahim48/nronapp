import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../presentation/report_success_screen.dart';

class MissingInstrumentController extends GetxController {
  final instrumentNameController = TextEditingController();
  final vendorEmailController = TextEditingController();
  final serialNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final instrumentPhoto = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        instrumentPhoto.value = File(image.path);
      }
    } catch (e) {
      debugPrint('Error picking photo: $e');
    }
  }

  void removePhoto() {
    instrumentPhoto.value = null;
  }

  void submitReport() {
    Get.to(() => const ReportSuccessScreen());
  }

  @override
  void onClose() {
    instrumentNameController.dispose();
    vendorEmailController.dispose();
    serialNumberController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}