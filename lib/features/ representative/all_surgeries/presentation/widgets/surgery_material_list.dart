import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/surgery_model.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class SurgeryMaterialsList extends StatelessWidget {
  final List<SurgeryMaterialGroup> materials;

  const SurgeryMaterialsList({super.key, required this.materials});

  Color _categoryColor(String cat) {
    switch (cat.toUpperCase()) {
      case 'SCREWS':
        return AppColors.primaryColor;
      case 'RODS/CONNECTORS':
        return const Color(0xFF8A6EFF);
      case 'PLATES':
        return AppColors.warningColor;
      case 'IMPLANTS':
        return const Color(0xFF1DB954);
      case 'BIOLOGICS':
        return AppColors.redColorFF1D1D;
      default:
        return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: materials.asMap().entries.map((e) {
          final isLast = e.key == materials.length - 1;
          final catColor = _categoryColor(e.value.category);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        e.value.category,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: catColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Detail with bold QTY
                    _BoldQtyText(detail: e.value.detail),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                    height: 1,
                    color: const Color(0xFF3A3A3A),
                    thickness: 0.5),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BoldQtyText extends StatelessWidget {
  final String detail;
  const _BoldQtyText({required this.detail});

  @override
  Widget build(BuildContext context) {
    // Bold the QTY part
    final qtyIndex = detail.indexOf('QTY');
    if (qtyIndex == -1) {
      return CustomText(
        text: detail,
        fontsize: 13.sp,
        color: AppColors.primaryTextColor,
        textAlign: TextAlign.start,
      );
    }

    final before = detail.substring(0, qtyIndex);
    final qty = detail.substring(qtyIndex);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: before,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              color: AppColors.primaryTextColor,
            ),
          ),
          TextSpan(
            text: qty,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}