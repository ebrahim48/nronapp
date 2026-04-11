import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_commission_controller.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerCommissionController>();
    final d = c.transactionDetail;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: AppColors.primaryTextColor, size: 18.r),
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
            // Amount card
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
                    '\$${d.amount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 30.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: const Color(0xFF1DB954)),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, color: const Color(0xFF1DB954), size: 14.r),
                        SizedBox(width: 4.w),
                        Text('Paid', style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: const Color(0xFF1DB954))),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Divider(height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DATE', style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', color: AppColors.secondaryTextColor, letterSpacing: 0.8)),
                          SizedBox(height: 2.h),
                          CustomText(text: d.date, fontsize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('TRANSACTION ID', style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', color: AppColors.secondaryTextColor, letterSpacing: 0.8)),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              CustomText(text: d.transactionId, fontsize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                              SizedBox(width: 4.w),
                              Icon(Icons.copy_outlined, color: AppColors.warningColor, size: 14.r),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // QuickBooks sync card
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34.r, height: 34.r,
                        decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
                        child: Icon(Icons.sync, color: AppColors.primaryColor, size: 18.r),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: 'QuickBooks Online', fontsize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                          CustomText(text: 'Synced successfully', fontsize: 11.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: const Color(0xFF3A3A3A), height: 16.h, thickness: 0.5),
                  _LinkRow(label: 'Invoice Link', value: d.invoiceLink),
                  SizedBox(height: 8.h),
                  _LinkRow(label: 'Expense Link', value: d.expenseLink),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Payment Information
            _InfoSection(
              title: 'PAYMENT INFORMATION',
              rows: [
                _InfoRow(icon: Icons.credit_card_outlined, label: 'Method', value: d.paymentMethod),
                _InfoRow(icon: Icons.schedule_outlined, label: 'Payout Schedule', value: d.payoutSchedule),
              ],
            ),

            SizedBox(height: 12.h),

            // Related Sale Details
            _InfoSection(
              title: 'RELATED SALE DETAILS',
              rows: [
                _InfoRow(label: 'Sale ID', value: d.relatedSaleId),
                _InfoRow(label: 'Surgeon', value: d.surgeon),
                _InfoRow(label: 'Facility', value: d.facility),
              ],
            ),

            SizedBox(height: 24.h),

            // Download Receipt
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: AppColors.primaryColor, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download_outlined, color: AppColors.primaryColor, size: 18.r),
                    SizedBox(width: 8.w),
                    Text('Download Receipt', style: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String label;
  final String value;
  const _LinkRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: label, fontsize: 12.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
        CustomText(text: value, fontsize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primaryColor, textAlign: TextAlign.start),
      ],
    );
  }
}

class _InfoRow {
  final IconData? icon;
  final String label;
  final String value;
  const _InfoRow({this.icon, required this.label, required this.value});
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  const _InfoSection({required this.title, required this.rows});

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
          Text(title, style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: AppColors.secondaryTextColor, letterSpacing: 0.8)),
          SizedBox(height: 12.h),
          ...rows.map((row) => Padding(
            padding: EdgeInsets.only(bottom: row == rows.last ? 0 : 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (row.icon != null) ...[
                  Icon(row.icon!, color: AppColors.secondaryTextColor, size: 16.r),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: row.label, fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                      SizedBox(height: 2.h),
                      CustomText(text: row.value, fontsize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
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