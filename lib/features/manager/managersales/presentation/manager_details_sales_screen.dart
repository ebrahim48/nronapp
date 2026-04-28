import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/bill_verification_toggle.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_attachment_tile.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_detail_header.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_feedback_section.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_info_section.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_inventory_list.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_note_section.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/sales_rep_split_setion.dart';
import 'package:nron_app/features/manager/managersales/presentation/widgets/transaction_status_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_sales_controller.dart';


class ManagerSaleDetailScreen extends StatelessWidget {
  const ManagerSaleDetailScreen({super.key});

  void _showAddNoteDialog(BuildContext context, ManagerSaleController c) {
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2427),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Title row
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/addnote.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.warningColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Add Note',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Text field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF252A2D),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: TextField(
                  controller: noteController,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.primaryTextColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your note here...',
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      color: AppColors.secondaryTextColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Save button
              GestureDetector(
                onTap: () {
                  c.saveNote(noteController.text.trim());
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.warningColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/note.svg',
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.blackColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Save Note',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
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
    final c = Get.find<ManagerSaleController>();
    final d = c.saleDetail;

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
          text: 'Sale Details',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SaleDetailHeader(
              saleNumber: d.saleNumber,
              repName: d.repName,
              onViewLogistic: () {

              },
              onAddNote: () => _showAddNoteDialog(context, c),
              onApproveCommission: c.approveCommission,
            ),

            SizedBox(height: 14.h),

            TransactionStatusCard(status: d.transactionStatus),

            SizedBox(height: 20.h),

            SaleInfoSection(
              title: 'Shipment Information',
              rows: [
                SaleInfoRow('Sale Type', d.saleType),
                SaleInfoRow('Doctor', d.doctor),
                SaleInfoRow('Facility', d.facility),
                SaleInfoRow(
                  'Procedure Date',
                  d.procedureDate,
                  valueColor: AppColors.primaryColor,
                ),
              ],
            ),

            SizedBox(height: 20.h),

            SaleInfoSection(
              title: 'Implant & Billing',
              rows: [
                SaleInfoRow(
                  'Vendor',
                  d.vendor,
                  valueColor: AppColors.primaryColor,
                ),
                SaleInfoRow('PO Number', d.poNumber),
                SaleInfoRow(
                    'Total Bill', '\$${d.totalBill.toStringAsFixed(2)}'),
                SaleInfoRow(
                  'Commission',
                  '\$${d.commission.toStringAsFixed(2)}\n${d.commissionPercent.toInt()}% OF TOTAL',
                  valueColor: AppColors.primaryColor,
                  bold: true,
                ),
              ],
            ),

            SizedBox(height: 20.h),

            SaleInventoryList(items: d.inventoryItems),

            SizedBox(height: 20.h),

            SaleRepSplitSection(
              splits: d.repSplits,
              totalCommissionPool: d.totalCommissionPool,
            ),

            SizedBox(height: 20.h),

            CustomText(
              text: 'Attachments',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10.h),
            ...d.attachments.map(
                  (att) => SaleAttachmentTile(attachment: att),
            ),

            SizedBox(height: 16.h),

            Obx(() => BillVerificationToggle(
              value: c.billVerification.value,
              onToggle: c.toggleBillVerification,
            )),

            SizedBox(height: 20.h),

            SaleNoteSection(note: d.note),

            SizedBox(height: 16.h),

            SaleFeedbackSection(
              controller: c.feedbackController,
              onSend: c.sendFeedback,
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}