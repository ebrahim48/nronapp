import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../rep_inventory/controller/receiving_session_controller.dart';
import '../../rep_inventory/model/implant_model.dart';


class ReceivingSessionScreen extends StatefulWidget {
  const ReceivingSessionScreen({super.key});

  @override
  State<ReceivingSessionScreen> createState() =>
      _ReceivingSessionScreenState();
}

class _ReceivingSessionScreenState
    extends State<ReceivingSessionScreen> {
  final _ctrl = ReceivingSessionController();

  @override
  void dispose() {
    _ctrl.dispose();
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
          onTap: () => context.canPop() ? context.pop() : context.go('/purchaseOrderScreen'),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Receiving Session',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SingleChildScrollView(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total Item',
                        value: _ctrl.totalItem
                            .toString()
                            .padLeft(2, '0'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _StatCard(
                        label: 'Missing',
                        value: _ctrl.missing
                            .toString()
                            .padLeft(2, '0'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Low Stock Alert (full width)
                _StatCard(
                  label: 'Low Stock Alart',
                  value: _ctrl.lowStockAlert
                      .toString()
                      .padLeft(2, '0'),
                  fullWidth: true,
                ),
                SizedBox(height: 16.h),


                _ScanItemButton(onTap: _ctrl.scanItem),
                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'last Reeving Group',
                      fontsize: 13.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: 'Feb,2025',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.calendar_month_outlined,
                            color: AppColors.primaryColor, size: 16.r),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                ..._ctrl.boxes.asMap().entries.map(
                      (e) => _ReceivingBoxCard(
                    box: e.value,
                    onToggle: () => _ctrl.toggleBox(e.key),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

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
            fontsize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ],
      ),
    );
  }
}


class _ScanItemButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ScanItemButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 64.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner,
                    color: AppColors.primaryTextColor, size: 24.r),
                SizedBox(height: 4.h),
                CustomText(
                  text: 'Scan Item',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () {},
          child: CustomText(
            text: 'Connect USB Scanner',
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTextColor,
            textDecoration: TextDecoration.underline,
          ),
        ),
        SizedBox(height: 2.h),
        CustomText(
          text: 'Or Enter serial Number Manually',
          fontsize: 11.sp,
          color: AppColors.secondaryTextColor,
        ),
      ],
    );
  }
}


class _ReceivingBoxCard extends StatelessWidget {
  final ReceivingBoxModel box;
  final VoidCallback onToggle;

  const _ReceivingBoxCard({
    required this.box,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: box.boxCode,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: box.description,
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text:
                    '${box.itemCount.toString().padLeft(2, '0')} ITEMS',
                    fontsize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          // Toggle bar
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: !box.isExpanded
                    ? BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                )
                    : BorderRadius.zero,
              ),
              child: Icon(
                box.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.secondaryTextColor,
                size: 20.r,
              ),
            ),
          ),

          // Serial rows
          if (box.isExpanded)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                children: box.serialRanges
                    .map(
                      (sr) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Icon(Icons.drag_indicator,
                            color: AppColors.secondaryTextColor,
                            size: 14.r),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: sr,
                          fontsize: 12.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}