import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable network image widget with shimmer placeholder and smooth fade-in.
///
/// Use this for ALL server-loaded images (content images, thumbnails, etc.).
/// Profile/avatar images that use ClipOval can use [CustomNetworkImage] instead.
class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.fitWidth,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 400),
      fadeOutDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => _buildShimmer(),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height ?? 150.h,
            color: const Color(0xFFE9E2DE),
            child: Icon(Icons.broken_image, size: 32.r, color: const Color(0xFF997C67)),
          ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE9E2DE),
      highlightColor: const Color(0xFFF3EFEC),
      child: Container(
        width: width,
        height: height ?? 150.h,
        color: const Color(0xFFE9E2DE),
      ),
    );
  }
}
