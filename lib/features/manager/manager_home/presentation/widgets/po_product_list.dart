import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_po_model.dart';

class POProductList extends StatelessWidget {
  final List<POProductItem> products;

  const POProductList({super.key, required this.products});

  double get subtotal =>
      products.fold(0, (sum, p) => sum + p.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 14.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PRODUCT LIST',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryTextColor,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  '${products.length} Items',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(
              height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),

          // Items
          ...products.map((p) => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 12.h),
                child: Row(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.inventory_2_outlined,
                          color: AppColors.primaryColor,
                          size: 18.r),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: p.name,
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            text: p.spec,
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      text: '\$${p.price.toStringAsFixed(2)}',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Divider(
                  height: 1,
                  color: const Color(0xFF3A3A3A),
                  thickness: 0.5),
            ],
          )),

          // Subtotal
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 14.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SUBTOTAL',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryTextColor,
                    letterSpacing: 0.8,
                  ),
                ),
                CustomText(
                  text: '\$${subtotal.toStringAsFixed(2)}',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}