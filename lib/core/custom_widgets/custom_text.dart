import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.maxline,
    this.textOverflow,
    this.fontName,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontsize,
    this.textHeight,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textDecoration,
    this.text = "",
  });

  final double left;
  final TextOverflow? textOverflow;
  final double right;
  final double top;
  final double bottom;
  final double? fontsize;
  final FontWeight fontWeight;
  final Color? color;
  final String text;
  final TextAlign textAlign;
  final int? maxline;
  final String? fontName;
  final TextDecoration? textDecoration;
  final double? textHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxline,
        overflow: textOverflow ?? (maxline != null ? TextOverflow.ellipsis : null),
        style: TextStyle(
          decoration: textDecoration ?? TextDecoration.none,
          fontSize: fontsize ?? 14.sp,
          fontFamily: fontName ?? 'Poppins',
          fontWeight: fontWeight,
          color: color ?? AppColors.secondaryTextColor,
          height: textHeight ?? 1.2,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
