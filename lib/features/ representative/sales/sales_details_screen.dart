import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../core/config/app-routes/app_routes.dart';
import 'controller/sales_controller.dart';
import 'model/sales_model.dart';


class SaleDetailScreen extends StatelessWidget {
  const SaleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SaleController>();
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
          text: d.saleNumber,
          fontsize: 17.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Row(
                children: [
                  CustomText(
                    text: 'Edit',
                    fontsize: 13.sp,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.edit_outlined,
                      color: AppColors.primaryTextColor, size: 14.r),
                ],
              ),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Shipment Information ───────────────────────────────
            _DetailSectionHeader(
              iconPath: 'assets/icons/shipmentinformation.svg',
              title: 'Shipment Information',
              trailing: Icon(Icons.copy_outlined,
                  color: AppColors.secondaryTextColor, size: 18.r),
            ),

            SizedBox(height: 10.h),

            _DetailTable(rows: [
              _DetailRow('Sale Type', d.saleType),
              _DetailRow('Physician', d.physician),
              _DetailRow('Facility', d.facility),
              _DetailRow('Procedure Date', d.procedureDate,
                  valueColor: AppColors.primaryColor),
            ]),

            SizedBox(height: 20.h),

            // ── Billing ────────────────────────────────────────────
            _DetailSectionHeader(
              iconPath: 'assets/icons/billing.svg',
              title: 'Billing',
            ),

            SizedBox(height: 10.h),

            _DetailTable(rows: [
              _DetailRow('Serial Numbers', d.serialNumbers),
              _DetailRow('Vendor', d.vendor,
                  valueColor: AppColors.primaryColor),
              _DetailRow('PPO Number', d.ppoNumber),
            ]),

            SizedBox(height: 20.h),

            // ── Inventory Item List ────────────────────────────────
            _DetailSectionHeader(
                iconPath: 'assets/icons/implantsales.svg',
                title: 'Inventory Item List'),

            SizedBox(height: 10.h),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                children: [
                  ...d.inventoryItems.map((item) => Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 12.h),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: item.name,
                                  fontsize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                                CustomText(
                                  text: item.serial,
                                  fontsize: 11.sp,
                                  color: AppColors.secondaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius:
                                BorderRadius.circular(6.r),
                                border: Border.all(
                                    color: const Color(0xFF3A3A3A)),
                              ),
                              child: Text(
                                item.tag,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'Poppins',
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item != d.inventoryItems.last)
                        Divider(
                            height: 1,
                            color: const Color(0xFF3A3A3A),
                            thickness: 0.5),
                    ],
                  )),
                  Divider(
                      height: 1,
                      color: const Color(0xFF3A3A3A),
                      thickness: 0.5),
                  // View All
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: CustomText(
                      text: 'View All 12 Items',
                      fontsize: 13.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ── Sale Classification ────────────────────────────────
            CustomText(
              text: 'Sale Classification',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 10.h),

            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Row(
                children: [
                  Icon(Icons.swap_horiz_outlined,
                      color: AppColors.secondaryTextColor, size: 18.r),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: d.classification,
                    fontsize: 13.sp,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            CustomButton(
              title: 'Convert All to Sold',
              onpress: () {},
              color: Colors.transparent,
              borderColor: AppColors.warningColor,
              titlecolor: AppColors.warningColor,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 20.h),

            // ── Representative Split ───────────────────────────────
            CustomText(
              text: 'Representative Split',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 10.h),

            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                children: [
                  ...d.repSplits.map((rep) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: AppColors.secondaryTextColor,
                            size: 16.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomText(
                            text: rep.name,
                            fontsize: 13.sp,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        CustomText(
                          text: '${rep.splitPercent}% Split',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  )),
                  Divider(
                      color: const Color(0xFF3A3A3A),
                      height: 1,
                      thickness: 0.5),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Total Commission Pool',
                        fontsize: 12.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        text:
                        '\$${d.totalCommission.toStringAsFixed(2)}',
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text:
                    'Auto-calculated based on region tier 2 and product margins.',
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Preview Packing Slip button
            CustomButton(
              title: 'Preview Packing Slip',
              onpress: () => Navigator.pushNamed(
                  context, AppRoutes.packingSlipScreen),
              color: Colors.transparent,
              borderColor: AppColors.warningColor,
              titlecolor: AppColors.warningColor,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 20.h),

            // ── Attachments ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Attachments',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: AppColors.primaryColor, size: 16.r),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: 'Add',
                      fontsize: 13.sp,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10.h),

            ...d.attachments.map((att) => Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      color: att.isPdf
                          ? AppColors.redColorFF1D1D
                          .withValues(alpha: 0.15)
                          : AppColors.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      att.isPdf
                          ? Icons.picture_as_pdf_outlined
                          : Icons.image_outlined,
                      color: att.isPdf
                          ? AppColors.redColorFF1D1D
                          : AppColors.primaryColor,
                      size: 18.r,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: att.fileName,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(
                          text: '${att.size} • ${att.date}',
                          fontsize: 10.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.remove_red_eye_outlined,
                      color: AppColors.primaryColor, size: 18.r),
                ],
              ),
            )),

            SizedBox(height: 20.h),

            // ── Note ──────────────────────────────────────────────
            CustomText(
              text: 'Note',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 10.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: CustomText(
                text: d.note,
                fontsize: 13.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
                textHeight: 1.6,
              ),
            ),

            SizedBox(height: 20.h),

            // ── Audit Trail ────────────────────────────────────────
            CustomText(
              text: 'Audit Trail',
              fontsize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 12.h),

            ...d.auditTrail.asMap().entries.map((e) {
              final isLast = e.key == d.auditTrail.length - 1;
              return _AuditItem(item: e.value, isLast: isLast);
            }),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

// ── Reusable detail widgets ───────────────────────────────────────────────────

class _DetailRow {
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow(this.label, this.value, {this.valueColor});
}

class _DetailTable extends StatelessWidget {
  final List<_DetailRow> rows;
  const _DetailTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
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
                    horizontal: 14.w, vertical: 13.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: e.value.label,
                      fontsize: 12.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 16.w),
                    Flexible(
                      child: CustomText(
                        text: e.value.value,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: e.value.valueColor ??
                            AppColors.primaryTextColor,
                        textAlign: TextAlign.end,
                      ),
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

class _DetailSectionHeader extends StatelessWidget {
  final String iconPath;
  final String title;
  final Widget? trailing;

  const _DetailSectionHeader({
    required this.iconPath,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 18.r,
          height: 18.r,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _AuditItem extends StatelessWidget {
  final AuditTrailModel item;
  final bool isLast;

  const _AuditItem({required this.item, required this.isLast});

  Color _dotColor() {
    switch (item.type) {
      case AuditType.success:
        return const Color(0xFF1DB954);
      case AuditType.info:
        return AppColors.primaryColor;
      case AuditType.warning:
        return AppColors.warningColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: _dotColor(),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 14.r),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: const Color(0xFF3A3A3A),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.title,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: item.subtitle,
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: item.dateTime,
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}