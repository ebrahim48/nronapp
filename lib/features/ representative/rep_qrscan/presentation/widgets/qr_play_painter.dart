import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrOverlayPainter extends StatelessWidget {
  const QrOverlayPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _OverlayPainter(),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cutoutLeft = 47.w;
    final cutoutTop = 246.h;
    final cutoutWidth = 300.w;
    final cutoutHeight = 360.h;

    final paint = Paint()..color = Colors.black.withOpacity(0.55);

    // Top
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, cutoutTop), paint);
    // Bottom
    canvas.drawRect(
      Rect.fromLTWH(0, cutoutTop + cutoutHeight, size.width,
          size.height - cutoutTop - cutoutHeight),
      paint,
    );
    // Left
    canvas.drawRect(
        Rect.fromLTWH(0, cutoutTop, cutoutLeft, cutoutHeight), paint);
    // Right
    canvas.drawRect(
      Rect.fromLTWH(cutoutLeft + cutoutWidth, cutoutTop,
          size.width - cutoutLeft - cutoutWidth, cutoutHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}