import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../%20representative/rep_home/presentation/widgets/po_scan_item_card.dart';
import '../controller/rep_qr_scan_controller.dart';

class QrResultPanel extends StatelessWidget {
  final String value;

  const QrResultPanel({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QrScanController>();

    // Truncate serial if too long
    final serial = 'S/N: ${value.length > 24 ? '${value.substring(0, 24)}...' : value}';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 36.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            SizedBox(height: 16.h),

            // Success header
            Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C5DA).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: const Color(0xFF00C5DA),
                    size: 18.r,
                  ),
                ),
                SizedBox(width: 10.w),
                CustomText(
                  text: 'Scan Successful',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Scanned product card
            PoScannedItemCard(
              imagePath: 'assets/images/order.jpg',
              itemName: 'Titanium Bone Screw',
              serialNo: serial,
              price: '\$850.00',
            ),

            SizedBox(height: 16.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: c.resetScan,
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFF3A3A3A),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Scan Again',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C5DA),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Add to PO',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E2121),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
