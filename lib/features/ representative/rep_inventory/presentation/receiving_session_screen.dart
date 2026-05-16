import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_home/controller/scan_session_controller.dart';
import 'package:nron_app/features/%20representative/rep_home/presentation/widgets/po_scan_item_card.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/scan_item_button.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/receiving_session_controller.dart';

class ReceivingSessionScreen extends StatefulWidget {
  const ReceivingSessionScreen({super.key});

  @override
  State<ReceivingSessionScreen> createState() => _ReceivingSessionScreenState();
}

class _ReceivingSessionScreenState extends State<ReceivingSessionScreen> {
  final _meta = ReceivingSessionController();
  bool _isPaused = false;

  ScanSessionController get _session =>
      Get.isRegistered<ScanSessionController>()
          ? Get.find<ScanSessionController>()
          : Get.put(ScanSessionController());

  @override
  void dispose() {
    _meta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Receiving Session',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Obx(() {
        final hasItems = _session.items.isNotEmpty;
        return hasItems
            ? _activeSessionView(context)
            : _emptySessionView(context);
      }),
    );
  }

  // ── Active session (items exist) ─────────────────────────────────────────

  Widget _activeSessionView(BuildContext context) {
    final items = _session.items;
    final scannedCount = items.length;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session meta card
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.qr_code_scanner,
                              color: AppColors.primaryColor, size: 22.r),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: _meta.supplierName,
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                            CustomText(
                              text: 'Started: ${_meta.sessionStartTime}',
                              fontsize: 11.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    CustomText(
                      text: 'Scanned Items',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: '$scannedCount Items',
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h),
                    // Simple scan count bar (each scan = 1 step, max shown 10)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: (scannedCount / 10).clamp(0.0, 1.0),
                        backgroundColor: const Color(0xFF3A3A3A),
                        color: AppColors.primaryColor,
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Scan Item button — scan more
              ScanItemButton(onTap: () => context.push(AppRoutes.qrScanScreen)),

              SizedBox(height: 20.h),

              // Scanned items header
              Row(
                children: [
                  Icon(Icons.history,
                      color: AppColors.secondaryTextColor, size: 16.r),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: 'Scanned Items',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CustomText(
                      text: '$scannedCount scanned',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Scanned item cards
              ...items.asMap().entries.map((e) {
                final item = e.value;
                final serial = item.serial.length > 24
                    ? 'S/N: ${item.serial.substring(0, 24)}...'
                    : 'S/N: ${item.serial}';
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Stack(
                    children: [
                      PoScannedItemCard(
                        imagePath: 'assets/images/order.jpg',
                        itemName: item.name,
                        serialNo: serial,
                        price: item.price,
                      ),
                      // Remove button
                      Positioned(
                        top: 6.h,
                        right: 6.w,
                        child: GestureDetector(
                          onTap: () => _session.remove(e.key),
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF3A3A3A)),
                            ),
                            child: Icon(Icons.close,
                                color: AppColors.secondaryTextColor,
                                size: 12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        // Sticky bottom buttons
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: AppColors.backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: _isPaused ? 'Resume' : 'Pause Session',
                    color: const Color(0xFF252525),
                    borderColor: AppColors.dotButtonInactiveColor,
                    prefixIcon: Icon(
                      _isPaused
                          ? Icons.play_arrow_outlined
                          : Icons.pause_circle_outline,
                      color: AppColors.primaryTextColor,
                      size: 18.r,
                    ),
                    onpress: () => setState(() => _isPaused = !_isPaused),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    title: 'Complete',
                    suffixIcon: Icon(Icons.check_circle_outline,
                        color: AppColors.primaryTextColor, size: 18.r),
                    onpress: () => context.pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Empty session (no items yet) ─────────────────────────────────────────

  Widget _emptySessionView(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatCard(label: 'Total Item', value: '00'),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(label: 'Missing', value: '00'),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _StatCard(
              label: 'Low Stock Alert', value: '00', fullWidth: true),
          SizedBox(height: 16.h),

          // Scan Item button
          ScanItemButton(
              onTap: () => context.push(AppRoutes.qrScanScreen)),
          SizedBox(height: 20.h),

          // Placeholder
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: CustomText(
              text: 'RECEIVED GROUPS',
              fontsize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 60.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.qr_code_scanner_outlined,
                    color: AppColors.secondaryTextColor, size: 48.r),
                SizedBox(height: 12.h),
                CustomText(
                  text: 'No items scanned yet',
                  fontsize: 14.sp,
                  color: AppColors.secondaryTextColor,
                ),
                SizedBox(height: 6.h),
                CustomText(
                  text: 'Tap "Scan Item" to start scanning',
                  fontsize: 12.sp,
                  color: AppColors.secondaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool fullWidth;

  const _StatCard(
      {required this.label, required this.value, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined,
              color: AppColors.primaryColor, size: 22.r),
          SizedBox(height: 6.h),
          CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ],
      ),
    );
  }
}
