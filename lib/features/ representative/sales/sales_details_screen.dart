import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import 'controller/sales_controller.dart';
import 'create_sales_screen.dart';
import 'model/sales_model.dart';
import 'packing_slip_screen.dart';


class SaleDetailScreen extends StatefulWidget {
  final String saleId;
  const SaleDetailScreen({super.key, required this.saleId});

  @override
  State<SaleDetailScreen> createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen> {
  late final SaleController c;

  @override
  void initState() {
    super.initState();
    c = Get.find<SaleController>();
    c.fetchDetail(widget.saleId);
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
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: Obx(() {
          final d = c.detailObs.value;
          return CustomText(
            text: d?.saleNumber ?? 'Sale Detail',
            fontsize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          );
        }),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CreateSaleScreen(saleId: widget.saleId),
                ),
              ),
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
          ),
        ],
        centerTitle: false,
      ),
      body: Obx(() {
        if (c.isLoadingDetail.value) return _ShimmerDetail();
        final d = c.detailObs.value;
        if (d == null) {
          return Center(
            child: CustomText(
              text: 'Sale not found.',
              fontsize: 14.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
          );
        }
        return _buildDetail(context, d);
      }),
    );
  }

  Widget _buildDetail(BuildContext context, SaleDetailModel d) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          _DetailSectionHeader(
            iconPath: 'assets/icons/billing.svg',
            title: 'Billing',
          ),

          SizedBox(height: 10.h),

          _DetailTable(rows: [
            _DetailRow('Vendor', d.vendor,
                valueColor: AppColors.primaryColor),
            _DetailRow('PPO Number', d.ppoNumber),
            _DetailRow('Total Amount',
                '\$${d.totalAmount.toStringAsFixed(2)}'),
            _DetailRow('Vendor Payment',
                '\$${d.vendorPayment.toStringAsFixed(2)}'),
          ]),

          SizedBox(height: 20.h),

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
                if (d.inventoryItems.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: CustomText(
                      text: 'No inventory items.',
                      fontsize: 13.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
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
              ],
            ),
          ),

          SizedBox(height: 20.h),

          CustomText(
            text: 'Sale Classification',
            fontsize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 10.h),

          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: d.classification,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SvgPicture.asset(
                  'assets/icons/saleclassifiaction.svg',
                  width: 18.r,
                  height: 18.r,
                  colorFilter: ColorFilter.mode(
                    AppColors.secondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          Obx(() => CustomButton(
                title: 'Convert All to Sold',
                loading: c.isConverting.value,
                onpress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E2427),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      title: Text(
                        'Convert Sale Type',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to convert all items to Sold?',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Cancel',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  color: AppColors.secondaryTextColor)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('Convert',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.warningColor)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await c.convertSaleType(widget.saleId);
                  }
                },
                color: Colors.transparent,
                borderColor: AppColors.warningColor,
                borderWidth: 2,
                titlecolor: AppColors.warningColor,
                fontWeight: FontWeight.w600,
                borderRadius: 8.r,
              )),

          SizedBox(height: 20.h),

          CustomText(
            text: 'Representative Split',
            fontsize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 10.h),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFB516), width: 2),
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
                      text: '\$${d.totalCommission.toStringAsFixed(2)}',
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

          CustomButton(
            title: 'Preview Packing Slip',
            onpress: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PackingSlipScreen(),
              ),
            ),
            color: Colors.transparent,
            borderColor: AppColors.warningColor,
            borderWidth: 2,
            titlecolor: AppColors.warningColor,
            fontWeight: FontWeight.w600,
            borderRadius: 8.r,
          ),

          SizedBox(height: 20.h),

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

          if (d.attachments.isEmpty)
            CustomText(
              text: 'No attachments.',
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            )
          else
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
              text: d.note.isEmpty ? 'No notes.' : d.note,
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
              textHeight: 1.6,
            ),
          ),

          SizedBox(height: 20.h),

          CustomText(
            text: 'Audit Trail',
            fontsize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 12.h),

          if (d.auditTrail.isEmpty)
            CustomText(
              text: 'No audit trail.',
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            )
          else
            ...d.auditTrail.asMap().entries.map((e) {
              final isLast = e.key == d.auditTrail.length - 1;
              return _AuditItem(item: e.value, isLast: isLast);
            }),

          SizedBox(height: 20.h),

          // ── Delete ──────────────────────────────────────────────────
          Obx(() => CustomButton(
                title: 'Delete Sale',
                loading: c.isDeleting.value,
                color: Colors.transparent,
                borderColor: AppColors.redColorFF1D1D,
                titlecolor: AppColors.redColorFF1D1D,
                fontWeight: FontWeight.w500,
                onpress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E2427),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      title: Text(
                        'Delete Sale',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to delete this sale? This action cannot be undone.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Cancel',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  color: AppColors.secondaryTextColor)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('Delete',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.redColorFF1D1D)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    final ok = await c.deleteSale(widget.saleId);
                    if (ok && context.mounted) Navigator.pop(context);
                  }
                },
              )),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _ShimmerDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(height: 18.h, width: 180.w),
            SizedBox(height: 12.h),
            _shimmerBox(height: 130.h),
            SizedBox(height: 20.h),
            _shimmerBox(height: 18.h, width: 120.w),
            SizedBox(height: 12.h),
            _shimmerBox(height: 100.h),
            SizedBox(height: 20.h),
            _shimmerBox(height: 18.h, width: 150.w),
            SizedBox(height: 12.h),
            _shimmerBox(height: 160.h),
            SizedBox(height: 20.h),
            _shimmerBox(height: 18.h, width: 140.w),
            SizedBox(height: 12.h),
            _shimmerBox(height: 60.h),
            SizedBox(height: 10.h),
            _shimmerBox(height: 48.h),
            SizedBox(height: 20.h),
            _shimmerBox(height: 18.h, width: 160.w),
            SizedBox(height: 12.h),
            _shimmerBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({required double height, double? width}) => Container(
        height: height,
        width: width ?? double.infinity,
        margin: EdgeInsets.only(bottom: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      );
}

// ── Detail widgets ────────────────────────────────────────────────────────────

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
