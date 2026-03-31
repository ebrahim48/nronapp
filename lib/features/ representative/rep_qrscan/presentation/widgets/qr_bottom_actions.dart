import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

class QrBottomActions extends StatelessWidget {
  final VoidCallback onHistory;
  final VoidCallback onHelp;

  const QrBottomActions({
    super.key,
    required this.onHistory,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 676.h,
      left: 24.w,
      child: SizedBox(
        width: 345.w,
        height: 80.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // History
            _ActionButton(icon: Icons.history, onTap: onHistory),

            // Shutter
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 3,
                ),
              ),
              child: Center(
                child: Container(
                  width: 54.w,
                  height: 54.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),

            // Help
            _ActionButton(icon: Icons.help_outline, onTap: onHelp),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: AppColors.secondaryTextColor,
          size: 22.r,
        ),
      ),
    );
  }
}