import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class MonthlyCommissionTrendChart extends StatelessWidget {
  final List<TrendDataPoint> points;

  const MonthlyCommissionTrendChart({super.key, required this.points});

  /// Compute a "nice" ceiling for the Y-axis.
  /// e.g. maxData=1266 → niceMax=1400, step=200, labels=[0,200,400,600,800,1000,1200,1400]
  static ({double niceMax, double step, List<String> labels}) _yAxis(
      List<TrendDataPoint> pts) {
    if (pts.isEmpty) {
      return (
        niceMax: 100,
        step: 20,
        labels: ['100', '80', '60', '40', '20', '0'],
      );
    }

    final maxData = pts.map((p) => p.value).reduce(max);

    // Choose a nice step size
    double rawStep = maxData / 5;
    final magnitude = pow(10, (log(rawStep) / ln10).floor()).toDouble();
    final normalised = rawStep / magnitude;
    double niceStep;
    if (normalised <= 1) {
      niceStep = magnitude;
    } else if (normalised <= 2) {
      niceStep = 2 * magnitude;
    } else if (normalised <= 5) {
      niceStep = 5 * magnitude;
    } else {
      niceStep = 10 * magnitude;
    }

    // Add one extra step above max so the spike never touches the top edge
    final niceMax = (maxData / niceStep).ceil() * niceStep + niceStep;

    final labels = <String>[];
    for (double v = niceMax; v >= 0; v -= niceStep) {
      labels.add(_formatLabel(v));
    }

    return (niceMax: niceMax, step: niceStep, labels: labels);
  }

  static String _formatLabel(double v) {
    if (v >= 1000) {
      final k = v / 1000;
      return k == k.truncateToDouble() ? '${k.toInt()}k' : '${k.toStringAsFixed(1)}k';
    }
    return v.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final axis = _yAxis(points);

    return Container(
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.show_chart,
                  color: AppColors.primaryTextColor, size: 16.r),
              SizedBox(width: 6.w),
              CustomText(
                text: 'Monthly Commission Trend',
                fontsize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // ── Chart area ──────────────────────────────────────────────────
          SizedBox(
            height: 160.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Y-axis labels
                _YAxisLabels(labels: axis.labels),
                SizedBox(width: 6.w),
                // Chart canvas
                Expanded(
                  child: CustomPaint(
                    painter: _TrendChartPainter(
                      points: points,
                      niceMax: axis.niceMax,
                      labelCount: axis.labels.length,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // ── X-axis labels ────────────────────────────────────────────────
          if (points.isNotEmpty)
            _XAxisLabels(points: points),
        ],
      ),
    );
  }
}

// ── Y-axis label column ────────────────────────────────────────────────────────

class _YAxisLabels extends StatelessWidget {
  final List<String> labels;
  const _YAxisLabels({required this.labels});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: labels
          .map((v) => SizedBox(
                width: 32.w,
                child: CustomText(
                  text: v,
                  fontsize: 8.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.end,
                ),
              ))
          .toList(),
    );
  }
}

// ── X-axis label row ───────────────────────────────────────────────────────────

class _XAxisLabels extends StatelessWidget {
  final List<TrendDataPoint> points;
  const _XAxisLabels({required this.points});

  @override
  Widget build(BuildContext context) {
    // Left-pad to align with the chart canvas (matches Y-label width + gap)
    return Padding(
      padding: EdgeInsets.only(left: 38.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: points
            .map((p) => Expanded(
                  child: CustomText(
                    text: p.month,
                    fontsize: 9.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.center,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ── Chart painter ──────────────────────────────────────────────────────────────

class _TrendChartPainter extends CustomPainter {
  final List<TrendDataPoint> points;
  final double niceMax;
  final int labelCount;

  _TrendChartPainter({
    required this.points,
    required this.niceMax,
    required this.labelCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // ── Grid lines (one per label interval) ─────────────────────────────
    final gridPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 0.5;

    final gridCount = labelCount - 1; // number of intervals
    for (int i = 0; i <= gridCount; i++) {
      final y = size.height * i / gridCount;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // ── Map data → canvas coordinates ───────────────────────────────────
    final stepX = points.length > 1
        ? size.width / (points.length - 1)
        : size.width / 2;

    List<Offset> offsets = [];
    for (int i = 0; i < points.length; i++) {
      final x = points.length > 1 ? stepX * i : size.width / 2;
      // Clamp to [0, size.height] so nothing overflows
      final rawY = size.height - (points[i].value / niceMax) * size.height;
      final y = rawY.clamp(0.0, size.height);
      offsets.add(Offset(x, y));
    }

    // ── Gradient fill ────────────────────────────────────────────────────
    final fillPath = Path();
    fillPath.moveTo(offsets.first.dx, size.height);
    _addCurve(fillPath, offsets);
    fillPath.lineTo(offsets.last.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryColor.withValues(alpha: 0.35),
          AppColors.primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // ── Line ─────────────────────────────────────────────────────────────
    final linePaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(offsets.first.dx, offsets.first.dy);
    _addCurve(linePath, offsets);
    canvas.drawPath(linePath, linePaint);

    // ── Dots ─────────────────────────────────────────────────────────────
    final dotFill = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;
    final dotBg = Paint()
      ..color = const Color(0xFF1E2121)
      ..style = PaintingStyle.fill;

    for (final o in offsets) {
      canvas.drawCircle(o, 5, dotBg);
      canvas.drawCircle(o, 3.5, dotFill);
    }
  }

  void _addCurve(Path path, List<Offset> offsets) {
    for (int i = 0; i < offsets.length - 1; i++) {
      final midX = (offsets[i].dx + offsets[i + 1].dx) / 2;
      final cp1 = Offset(midX, offsets[i].dy);
      final cp2 = Offset(midX, offsets[i + 1].dy);
      path.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter old) =>
      old.points != points || old.niceMax != niceMax;
}
