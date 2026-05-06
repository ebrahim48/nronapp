import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class ReceiveTrayController extends GetxController {
  String trayId = '';

  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final initialPhoto = Rxn<File>();
  final brokenPhotos = <File>[].obs;
  final brokenNotesController = TextEditingController();
  final isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> captureInitialPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) initialPhoto.value = File(image.path);
    } catch (_) {}
  }

  Future<void> addBrokenPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) brokenPhotos.add(File(image.path));
    } catch (_) {}
  }

  void removeInitialPhoto() => initialPhoto.value = null;

  void removeBrokenPhoto(int index) => brokenPhotos.removeAt(index);

  Future<bool> confirmReceive() async {
    if (trayId.isEmpty) {
      ToastMessageHelper.showErrorMessage('Tray ID is missing');
      return false;
    }
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.receiveTray(
        token,
        trayId,
        thumbnail: initialPhoto.value,
        files: brokenPhotos.isNotEmpty ? brokenPhotos.toList() : null,
      );
      ToastMessageHelper.showSuccessMessage('Tray received successfully');
      return true;
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to receive tray';
      ToastMessageHelper.showErrorMessage(msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    brokenNotesController.dispose();
    super.onClose();
  }
}