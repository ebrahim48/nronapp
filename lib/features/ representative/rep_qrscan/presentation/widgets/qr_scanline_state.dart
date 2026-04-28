import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';

class QrScanLine extends StatefulWidget {
  const QrScanLine({super.key});

  @override
  State<QrScanLine> createState() => _QrScanLineState();
}

class _QrScanLineState extends State<QrScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double frameHeight = 360.h;
    final double frameWidth = 300.w;

    return Positioned(
      top: 246.h,
      left: 47.w,
      child: SizedBox(
        width: frameWidth,
        height: frameHeight,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            final lineY = _animation.value * frameHeight;
            return Stack(
              children: [
                // Scan line
                Positioned(
                  top: lineY,
                  left: 0,
                  child: Container(
                    width: frameWidth,
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primaryColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Glow
                Positioned(
                  top: lineY,
                  left: 0,
                  child: Container(
                    width: frameWidth,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryColor.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}