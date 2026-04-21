import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../model/settings_model.dart';


class SettingsController extends GetxController {
  final userProfile = const UserProfileModel(
    name: 'Sarah Johnson',
    role: 'Representative',
    company: 'MedTech Solutions Inc.',
    avatarAsset: 'assets/images/profile.jpg',
    totalPos: 124,
    commYtd: '\$24.5k',
    rating: 4.8,
    email: 'sarah.j@medtech.com',
    phone: '(555) 123-4567',
    territory: 'Northeast Region',
    employeeId: 'EMP-789',
  );

  final settingsTiles = const <SettingsTileModel>[
    SettingsTileModel(
      iconPath: 'assets/icons/lock.svg',
      title: 'Change Password',
      subtitle: 'Update and secure your account password',
      route: AppRoutes.profileScreen,
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


  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final showCurrentPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;


  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  void savePasswordChange() {
    // Validation + save logic
    Get.snackbar(
      'Success',
      'Password updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1DB954).withValues(alpha: 0.9),
    );
  }

  void submitContactSupport() {
    Get.snackbar(
      'Submitted',
      'Your message has been sent',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00D5ED).withValues(alpha: 0.9),
    );
  }

  void logout() {
    // Logout logic
  }

  void deleteAccount() {
    // Delete account logic
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}