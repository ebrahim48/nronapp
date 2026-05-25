import 'package:get/get.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import 'package:nron_app/core/helpers/prefs_helper.dart';
import 'package:nron_app/core/utils/manager_controller_cleaner.dart';

import '../../features/ representative/settingsprofile/controller/setting_controller.dart';

class OAuthDeepLinkService {
  static Future<void> handleUri(Uri uri) async {
    if (uri.scheme != 'nron' || uri.host != 'oauth-callback') return;

    final token = uri.queryParameters['token'];
    final refreshToken = uri.queryParameters['refreshToken'];
    final role = uri.queryParameters['role'] ?? 'representative';

    if (token == null || token.isEmpty) return;

    // Show loading immediately so there's no flash of the previous screen
    AppRoutes.goRouter.go(AppRoutes.oauthLoadingScreen);

    await PrefsHelper.setString('auth_token', token);
    await PrefsHelper.setString('auth_refresh_token', refreshToken ?? '');
    await PrefsHelper.setString('user_role', role);

    switch (role) {
      case 'manager':
        ManagerControllerCleaner.clear();
        AppRoutes.goRouter.go(AppRoutes.managerBottomNavBar);
        break;
      case 'driver':
        AppRoutes.goRouter.go(AppRoutes.driverBottomNavBar);
        break;
      case 'representative':
      default:
        ManagerControllerCleaner.clear();
        if (Get.isRegistered<SettingsController>()) {
          Get.delete<SettingsController>(force: true);
        }
        AppRoutes.goRouter.go(AppRoutes.repBottomNavBar);
        break;
    }
  }
}
