import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';

// ProfileScreen is no longer used.
// Change Password is handled via bottom sheet in SettingProfileScreen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRoutes.settingProfileScreen);
    });
    return const SizedBox.shrink();
  }
}
