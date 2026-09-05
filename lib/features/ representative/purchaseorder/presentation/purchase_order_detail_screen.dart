import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/custom_widgets/custom_network_image.dart';
import '../../../../core/custom_widgets/document_preview.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/purchase_order_controller.dart';
import '../model/purchase_order_model.dart';

class PurchaseOrderDetailScreen extends StatelessWidget {
  final String orderId;
  const PurchaseOrderDetailScreen({super.key, required this.orderId});

  static const _card = Color(0xFF242424);
  static const _border = Color(0xFF3A3A3A);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PurchaseOrderController>();
    ctrl.fetchDetail(orderId);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Purchase Order Details',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          GestureDetector(
            onTap: () => context.pushNamed(
              AppRoutes.updatePurchaseOrderScreen,
              extra: orderId,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(Icons.edit_outlined,
                  color: AppColors.primaryColor, size: 22.r),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoadingDetail.value) {
          return const _DetailShimmer();
        }
        final detail = ctrl.detailObs.value;
        if (detail == null) {
          return Center(
            child: CustomText(
              text: 'Order not found',
              fontsize: 14.sp,
              color: AppColors.secondaryTextColor,
            ),
          );
        }
        return _DetailBody(detail: detail);
      }),
    );
  }
}


class _DetailBody extends StatelessWidget {
  final PurchaseOrderDetailModel detail;
  const _DetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          if (detail.thumbnail.isNotEmpty)
            _ThumbnailCard(url: detail.thumbnail),
          SizedBox(height: 14.h),

          // PO Header
          _PoHeaderCard(detail: detail),
          SizedBox(height: 14.h),

          // Surgery info
          if (detail.surgeonName.isNotEmpty || detail.surgeryType.isNotEmpty)
            _InfoCard(
              title: 'Surgery Information',
              rows: [
                if (detail.surgeonName.isNotEmpty)
                  _InfoRow(label: 'Surgeon', value: detail.surgeonName),
                if (detail.surgeryType.isNotEmpty)
                  _InfoRow(label: 'Surgery Type', value: detail.surgeryType),
                if (detail.surgeryDate.isNotEmpty)
                  _InfoRow(label: 'Surgery Date', value: detail.surgeryDate),
              ],
            ),
          if (detail.surgeonName.isNotEmpty || detail.surgeryType.isNotEmpty)
            SizedBox(height: 14.h),

          // Facility info
          if (detail.facilityAddress.isNotEmpty ||
              detail.facilityPhone.isNotEmpty)
            _InfoCard(
              title: 'Facility',
              rows: [
                if (detail.facilityAddress.isNotEmpty)
                  _InfoRow(label: 'Address', value: detail.facilityAddress),
                if (detail.facilityPhone.isNotEmpty)
                  _InfoRow(label: 'Phone', value: detail.facilityPhone),
                if (detail.facilityContacts.isNotEmpty)
                  _InfoRow(label: 'Contacts', value: detail.facilityContacts),
              ],
            ),
          if (detail.facilityAddress.isNotEmpty ||
              detail.facilityPhone.isNotEmpty)
            SizedBox(height: 14.h),

          // Products
          if (detail.products.isNotEmpty) ...[
            _ProductsCard(detail: detail),
            SizedBox(height: 14.h),
          ],

          // Handwritten PO
          if (detail.handWritePODoc.isNotEmpty) ...[
            _DocPreviewCard(url: detail.handWritePODoc, label: 'Handwritten PO'),
            SizedBox(height: 14.h),
          ],

          // Documents
          if (detail.documents.isNotEmpty) ...[
            _DocumentsCard(docs: detail.documents),
            SizedBox(height: 14.h),
          ],

          // Notes
          if (detail.notes.isNotEmpty) ...[
            _NotesCard(notes: detail.notes),
            SizedBox(height: 14.h),
          ],

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}


class _ThumbnailCard extends StatelessWidget {
  final String url;
  const _ThumbnailCard({required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openDocumentPreview(context, url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: double.infinity,
          height: 160.h,
          child: CustomNetworkImage(
            imageUrl: url,
            width: double.infinity,
            height: 160.h,
          ),
        ),
      ),
    );
  }
}


