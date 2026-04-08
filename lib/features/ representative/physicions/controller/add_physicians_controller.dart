import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPhysicianController extends GetxController {
  final fullNameController = TextEditingController();
  final practiceNameController = TextEditingController();
  final phoneController = TextEditingController();
  final cellController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final noteController = TextEditingController();

  // Specialty chips
  final specialties = ['Ortho', 'Neuro', 'Pain', 'Ortho/Spine', 'Peds', 'DPM'];
  final selectedSpecialty = 'Ortho'.obs;

  // Documents
  final businessCard = Rxn<File>();
  final businessCardIsPdf = false.obs;
  final profilePicture = Rxn<File>();

  void selectSpecialty(String s) => selectedSpecialty.value = s;

  // ── Calendar date picker ─────────────────────────────────────────────────────
  Future<void> pickDOB(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1985),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00C5DA),
            onPrimary: Colors.white,
            surface: Color(0xFF252525),
            onSurface: Colors.white,
          ),
          dialogTheme:
              const DialogThemeData(backgroundColor: Color(0xFF1E2427)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dobController.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  // ── Business Card: image or PDF ──────────────────────────────────────────────
  Future<void> pickBusinessCard(BuildContext context) async {
    final choice = await _showSourceDialog(
      context,
      title: 'Business Card',
      allowPdf: true,
    );
    if (choice == null) return;

    if (choice == 'pdf') {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result?.files.single.path != null) {
        businessCard.value = File(result!.files.single.path!);
        businessCardIsPdf.value = true;
      }
    } else {
      final xf = await ImagePicker().pickImage(
        source:
            choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
      );
      if (xf != null) {
        businessCard.value = File(xf.path);
        businessCardIsPdf.value = false;
      }
    }
  }

  // ── Profile Picture: image only ──────────────────────────────────────────────
  Future<void> pickProfilePicture(BuildContext context) async {
    final choice = await _showSourceDialog(
      context,
      title: 'Profile Picture',
      allowPdf: false,
    );
    if (choice == null) return;

    final xf = await ImagePicker().pickImage(
      source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
    );
    if (xf != null) {
      profilePicture.value = File(xf.path);
    }
  }

  // ── Bottom sheet source picker ───────────────────────────────────────────────
  Future<String?> _showSourceDialog(
    BuildContext context, {
    required String title,
    required bool allowPdf,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF252525),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF555555),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined,
                  color: Color(0xFF00C5DA)),
              title: const Text('Take Photo',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: Color(0xFF00C5DA)),
              title: const Text('Choose from Gallery',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            if (allowPdf)
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined,
                    color: Color(0xFF00C5DA)),
                title: const Text('Upload PDF',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                onTap: () => Navigator.pop(context, 'pdf'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void removeBusinessCard() {
    businessCard.value = null;
    businessCardIsPdf.value = false;
  }

  void removeProfilePicture() => profilePicture.value = null;

  @override
  void onClose() {
    fullNameController.dispose();
    practiceNameController.dispose();
    phoneController.dispose();
    cellController.dispose();
    emailController.dispose();
    dobController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
