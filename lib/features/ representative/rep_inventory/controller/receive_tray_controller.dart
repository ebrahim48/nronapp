import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReceiveTrayController extends GetxController {
  final initialPhoto = Rxn<File>();
  final brokenPhotos = <File>[].obs;
  final brokenNotesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> captureInitialPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        initialPhoto.value = File(image.path);
      }
    } catch (e) {
      debugPrint('Error capturing initial photo: $e');
    }
  }

  Future<void> addBrokenPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        brokenPhotos.add(File(image.path));
      }
    } catch (e) {
      debugPrint('Error adding broken photo: $e');
    }
  }

  void removeInitialPhoto() {
    initialPhoto.value = null;
  }

  void removeBrokenPhoto(int index) => brokenPhotos.removeAt(index);

  void confirmReceive() {

  }

  @override
  void onClose() {
    brokenNotesController.dispose();
    super.onClose();
  }
}