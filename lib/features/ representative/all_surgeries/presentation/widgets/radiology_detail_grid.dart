import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/surgery_model.dart';
import '../../../../../core/constants/app_colors.dart';

class RadiologyDetailGrid extends StatelessWidget {
  final List<RadiologyImage> images;

  const RadiologyDetailGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, i) {
        final img = images[i];
        return _RadioDetailCell(image: img);
      },
    );
  }
}

class _RadioDetailCell extends StatelessWidget {
  final RadiologyImage image;
  const _RadioDetailCell({required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: image.imageAsset != null
              ? Image.asset(
            image.imageAsset!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF1A1A1A),
              child: Icon(Icons.image_outlined,
                  color: const Color(0xFF3A3A3A), size: 28.r),
            ),
          )
              : Container(color: const Color(0xFF1A1A1A)),
        ),
        // Label at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding:
            EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
            ),
            child: Text(
              image.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}