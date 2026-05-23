import 'package:app_links/app_links.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import 'core/config/app-routes/app_routes.dart';
import 'core/config/app_themes/app_themes.dart';
import 'core/helpers/network_connection.dart';
import 'core/helpers/prefs_helper.dart';
import 'core/services/oauth_deep_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Defer until after the first frame so the Activity is fully attached
    // to the Flutter engine and the app_links EventChannel is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initDeepLinks());
  }

  Future<void> _initDeepLinks() async {
    try {
      final appLinks = AppLinks();

      // Cold-start: app opened via deep link
      final initial = await appLinks.getInitialLink();
      if (initial != null) {
        await OAuthDeepLinkService.handleUri(initial);
      }

      // App already running: deep link received while in foreground/background
      appLinks.uriLinkStream.listen(
        (uri) => OAuthDeepLinkService.handleUri(uri),
        onError: (_) {},
        cancelOnError: false,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'H.O.L.E App',
            theme: Themes().lightTheme,
            darkTheme: Themes().lightTheme,
            locale: DevicePreview.locale(context),
            routeInformationParser:
                AppRoutes.goRouter.routeInformationParser,
            routeInformationProvider:
                AppRoutes.goRouter.routeInformationProvider,
            routerDelegate: AppRoutes.goRouter.routerDelegate,
            builder: (context, child) {
              return Scaffold(body: NoInterNetScreen(child: child!));
            },
          );
        },
      ),
    );
  }
}
