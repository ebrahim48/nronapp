import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/profile_repository.dart';
import '../domain/model/settings_model.dart';

class SettingsController extends GetxController {
  final _repo = ProfileRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  // ── Profile ──────────────────────────────────────────────────────────────
  final profile = Rxn<UserProfileModel>();
  final isLoadingProfile = false.obs;
  final selectedImage = Rxn<File>();

  // ── Edit profile fields ───────────────────────────────────────────────────
  final fullNameCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final designationCtrl = TextEditingController();
  final isUpdatingProfile = false.obs;

  // ── Change password ───────────────────────────────────────────────────────
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final showCurrentPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;
  final isChangingPassword = false.obs;

  // ── Contact support ───────────────────────────────────────────────────────
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final isSubmittingSupport = false.obs;

  // ── Static content (About / Terms / Privacy) ──────────────────────────────
  final aboutContent = Rxn<String>();
  final termsContent = Rxn<String>();
  final privacyContent = Rxn<String>();
  final isLoadingContent = false.obs;

  // ── Settings tiles ────────────────────────────────────────────────────────
  final settingsTiles = const <SettingsTileModel>[
    SettingsTileModel(
      iconPath: 'assets/icons/lock.svg',
      title: 'Change Password',
      subtitle: 'Update and secure your account password',
      route: '',
    ),
    SettingsTileModel(
      iconPath: 'assets/icons/contact.svg',
      title: 'Help & Support',
      subtitle: 'Get help or send us a message',
      route: AppRoutes.contactSupportScreen,
    ),
    SettingsTileModel(
      iconPath: 'assets/icons/about.svg',
      title: 'Others',
      subtitle: 'App details, policies & more information',
      route: AppRoutes.othersScreen,
    ),
  ];

