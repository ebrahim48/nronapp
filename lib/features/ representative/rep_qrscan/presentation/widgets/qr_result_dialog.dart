import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../../../%20representative/rep_home/controller/scan_session_controller.dart';
import '../../../../%20representative/rep_home/presentation/widgets/po_scan_item_card.dart';
import '../controller/rep_qr_scan_controller.dart';

class QrResultPanel extends StatelessWidget {
  final String value;

  const QrResultPanel({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QrScanController>();

    final serial =
        'S/N: ${value.length > 24 ? '${value.substring(0, 24)}...' : value}';

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

            // Scanned product card — loading shimmer or real data
            Obx(() {
              if (c.isLoadingProduct.value) {
                return Container(
                  height: 108.h,
                  decoration: BoxDecoration(
                    color: const Color(0x1A4A4A4A),
                    borderRadius: BorderRadius.circular(8.r),
                    border:
                        Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF00C5DA), strokeWidth: 2),
                  ),
                );
              }
              return PoScannedItemCard(
                imagePath: 'assets/images/order.jpg',
                itemName: c.productName.value.isNotEmpty
                    ? c.productName.value
                    : value,
                serialNo: serial,
                price: c.productPrice.value.isNotEmpty
                    ? c.productPrice.value
                    : 'N/A',
              );
            }),

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
                  child: Obx(() {
                    final loading = c.isLoadingProduct.value;
                    final pid = c.productId.value;
                    final name = c.productName.value.isNotEmpty
                        ? c.productName.value
                        : value;
                    final price = c.productPrice.value.isNotEmpty
                        ? c.productPrice.value
                        : 'N/A';
                    return GestureDetector(
                      onTap: loading
                          ? null
                          : () {
                              if (Get.isRegistered<ScanSessionController>()) {
                                Get.find<ScanSessionController>().add(
                                  ScannedItem(
                                      productId: pid,
                                      name: name,
                                      price: price,
                                      serial: value),
                                );
                              }
                              context.pop();
                            },
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: loading
                              ? const Color(0xFF008fa0)
                              : const Color(0xFF00C5DA),
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
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
