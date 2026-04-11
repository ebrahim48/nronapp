import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_commission_model.dart';

class MonthlyCommissionTrendChart extends StatelessWidget {
  final List<TrendDataPoint> points;

  const MonthlyCommissionTrendChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 16.h),
          SizedBox(
            height: 140.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['100', '80', '60', '40', '20', '0']
                      .map((v) => CustomText(
                    text: v,
                    fontsize: 8.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.end,
                  ))
                      .toList(),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: CustomPaint(
                    painter: _TrendChartPainter(points: points),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 26.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: points
                  .map((p) => CustomText(
                text: p.month,
                fontsize: 9.sp,
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

class _TrendChartPainter extends CustomPainter {
  final List<TrendDataPoint> points;

  _TrendChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final gridPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    const maxVal = 100.0;
    final stepX = size.width / (points.length - 1);

    List<Offset> offsets = [];
    for (int i = 0; i < points.length; i++) {
      final x = stepX * i;
      final y = size.height - (points[i].value / maxVal) * size.height;
      offsets.add(Offset(x, y));
    }

    final fillPath = Path();
    fillPath.moveTo(offsets.first.dx, size.height);
    for (int i = 0; i < offsets.length - 1; i++) {
      final cp1 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i].dy);
      final cp2 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i + 1].dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
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

    final linePaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 0; i < offsets.length - 1; i++) {
      final cp1 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i].dy);
      final cp2 = Offset((offsets[i].dx + offsets[i + 1].dx) / 2, offsets[i + 1].dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i + 1].dx, offsets[i + 1].dy);
    }
    canvas.drawPath(linePath, linePaint);

    final dotFill = Paint()..color = AppColors.primaryColor..style = PaintingStyle.fill;
    final dotBg = Paint()..color = const Color(0xFF1B1B1B)..style = PaintingStyle.fill;
    for (final o in offsets) {
      canvas.drawCircle(o, 5, dotBg);
      canvas.drawCircle(o, 3.5, dotFill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}