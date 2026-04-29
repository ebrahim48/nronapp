import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/physician_repository.dart';
import '../domain/model/physician_model.dart';

class AddPhysicianController extends GetxController {
  final _repo = PhysicianRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final fullNameController = TextEditingController();
  final practiceNameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final cellController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final noteController = TextEditingController();

  final specialties = ['Ortho', 'Neuro', 'Pain', 'Ortho/Spine', 'Peds', 'DPM'];
  final selectedSpecialty = 'Ortho'.obs;

  final businessCard = Rxn<File>();
  final businessCardIsPdf = false.obs;
  final profilePicture = Rxn<File>();

  final isSubmitting = false.obs;

  // UI label → API value
  static const _specialtyUiToApi = {
    'Ortho': 'ortho',
    'Neuro': 'neuro',
    'Pain': 'pain',
    'Ortho/Spine': 'ortho/spine',
    'Peds': 'peds',
    'DPM': 'dmp',
  };

  // API value → UI label
  static const _specialtyApiToUi = {
    'ortho': 'Ortho',
    'neuro': 'Neuro',
    'pain': 'Pain',
    'ortho/spine': 'Ortho/Spine',
    'peds': 'Peds',
    'dmp': 'DPM',
  };

  void selectSpecialty(String s) => selectedSpecialty.value = s;

  void prefillForEdit(PhysicianModel physician) {
    fullNameController.text = physician.fullName;
    practiceNameController.text = physician.practice;
    locationController.text = physician.location;
    phoneController.text = physician.contactInfo.phoneNumber;
    cellController.text = physician.contactInfo.cellNumber;
    emailController.text = physician.contactInfo.email;
    noteController.text = physician.noteToSelf;

    final dob = physician.contactInfo.dateOfBirth;
    if (dob.isNotEmpty) {
      try {
        final dt = DateTime.parse(dob);
        dobController.text = DateFormat('MM/dd/yyyy').format(dt);
      } catch (_) {}
    }

    selectedSpecialty.value =
        _specialtyApiToUi[physician.specialty.toLowerCase()] ?? 'Ortho';
  }

  Future<void> submitPhysician(
    BuildContext context, {
    String? physicianId,
  }) async {
    final fullName = fullNameController.text.trim();
    final practice = practiceNameController.text.trim();
    final location = locationController.text.trim();
    final phone = phoneController.text.trim();
    final cell = cellController.text.trim();
    final email = emailController.text.trim();
    final dob = dobController.text.trim();
    final note = noteController.text.trim();

    if (fullName.isEmpty || practice.isEmpty || location.isEmpty || phone.isEmpty) {
      ToastMessageHelper.showToastMessage(
          'Full name, practice, location and phone are required.',
          title: 'Warning');
      return;
    }

    String apiDob = '';
    if (dob.isNotEmpty) {
      try {
        final dt = DateFormat('MM/dd/yyyy').parse(dob);
        apiDob = DateFormat('yyyy-MM-dd').format(dt);
      } catch (_) {
        apiDob = dob;
      }
    }

    isSubmitting.value = true;
    try {
      final token = await PrefsHelper.getString('auth_token');
      final role = await PrefsHelper.getString('user_role');
      final refreshToken = await PrefsHelper.getString('auth_refresh_token');
      debugPrint('▶▶▶ ROLE: $role');
      debugPrint('▶▶▶ TOKEN LEN: ${token.length}  START: ${token.length > 20 ? token.substring(0, 20) : token}');
      debugPrint('▶▶▶ REFRESH LEN: ${refreshToken.length}  START: ${refreshToken.length > 20 ? refreshToken.substring(0, 20) : refreshToken}');
      final specialty = _specialtyUiToApi[selectedSpecialty.value] ?? 'ortho';

      Map<String, dynamic> res;
      if (physicianId == null) {
        res = await _repo.create(
          token,
          fullName: fullName,
          email: email,
          practice: practice,
          specialty: specialty,
          location: location,
          phoneNumber: phone,
          cellNumber: cell,
          dateOfBirth: apiDob,
          noteToSelf: note,
          docs: businessCard.value,
          profileImage: profilePicture.value,
        );
      } else {
        res = await _repo.update(
          token,
          physicianId,
          fullName: fullName,
          practice: practice,
          specialty: specialty,
          location: location,
          phoneNumber: phone,
          cellNumber: cell,
          dateOfBirth: apiDob.isNotEmpty ? apiDob : null,
          noteToSelf: note,
          docs: businessCard.value,
          profileImage: profilePicture.value,
        );
      }

      if (res['success'] == true) {
        final msg = physicianId == null
            ? 'Physician created successfully.'
            : 'Physician updated successfully.';
        ToastMessageHelper.showToastMessage(msg, title: 'Success');
        if (context.mounted) Navigator.pop(context, true);
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.',
          title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to save physician.',
          title: 'Error');
    } finally {
      isSubmitting.value = false;
    }
  }

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
        source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
      );
      if (xf != null) {
        businessCard.value = File(xf.path);
        businessCardIsPdf.value = false;
      }
    }
  }

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
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: Color(0xFF00C5DA)),
              title: const Text('Choose from Gallery',
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            if (allowPdf)
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined,
                    color: Color(0xFF00C5DA)),
                title: const Text('Upload PDF',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'Poppins')),
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
    locationController.dispose();
    phoneController.dispose();
    cellController.dispose();
    emailController.dispose();
    dobController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
