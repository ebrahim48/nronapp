import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/commission_model.dart';

class CommissionTrendChart extends StatelessWidget {
  final List<TrendPoint> points;

  const CommissionTrendChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart,
                  color: AppColors.primaryTextColor, size: 18.r),
              SizedBox(width: 6.w),
              CustomText(
                text: '6-Month Trend',
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 150.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Y-axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['100', '80', '60', '40', '20', '0']
                      .map((v) => CustomText(
                    text: v,
                    fontsize: 9.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.end,
                  ))
                      .toList(),
                ),
                SizedBox(width: 8.w),
                // Chart area
                Expanded(
                  child: CustomPaint(
                    painter: _TrendPainter(points: points),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // X-axis labels
          Padding(
            padding: EdgeInsets.only(left: 28.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: points
                  .map((p) => CustomText(
                text: p.month,
                fontsize: 10.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.center,
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<TrendPoint> points;

  _TrendPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 0.5;

    const gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final maxVal = 100.0;
    final stepX = size.width / (points.length - 1);

    List<Offset> offsets = [];
    for (int i = 0; i < points.length; i++) {
      final x = stepX * i;
      final y = size.height - (points[i].value / maxVal) * size.height;
      offsets.add(Offset(x, y));
    }

    // Filled area under curve
    final fillPath = Path();
    fillPath.moveTo(offsets.first.dx, size.height);
    for (int i = 0; i < offsets.length - 1; i++) {
      final cp1 = Offset(
          (offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i].dy);
      final cp2 = Offset(
          (offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i + 1].dy);
      fillPath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
    }
    fillPath.lineTo(offsets.last.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryColor.withValues(alpha: 0.3),
          AppColors.primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 0; i < offsets.length - 1; i++) {
      final cp1 = Offset(
          (offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i].dy);
      final cp2 = Offset(
          (offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i + 1].dy);
      linePath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Dots
    final dotPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = const Color(0xFF1B1B1B)
      ..style = PaintingStyle.fill;

    for (final o in offsets) {
      canvas.drawCircle(o, 5, dotBorderPaint);
      canvas.drawCircle(o, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}