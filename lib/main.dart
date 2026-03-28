import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:toastification/toastification.dart';

import 'core/config/app_themes/app_themes.dart';

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
              title: "Nron App",
              theme: Themes().lightTheme,
              darkTheme: Themes().lightTheme,
              useInheritedMediaQuery: true,
              locale: DevicePreview.locale(context),
              // themeMode: Get.find<ThemeController>().themeMode.value,
              // routeInformationParser: AppRoutes.goRouter.routeInformationParser,
              // routeInformationProvider:
              // AppRoutes.goRouter.routeInformationProvider,
              // routerDelegate: AppRoutes.goRouter.routerDelegate,
              // builder: (context, child) {
              //   return Scaffold(body: NoInterNetScreen(child: child!));
              // },
            );
          }),
    );
  }
}
