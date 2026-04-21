import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_button.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class CardAddedSuccessDialog extends StatelessWidget {
  final VoidCallback onGoToWallet;

  const CardAddedSuccessDialog({
    super.key,
    required this.onGoToWallet,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.all(28.r),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(72.r, 72.r),
                  painter: _BadgePainter(),
                ),
                Icon(
                  Icons.check,
                  color: AppColors.primaryColor,
                  size: 32.r,
                ),
              ],
            ),
            SizedBox(height: 22.h),
            CustomText(
              text: 'Card added successfully',
              fontsize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'Great! Your payment method is ready to use.',
              fontsize: 12.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
              textHeight: 1.5,
            ),
            SizedBox(height: 24.h),
            CustomButton(
              title: 'Go to wallet',
              onpress: onGoToWallet,
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..style = PaintingStyle.fill;

    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR * 0.78;
    const points = 8;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * 3.14159265 / points) - 3.14159265 / 2;
      final r = i.isEven ? outerR : innerR;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double angle) => _cos(angle);
  double sin(double angle) => _sin(angle);

  double _cos(double x) {
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double _sin(double x) {
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}