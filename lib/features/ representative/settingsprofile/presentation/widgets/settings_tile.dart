import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SettingsTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final IconData? fallbackIcon;

  const SettingsTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
        ),
        child: Row(
          children: [
            _SvgOrIconWidget(
              iconPath: iconPath,
              fallbackIcon: fallbackIcon ?? Icons.settings,
              size: 20.r,
              color: iconColor ?? AppColors.primaryColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    CustomText(
                      text: subtitle!,
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.secondaryTextColor, size: 20.r),
          ],
        ),
      ),
    );
  }
}

class _SvgOrIconWidget extends StatefulWidget {
  final String iconPath;
  final IconData fallbackIcon;
  final double size;
  final Color color;

  const _SvgOrIconWidget({
    required this.iconPath,
    required this.fallbackIcon,
    required this.size,
    required this.color,
  });

  @override
  State<_SvgOrIconWidget> createState() => _SvgOrIconWidgetState();
}

class _SvgOrIconWidgetState extends State<_SvgOrIconWidget> {
  late Future<bool> _exists;

  @override
  void initState() {
    super.initState();
    _exists = rootBundle
        .load(widget.iconPath)
        .then((_) => true)
        .catchError((_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _exists,
      builder: (_, snap) {
        final assetExists = snap.data == true;
        if (assetExists) {
          return SvgPicture.asset(
            widget.iconPath,
            width: widget.size,
            height: widget.size,
            colorFilter:
                ColorFilter.mode(widget.color, BlendMode.srcIn),
          );
        }
        return Icon(widget.fallbackIcon, size: widget.size, color: widget.color);
      },
    );
  }
}
