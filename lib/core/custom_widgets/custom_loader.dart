import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/app_colors.dart';

class CustomLoader extends StatelessWidget {
  final double? top;
  final double? bottom;
  final Color? color;
  final double? size;
  const CustomLoader({super.key, this.top, this.bottom, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top ?? 0, bottom: bottom ?? 0),
      child: SpinKitCircle(color: color ?? AppColors.textColorFFFFFF, size: size ?? 48.h),
    );
  }
}
