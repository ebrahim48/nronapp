import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../model/driver_map_model.dart';

class DeliveryProgressTracker extends StatelessWidget {
  final DeliveryProgressStatus currentStatus;

  const DeliveryProgressTracker({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _ProgressStep(
        label: 'Accepted',
        icon: Icons.check,
        status: DeliveryProgressStatus.accepted,
      ),
      _ProgressStep(
        label: 'Picked\nUp',
        icon: Icons.check,
        status: DeliveryProgressStatus.pickedUp,
      ),
      _ProgressStep(
        label: 'In\nTransit',
        icon: Icons.arrow_forward,
        status: DeliveryProgressStatus.inTransit,
      ),
      _ProgressStep(
        label: 'Delivered',
        icon: Icons.check,
        status: DeliveryProgressStatus.delivered,
      ),
    ];

    final currentIndex = DeliveryProgressStatus.values.indexOf(currentStatus);

    return Row(
      children: steps.asMap().entries.map((e) {
        final stepIndex = e.key;
        final step = e.value;
        final isDone = stepIndex < currentIndex;
        final isCurrent = stepIndex == currentIndex;
        final isLast = stepIndex == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: isDone || isCurrent
                            ? AppColors.primaryColor
                            : const Color(0xFF3A3A3A),
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(
                            color: AppColors.primaryColor
                                .withValues(alpha: 0.4),
                            width: 3)
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          step.icon,
                          color: isDone || isCurrent
                              ? AppColors.blackColor
                              : AppColors.secondaryTextColor,
                          size: 16.r,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      step.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: 'Poppins',
                        fontWeight: isCurrent
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isDone || isCurrent
                            ? AppColors.primaryColor
                            : AppColors.secondaryTextColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: stepIndex < currentIndex
                        ? AppColors.primaryColor
                        : const Color(0xFF3A3A3A),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ProgressStep {
  final String label;
  final IconData icon;
  final DeliveryProgressStatus status;

  const _ProgressStep({
    required this.label,
    required this.icon,
    required this.status,
  });
}