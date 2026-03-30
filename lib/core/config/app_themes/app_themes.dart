import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';


class Themes {
  final lightTheme = ThemeData.light().copyWith(
    // Set colorScheme to eliminate default Material purple
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      secondary: AppColors.textColor997C67,
      onSecondary: Colors.white,
      surface: AppColors.backgroundColor,
      onSurface: AppColors.textColor24150E,
      error: AppColors.redColorFF1D1D,
      onError: Colors.white,
    ),
    primaryColor: AppColors.primaryColor,

    // Progress indicators, sliders, switches etc.
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
      linearTrackColor: AppColors.textColorF3EFEC,
    ),

    ///-------------------------elevated button theme------------------------->
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: Size(double.maxFinite, 56.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),

    ///-----------------app bar theme------------------>
    appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        color: AppColors.backgroundColor,
        centerTitle: true,
        elevation: 0),

    inputDecorationTheme: InputDecorationTheme(fillColor: Colors.black87),

    iconTheme: IconThemeData(color: Colors.black),
    scaffoldBackgroundColor: AppColors.backgroundColor,

    // Text selection (cursor, handles, highlight)
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.primaryColor,
    ),

    // Checkbox, Radio, Switch
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primaryColor;
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(Colors.white),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primaryColor;
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primaryColor.withValues(alpha: 0.5);
        return Colors.grey.withValues(alpha: 0.3);
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primaryColor;
        return Colors.grey;
      }),
    ),
  );

  ///----------------------------dart theme------------------------------->
  final darkTheme = ThemeData.dark().copyWith(
    ///------------------------- button theme------------------------->
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        minimumSize: Size(double.maxFinite, 56.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),

    scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(Colors.red.withValues(alpha: 0.50))),

    ///-----------------app bar theme------------------>
    appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.white10),
  );
}
