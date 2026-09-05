import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_text.dart';
import '../utils/app_colors.dart';

/// Opens an uploaded document (image or pdf) in a full screen in-app viewer.
void openDocumentPreview(BuildContext context, String url) {
  if (url.trim().isEmpty) return;
  final name = url.split('/').last.split('?').first.toLowerCase();

  if (name.endsWith('.pdf')) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PdfPreviewScreen(url: url)));
    return;
  }

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.95),
    builder: (_) => ImagePreviewDialog(url: url),
  );
}

Future<void> openDocumentExternally(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Full screen, pinch/double tap zoomable image viewer.
class ImagePreviewDialog extends StatefulWidget {
  final String url;
  const ImagePreviewDialog({super.key, required this.url});

  @override
  State<ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<ImagePreviewDialog>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late final AnimationController _animController;
  Animation<Matrix4>? _zoomAnimation;
  Offset _doubleTapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
      if (_zoomAnimation != null) _controller.value = _zoomAnimation!.value;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(Matrix4 target) {
    _zoomAnimation = Matrix4Tween(
      begin: _controller.value,
      end: target,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward(from: 0);
  }

  void _handleDoubleTap() {
    if (_controller.value.getMaxScaleOnAxis() > 1.05) {
      _animateTo(Matrix4.identity());
      return;
    }
    const scale = 2.5;
    final x = -_doubleTapPosition.dx * (scale - 1);
    final y = -_doubleTapPosition.dy * (scale - 1);
    _animateTo(
      Matrix4.identity()
        ..translate(x, y)
        ..scale(scale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Tap anywhere outside the image to close.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 1,
              maxScale: 5,
              clipBehavior: Clip.none,
              child: GestureDetector(
                onDoubleTapDown: (d) => _doubleTapPosition = d.localPosition,
                onDoubleTap: _handleDoubleTap,
                child: CachedNetworkImage(
                  imageUrl: widget.url,
                  fit: BoxFit.contain,
                  placeholder:
                      (_, __) => SizedBox(
                        height: 160.h,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                  errorWidget:
                      (_, __, ___) => PreviewErrorView(url: widget.url),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            right: 12.w,
            child: _CircleIconButton(
              icon: Icons.close,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Downloads the pdf to a temp file and renders it with a native pdf view
/// (pinch zoom + page swipe supported).
class PdfPreviewScreen extends StatefulWidget {
  final String url;
  const PdfPreviewScreen({super.key, required this.url});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  String? _filePath;
  bool _failed = false;
  int _pages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _download();
  }

  Future<void> _download() async {
    try {
      final dir = await getTemporaryDirectory();
      final name = widget.url.split('/').last.split('?').first;
      final file = File(
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_$name',
      );
      await Dio().download(widget.url, file.path);
      if (!mounted) return;
      setState(() => _filePath = file.path);
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _buildBody()),
            Positioned(
              top: 8.h,
              right: 12.w,
              child: _CircleIconButton(
                icon: Icons.close,
                onTap: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 8.h,
              left: 12.w,
              child: _CircleIconButton(
                icon: Icons.open_in_new,
                onTap: () => openDocumentExternally(widget.url),
              ),
            ),
            if (_pages > 1)
              Positioned(
                bottom: 16.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CustomText(
                      text: '${_currentPage + 1} / $_pages',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_failed) return Center(child: PreviewErrorView(url: widget.url));
    if (_filePath == null) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 2,
        ),
      );
    }
    return PDFView(
      filePath: _filePath,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      pageFling: false,
      fitPolicy: FitPolicy.BOTH,
      onRender: (pages) => setState(() => _pages = pages ?? 0),
      onPageChanged: (page, _) => setState(() => _currentPage = page ?? 0),
      onError: (_) => setState(() => _failed = true),
    );
  }
}

class PreviewErrorView extends StatelessWidget {
  final String url;
  const PreviewErrorView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: AppColors.secondaryTextColor,
            size: 34.r,
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: 'Preview not available for this file',
            fontsize: 13.sp,
            color: AppColors.secondaryTextColor,
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => openDocumentExternally(url),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.4),
                  width: 0.8,
                ),
              ),
              child: CustomText(
                text: 'Open in browser',
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.r),
      ),
    );
  }
}
