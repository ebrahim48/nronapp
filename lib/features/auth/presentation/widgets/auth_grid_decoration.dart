import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthGridDecoration extends StatelessWidget {
  const AuthGridDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 160.h,
      child: CustomPaint(painter: _GridPainter()),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3A5F).withValues(alpha: 0.5)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    const cols = 4;
    const rows = 5;
    final cellW = size.width / cols;
    final cellH = size.height / rows;
    for (int r = 0; r <= rows; r++) {
      canvas.drawLine(Offset(0, r * cellH), Offset(size.width, r * cellH), paint);
    }
    for (int c = 0; c <= cols; c++) {
      canvas.drawLine(Offset(c * cellW, 0), Offset(c * cellW, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter o) => false;
}