  final othersTiles = <OthersTileModel>[
    OthersTileModel(
      iconPath: 'assets/icons/terms.svg',
      title: 'Privacy Policy',
      route: AppRoutes.privacyPolicyScreen,
    ),
    OthersTileModel(
      iconPath: 'assets/icons/terms.svg',
      title: 'Term & Condition',
      route: AppRoutes.termsConditionsScreen,
    ),
    OthersTileModel(
      iconPath: 'assets/icons/about.svg',
      title: 'About H.O.L.E',
      route: AppRoutes.aboutHoleScreen,
    ),
    OthersTileModel(
      iconPath: 'assets/icons/logout.svg',
      title: 'Delete Account',
      route: '',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // ── Fetch profile ─────────────────────────────────────────────────────────
  Future<void> fetchProfile() async {
    try {
      isLoadingProfile.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getMyProfile(token);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>? ?? {};
        profile.value = UserProfileModel.fromJson(data);
        _prefillEditControllers();
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to load profile.', title: 'Error');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void _prefillEditControllers() {
    fullNameCtrl.text = profile.value?.fullName ?? '';
    bioCtrl.text = profile.value?.bio ?? '';
    designationCtrl.text = profile.value?.designation ?? '';
  }

  // ── Pick image ────────────────────────────────────────────────────────────
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) selectedImage.value = File(picked.path);
  }

  // ── Update profile ────────────────────────────────────────────────────────
  Future<void> updateProfile() async {
    final fullName = fullNameCtrl.text.trim();
    if (fullName.isEmpty) {
      ToastMessageHelper.showToastMessage('Full name is required.', title: 'Warning');
      return;
    }
    try {
      isUpdatingProfile.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.updateMyProfile(
        token,
        fullName: fullName,
        bio: bioCtrl.text.trim(),
        designation: designationCtrl.text.trim(),
        profileImage: selectedImage.value,
      );
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>? ?? {};
        profile.value = UserProfileModel.fromJson(data);
        selectedImage.value = null;
        Get.back();
        ToastMessageHelper.showToastMessage('Profile updated successfully.');
      } else {
        ToastMessageHelper.showToastMessage(
          res['message']?.toString() ?? 'Update failed.',
          title: 'Error',
        );
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Something went wrong.', title: 'Error');
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // ── Change password ───────────────────────────────────────────────────────
  Future<void> savePasswordChange() async {
    final old = currentPasswordController.text.trim();
    final newP = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (old.isEmpty || newP.isEmpty || confirm.isEmpty) {
      ToastMessageHelper.showToastMessage('All fields are required.', title: 'Warning');
      return;
    }
    if (newP != confirm) {
      ToastMessageHelper.showToastMessage('Passwords do not match.', title: 'Warning');
      return;
    }
    if (newP.length < 8) {
      ToastMessageHelper.showToastMessage(
        'Password must be at least 8 characters.',
        title: 'Warning',
      );
      return;
    }
    try {
      isChangingPassword.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.changePassword(
        token,
        oldPassword: old,
        newPassword: newP,
        confirmPassword: confirm,
      );
      if (res['success'] == true) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.back();
        ToastMessageHelper.showToastMessage('Password changed successfully.');
      } else {
        ToastMessageHelper.showToastMessage(
          res['message']?.toString() ?? 'Failed to change password.',
          title: 'Error',
        );
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Something went wrong.', title: 'Error');
    } finally {
      isChangingPassword.value = false;
    }
  }

  // ── Contact support ───────────────────────────────────────────────────────
  Future<void> submitContactSupport() async {
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();
    if (subject.isEmpty || message.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Subject and message are required.',
        title: 'Warning',
      );
      return;
    }
    try {
      isSubmittingSupport.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.sendSupportMessage(
        token,
        subject: subject,
        message: message,
      );
      if (res['success'] == true) {
        subjectController.clear();
        messageController.clear();
        ToastMessageHelper.showToastMessage('Message sent successfully.');
      } else {
        ToastMessageHelper.showToastMessage(
          res['message']?.toString() ?? 'Failed to send message.',
          title: 'Error',
        );
      }
    } on NoInternetException {
      ToastMessageHelper.showToastMessage('No internet connection.', title: 'Error');
    } on ServerException catch (e) {
      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } catch (_) {
      ToastMessageHelper.showToastMessage('Something went wrong.', title: 'Error');
    } finally {
      isSubmittingSupport.value = false;
    }
  }

  // ── Static content ────────────────────────────────────────────────────────
  Future<void> fetchAboutUs() async {
    try {
      isLoadingContent.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getAboutUs(token);
      if (res['success'] == true) {
        final list = res['data'] as List? ?? [];
        if (list.isNotEmpty) {
          aboutContent.value =
              (list.first as Map<String, dynamic>)['content'] as String?;
        }
      }
    } catch (_) {} finally {
      isLoadingContent.value = false;
    }
  }

  Future<void> fetchTerms() async {
    try {
      isLoadingContent.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getTerms(token);
      if (res['success'] == true) {
        final list = res['data'] as List? ?? [];
        if (list.isNotEmpty) {
          termsContent.value =
              (list.first as Map<String, dynamic>)['content'] as String?;
        }
      }
    } catch (_) {} finally {
      isLoadingContent.value = false;
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoadingContent.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getPrivacyPolicy(token);
      if (res['success'] == true) {
        final list = res['data'] as List? ?? [];
        if (list.isNotEmpty) {
          privacyContent.value =
              (list.first as Map<String, dynamic>)['content'] as String?;
        }
      }
    } catch (_) {} finally {
      isLoadingContent.value = false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  void logout() async {
    await PrefsHelper.remove('auth_token');
    await PrefsHelper.remove('auth_refresh_token');
    await PrefsHelper.remove('user_role');
    AppRoutes.goRouter.go(AppRoutes.roleSelection);
  }

  void deleteAccount() {}

  @override
  void onClose() {
    fullNameCtrl.dispose();
    bioCtrl.dispose();
    designationCtrl.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
