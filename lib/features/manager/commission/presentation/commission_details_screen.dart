import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/calculated_commission_card.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/close_bills_table.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/commission_rep_card.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/commission_transaction_card.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/mark_paid_button.dart';
import 'package:nron_app/features/manager/commission/presentation/widgets/split_commission_section.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_commission_controller.dart';
import '../model/manager_commission_model.dart';

class ManagerCommissionDetailScreen extends StatelessWidget {
  const ManagerCommissionDetailScreen({super.key});

  void _showViewTransactionPopup(BuildContext context) {
    final c = Get.find<ManagerCommissionController>();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1E2427),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9999.r),
                  border: Border.all(
                      color: const Color(0xFF34D399)
                          .withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        color: const Color(0xFF34D399), size: 16.r),
                    SizedBox(width: 8.w),
                    Text('Paid',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF34D399))),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Payment processed successfully and synced with QuickBooks',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    height: 1.5),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.transactionDetailScreen);
                },
                child: Container(
                  width: 200.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC5B13),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Text('View Transaction',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerCommissionController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Commission Details',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        // ── Shimmer ──────────────────────────────────────────────────
        if (c.isLoadingDetail.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 14.h),
              child: Column(
                children: [
                  Container(height: 80.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                  SizedBox(height: 16.h),
                  Container(height: 120.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                  SizedBox(height: 16.h),
                  Container(height: 160.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                ],
              ),
            ),
          );
        }

        final d = c.commissionDetail.value;

        return SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Rep card ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Representative',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  if (d.paymentStatus == CommissionPaymentStatus.unpaid)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.warningColor
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: AppColors.warningColor
                                .withValues(alpha: 0.4)),
                      ),
                      child: Text('PENDING',
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppColors.warningColor)),
                    ),
                ],
              ),
              SizedBox(height: 10.h),

              CommissionRepCard(
                name: d.repName,
                role: d.repRole,
                avatarUrl: d.repAvatarUrl,
              ),

              SizedBox(height: 20.h),

              CustomText(
                text: 'Transaction Details',
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10.h),

              CommissionTransactionCard(
                totalCommissionDue: d.totalCommissionDue,
                saleAmount: d.saleAmount,
                rate: d.rate,
                date: d.date,
                status: d.paymentStatus,
              ),

              SizedBox(height: 20.h),

              CustomText(
                text: 'Sale Details',
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10.h),

              _DetailTable(rows: [
                _DetailRow('Sale ID', d.saleId,
                    valueColor: AppColors.warningColor),
                _DetailRow('Facility',
                    d.facility.isNotEmpty ? d.facility : '—'),
                if (d.territory.isNotEmpty)
                  _DetailRow('Territory', d.territory, bold: true),
                _DetailRow('Sale Amount',
                    '\$${d.saleAmount.toStringAsFixed(2)}'),
                _DetailRow('Commission Rate',
                    '${d.rate.toInt()}%',
                    valueColor: AppColors.warningColor,
                    badge: true),
              ]),

              if (d.bills.isNotEmpty) ...[
                SizedBox(height: 10.h),
                CloseBillsTable(bills: d.bills),
              ],

              SizedBox(height: 16.h),


              if (d.splits.isNotEmpty)
                SplitCommissionSection(
                  splits: d.splits,
                  totalCommissionPool: d.totalCommissionPool,
                  showProgressBar: false,
                ),

              SizedBox(height: 24.h),

              GestureDetector(
                onTap: () => _showViewTransactionPopup(context),
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14B8A6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check,
                          color: AppColors.primaryTextColor,
                          size: 20.r),
                      SizedBox(width: 8.w),
                      Text('Approve Commission',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              MarkPaidButton(
                  onTap: () => c.markPaid(context)),

              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  final bool badge;

  const _DetailRow(this.label, this.value,
      {this.valueColor, this.bold = false, this.badge = false});
}

class _DetailTable extends StatelessWidget {
  final List<_DetailRow> rows;
  const _DetailTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        text: e.value.label,
                        fontsize: 13.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start),
                    if (e.value.badge)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.warningColor
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(e.value.value,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: AppColors.warningColor)),
                      )
                    else
                      CustomText(
                        text: e.value.value,
                        fontsize: 13.sp,
                        fontWeight: e.value.bold
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: e.value.valueColor ??
                            AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
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
