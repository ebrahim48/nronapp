import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/receiving_box_card.dart';
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
  final _ctrl = ReceivingSessionController();
  bool get _hasScans => _ctrl.scanned > 0;

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
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          if (!_ctrl.isSessionActive) {
            // Use post-frame to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.goNamed(AppRoutes.receivingSessionCompleteScreen);
              }
            });
          }

          return _hasScans
              ? _activeSessionView(context)
              : _emptySessionView(context);
        },
      ),
    );
  }



  Widget _activeSessionView(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Supplier card
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
                            color: const Color(0xFF3A3A3A),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.settings,
                              color: AppColors.secondaryTextColor, size: 22.r),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: _ctrl.supplierName,
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                            CustomText(
                              text: 'Started: ${_ctrl.sessionStartTime}',
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
                      text: 'Expected Total',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      text: '${_ctrl.expectedTotal} Items',
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Receiving Progress',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(
                          text:
                          '${_ctrl.scanned}/${_ctrl.expectedTotal}',
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: _ctrl.progress,
                        backgroundColor: const Color(0xFF3A3A3A),
                        color: AppColors.primaryColor,
                        minHeight: 6.h,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: '${_ctrl.progressPercent} Complete',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(
                          text: '${_ctrl.remaining} Remaining',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Scan Item button
              ScanItemButton(onTap: () => context.push(AppRoutes.qrScanScreen)),
              SizedBox(height: 20.h),

              // Recent Scans header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history,
                          color: AppColors.secondaryTextColor, size: 16.r),
                      SizedBox(width: 6.w),
                      CustomText(
                        text: 'Recent Scans',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  CustomText(
                    text: 'Latest -3',
                    fontsize: 12.sp,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Recent boxes
              ..._ctrl.recentScans.asMap().entries.map((e) {
                return ReceivingBoxCard(
                  box: e.value,
                  onToggle: () => _ctrl.toggleBox(e.key),
                );
              }),

              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () {

                },
                child: Center(
                  child: CustomText(
                    text: 'View All Receive Items',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Sticky bottom buttons: Pause | Complete
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: AppColors.backgroundColor,
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: _ctrl.isPaused ? 'Resume' : 'Pause Session',
                    color: const Color(0xFF252525),
                    borderColor: AppColors.dotButtonInactiveColor,
                    prefixIcon: Icon(
                      _ctrl.isPaused
                          ? Icons.play_arrow_outlined
                          : Icons.pause_circle_outline,
                      color: AppColors.primaryTextColor,
                      size: 18.r,
                    ),
                    onpress: _ctrl.pauseSession,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    title: 'Complete',
                    suffixIcon: Icon(Icons.check_circle_outline,
                        color: AppColors.primaryTextColor, size: 18.r),
                    onpress: _ctrl.completeSession,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


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
                child: _StatCard(
                  label: 'Total Item',
                  value: _ctrl.totalItem.toString().padLeft(2, '0'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  label: 'Missing',
                  value: _ctrl.missing.toString().padLeft(2, '0'),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _StatCard(
            label: 'Low Stock Alart',
            value: _ctrl.lowStockAlert.toString().padLeft(2, '0'),
            fullWidth: true,
          ),
          SizedBox(height: 16.h),

          // Scan Item button
          ScanItemButton(onTap: () => context.push(AppRoutes.qrScanScreen)),
          SizedBox(height: 20.h),

          // Received Groups / Last group header
          if (_ctrl.boxes.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: CustomText(
                text: 'RECEIVED GROUPS',
                fontsize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            )
          else ...[
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
            ..._ctrl.boxes.asMap().entries.map((e) {
              return ReceivingBoxCard(
                box: e.value,
                onToggle: () => _ctrl.toggleBox(e.key),
              );
            }),
          ],
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


