import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import 'core/config/app-routes/app_routes.dart';
import 'core/config/app_themes/app_themes.dart';
import 'core/helpers/network_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: "H.O.L.E App",
              theme: Themes().lightTheme,
              darkTheme: Themes().lightTheme,
              locale: DevicePreview.locale(context),
              // themeMode: Get.find<ThemeController>().themeMode.value,
              routeInformationParser: AppRoutes.goRouter.routeInformationParser,
              routeInformationProvider:
              AppRoutes.goRouter.routeInformationProvider,
              routerDelegate: AppRoutes.goRouter.routerDelegate,
              builder: (context, child) {
                return Scaffold(body: NoInterNetScreen(child: child!));
              },
            );
          }),
    );
  }
}
