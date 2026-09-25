import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/pdf_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_commission_controller.dart';
import '../model/manager_commission_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerCommissionController>();

    return Obx(() {
      final detail = c.commissionDetail.value;
      final isPaid = detail.paymentStatus == CommissionPaymentStatus.paid;

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
            text: 'Transaction Details',
            fontsize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            children: [
              // ── Amount card ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2121),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Column(
                  children: [
                    Text(
                      '\$${detail.totalCommissionDue.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 30.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1DB954)),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: const Color(0xFF1DB954), size: 14.r),
                          SizedBox(width: 4.w),
                          Text(
                            isPaid ? 'Paid' : 'Unpaid',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1DB954)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Divider(
                        height: 1,
                        color: const Color(0xFF3A3A3A),
                        thickness: 0.5),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DATE',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.secondaryTextColor,
                                    letterSpacing: 0.8)),
                            SizedBox(height: 2.h),
                            CustomText(
                                text: detail.date.isNotEmpty
                                    ? detail.date
                                    : '—',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('SALE ID',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.secondaryTextColor,
                                    letterSpacing: 0.8)),
                            SizedBox(height: 2.h),
                            CustomText(
                                text: detail.saleId.isNotEmpty
                                    ? detail.saleId
                                    : '—',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.warningColor,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // ── Sale details ────────────────────────────────────────
              _InfoSection(
                title: 'SALE DETAILS',
                rows: [
                  _InfoRow(
                      icon: Icons.person_outline,
                      label: 'Representative',
                      value: detail.repName.isNotEmpty
                          ? detail.repName
                          : '—'),
                  _InfoRow(
                      icon: Icons.business_outlined,
                      label: 'Facility',
                      value: detail.facility.isNotEmpty
                          ? detail.facility
                          : '—'),
                  _InfoRow(
                      icon: Icons.attach_money,
                      label: 'Sale Amount',
                      value: detail.saleAmount > 0
                          ? '\$${detail.saleAmount.toStringAsFixed(2)}'
                          : '—'),
                  _InfoRow(
                      icon: Icons.percent,
                      label: 'Commission Rate',
                      value: detail.rate > 0
                          ? '${detail.rate.toInt()}%'
                          : '—'),
                ],
              ),

              SizedBox(height: 24.h),

              // ── Download receipt ────────────────────────────────────
              GestureDetector(
                onTap: () => PdfHelper.shareCommissionReceiptPdf(detail),
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                        color: AppColors.primaryColor, width: 1.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_outlined,
                          color: AppColors.primaryColor, size: 18.r),
                      SizedBox(width: 8.w),
                      Text('Download Receipt',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      );
    });
  }
}

// ── Helper classes ────────────────────────────────────────────────────────────

class _InfoRow {
  final IconData? icon;
  final String label;
  final String value;
  const _InfoRow({this.icon, required this.label, required this.value});
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  const _InfoSection({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 9.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryTextColor,
                  letterSpacing: 0.8)),
          SizedBox(height: 12.h),
          ...rows.map((row) => Padding(
                padding:
                    EdgeInsets.only(bottom: row == rows.last ? 0 : 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (row.icon != null) ...[
                      Icon(row.icon!,
                          color: AppColors.secondaryTextColor, size: 16.r),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text: row.label,
                              fontsize: 10.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start),
                          SizedBox(height: 2.h),
                          CustomText(
                              text: row.value,
                              fontsize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
