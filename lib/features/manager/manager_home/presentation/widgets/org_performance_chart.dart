import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../manager_controller/manager_home_controller.dart';

class OrgPerformanceChart extends StatelessWidget {
  const OrgPerformanceChart({super.key});

  static const _salesColor = Color(0xFF4722FF);
  static const _expensesColor = Color(0xFFEC0101);
  static const _commissionColor = Color(0xFF08AF40);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerHomeController>();

    return Obx(() {
      final months = c.chartData.keys.toList();
      final data = c.chartData;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Organization Performance',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                // Period dropdown
                GestureDetector(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          300.w, 120.h, 16.w, 0),
                      color: const Color(0xFF1E2121),
                      items: c.periods
                          .map((p) => PopupMenuItem(
                        value: p,
                        child: Text(
                          p,
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ))
                          .toList(),
                    ).then((val) {
                      if (val != null) c.changePeriod(val);
                    });
                  },
                  child: Row(
                    children: [
                      CustomText(
                        text: c.selectedPeriod.value,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.keyboard_arrow_down,
                          color: AppColors.primaryTextColor, size: 16.r),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Legend
            Row(
              children: [
                _LegendRect(color: _salesColor, label: 'Sales'),
                SizedBox(width: 16.w),
                _LegendRect(color: _expensesColor, label: 'Expenses'),
                SizedBox(width: 16.w),
                _LegendRect(
                    color: _commissionColor, label: 'Commission'),
              ],
            ),

            SizedBox(height: 14.h),

            SizedBox(
              height: 200.h,
              child: Stack(
                children: [
                  BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 110,
                      minY: 0,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36.w,
                            interval: 20,
                            getTitlesWidget: (value, meta) {
                              if (value == 0)
                                return const SizedBox();
                              return Text(
                                '${value.toInt()}L',
                                style: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontSize: 9.sp,
                                  fontFamily: 'Poppins',
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22.h,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= months.length)
                                return const SizedBox();
                              return Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  months[idx],
                                  style: TextStyle(
                                    color: AppColors.secondaryTextColor,
                                    fontSize: 10.sp,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xFF3A3A3A),
                          strokeWidth: 0.5,
                          dashArray: [4, 4],
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups:
                      List.generate(months.length, (i) {
                        final vals = data[months[i]]!;
                        return BarChartGroupData(
                          x: i,
                          barsSpace: 3.w,
                          barRods: [
                            BarChartRodData(
                              toY: vals[0],
                              color: _salesColor,
                              width: 8.w,
                              borderRadius:
                              BorderRadius.circular(2.r),
                              backDrawRodData:
                              BackgroundBarChartRodData(
                                show: true,
                                toY: 110,
                                color: _salesColor
                                    .withValues(alpha: 0.08),
                              ),
                            ),
                            BarChartRodData(
                              toY: vals[1],
                              color: _expensesColor,
                              width: 8.w,
                              borderRadius:
                              BorderRadius.circular(2.r),
                            ),
                            BarChartRodData(
                              toY: vals[2],
                              color: _commissionColor,
                              width: 8.w,
                              borderRadius:
                              BorderRadius.circular(2.r),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  // Top dashed line
                  Positioned(
                    top: 3.h,
                    left: 30.34.w,
                    child: SizedBox(
                      width: 314.66.w,
                      child: CustomPaint(
                        painter: _DashedLinePainter(),
                        size: Size(314.66.w, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendRect extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRect({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 4.w),
        CustomText(
          text: label,
          fontsize: 10.sp,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}