class _PoHeaderCard extends StatelessWidget {
  final PurchaseOrderDetailModel detail;
  const _PoHeaderCard({required this.detail});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'complete':
        return AppColors.successColor;
      case 'open':
        return AppColors.warningColor;
      case 'lost':
        return AppColors.redColorFF1D1D;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: detail.purchaseOrderNumber,
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                textAlign: TextAlign.start,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor(detail.status).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: CustomText(
                  text: detail.statusLabel,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: CustomText(
              text: detail.orderTypeLabel,
              fontsize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 14.h),
          Divider(color: const Color(0xFF3A3A3A), height: 1.h),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _KeyVal(
                    label: 'Patient ID',
                    value: detail.patientId.isNotEmpty
                        ? detail.patientId
                        : '—'),
              ),
              Expanded(
                child: _KeyVal(
                    label: 'Procedure Date',
                    value: detail.procedureDate.isNotEmpty
                        ? detail.procedureDate
                        : '—',
                    alignEnd: true),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _KeyVal(
                    label: 'Created On',
                    value: detail.createdAt.isNotEmpty
                        ? detail.createdAt
                        : '—'),
              ),
              Expanded(
                child: _KeyVal(
                    label: 'Total Amount',
                    value: '\$${detail.totalAmount.toStringAsFixed(2)}',
                    valueColor: AppColors.primaryColor,
                    alignEnd: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: CustomText(
              text: title.toUpperCase(),
              fontsize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          Divider(color: const Color(0xFF3A3A3A), height: 1.h),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: rows
                  .map((r) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: r,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: CustomText(
            text: value,
            fontsize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}


class _ProductsCard extends StatefulWidget {
  final PurchaseOrderDetailModel detail;
  const _ProductsCard({required this.detail});

  @override
  State<_ProductsCard> createState() => _ProductsCardState();
}

class _ProductsCardState extends State<_ProductsCard> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded =
        List.generate(widget.detail.products.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.detail.products;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'PRODUCTS',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: '${products.length} items',
                  fontsize: 12.sp,
                  color: AppColors.secondaryTextColor,
                ),
              ],
            ),
          ),
          ...products.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            return Column(
              children: [
                Divider(color: const Color(0xFF3A3A3A), height: 1.h),
                Padding(
                  padding: EdgeInsets.all(14.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: p.productName,
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: p.productId,
                              fontsize: 11.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A3A3A),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          text:
                              '${p.listOfItems.length.toString().padLeft(2, '0')} ITEMS',
                          fontsize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _expanded[i] = !_expanded[i]),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    color: const Color(0xFF1E2427),
                    child: AnimatedRotation(
                      turns: _expanded[i] ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.secondaryTextColor,
                        size: 20.r,
                      ),
                    ),
                  ),
                ),
                if (_expanded[i] && p.listOfItems.isNotEmpty)
                  Container(
                    color: const Color(0xFF1E2427),
                    child: Column(
                      children: p.listOfItems
                          .map(
                            (sl) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 8.h),
                              child: Row(
                                children: [
                                  Icon(Icons.drag_indicator,
                                      color: AppColors.secondaryTextColor,
                                      size: 14.r),
                                  SizedBox(width: 8.w),
                                  CustomText(
                                    text: sl,
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
            );
          }),
        ],
      ),
    );
  }
}


class _DocPreviewCard extends StatelessWidget {
  final String url;
  final String label;
  const _DocPreviewCard({required this.url, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openDocumentPreview(context, url),
      child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.image_outlined,
                color: AppColors.primaryColor, size: 18.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: label,
              fontsize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          Icon(Icons.open_in_new,
              color: AppColors.primaryColor, size: 16.r),
        ],
      ),
      ),
    );
  }
}


class _DocumentsCard extends StatelessWidget {
  final List<String> docs;
  const _DocumentsCard({required this.docs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: CustomText(
              text: 'DOCUMENTS',
              fontsize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          ...docs.asMap().entries.map((entry) {
            final url = entry.value;
            final name = url.split('/').last.split('?').first;
            final isPdf = name.toLowerCase().endsWith('.pdf');
            final iconColor =
                isPdf ? Colors.redAccent : AppColors.primaryColor;
            final bgColor = isPdf
                ? Colors.redAccent.withOpacity(0.12)
                : AppColors.primaryColor.withOpacity(0.12);
            final icon =
                isPdf ? Icons.picture_as_pdf : Icons.image_outlined;
            final isLast = entry.key == docs.length - 1;
            return Column(
              children: [
                Divider(color: const Color(0xFF3A3A3A), height: 1.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => openDocumentPreview(context, url),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 12.h),
                    child: Row(
                    children: [
                      Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius:
                                BorderRadius.circular(8.r)),
                        child: Icon(icon,
                            color: iconColor, size: 18.r),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomText(
                          text: name.isNotEmpty ? name : 'Document',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Icon(Icons.remove_red_eye_outlined,
                          color: AppColors.primaryColor, size: 20.r),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                      color: const Color(0xFF3A3A3A),
                      height: 1.h,
                      indent: 14.w,
                      endIndent: 14.w),
              ],
            );
          }),
        ],
      ),
    );
  }
}


class _NotesCard extends StatelessWidget {
  final String notes;
  const _NotesCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'NOTES',
            fontsize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: notes,
            fontsize: 13.sp,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}


class _KeyVal extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool alignEnd;
  const _KeyVal({
    required this.label,
    required this.value,
    this.valueColor,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final align = alignEnd ? TextAlign.end : TextAlign.start;
    final cross =
        alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: cross,
      children: [
        CustomText(
          text: label,
          fontsize: 10.sp,
          color: AppColors.secondaryTextColor,
          textAlign: align,
        ),
        SizedBox(height: 2.h),
        CustomText(
          text: value,
          fontsize: 13.sp,
          fontWeight: FontWeight.w600,
          color: valueColor ?? AppColors.primaryTextColor,
          textAlign: align,
        ),
      ],
    );
  }
}


class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            _shimmerBox(height: 160.h),
            SizedBox(height: 14.h),
            _shimmerBox(height: 160.h),
            SizedBox(height: 14.h),
            _shimmerBox(height: 120.h),
            SizedBox(height: 14.h),
            _shimmerBox(height: 120.h),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({required double height, double? width}) => Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
      );
}
