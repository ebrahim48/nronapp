import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'custom_loader.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onpress;
  final String title;
  final Color? color;
  final Color? titlecolor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool loading;
  final bool loaderIgnore;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomButton({
    super.key,
    required this.title,
    this.borderColor,
    required this.onpress,
    this.color,
    this.height,
    this.width,
    this.fontSize,
    this.titlecolor,
    this.prefixIcon,
    this.suffixIcon,
    this.loading = false,
    this.loaderIgnore = false,
    this.fontWeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? () {} : onpress,
      child: Container(
        width: width ?? 345.w,
        height: height ?? 48.h,
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 10.h,
          left: 24.w,
          right: 24.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
          color: color ?? AppColors.primaryColor,
        ),
        child: loading
            ? const Center(child: CustomLoader())
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    SizedBox(width: 10.w),
                  ],
                  CustomText(
                    text: title,
                    fontsize: fontSize ?? 14.sp,
                    color: titlecolor ?? AppColors.primaryTextColor,
                    fontWeight: fontWeight ?? FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  if (suffixIcon != null) ...[
                    SizedBox(width: 10.w),
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
