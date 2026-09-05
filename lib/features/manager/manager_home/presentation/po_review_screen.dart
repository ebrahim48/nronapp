import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/po_info_grid.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/po_product_list.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/po_status_timeline.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../manager_controller/manager_po_controller.dart';
import '../model/manager_po_model.dart';
import '../../../../core/custom_widgets/document_preview.dart';

class POReviewScreen extends StatelessWidget {
  const POReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerPOController>();

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
          text: 'Review & Send PO',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Obx(() {

        if (c.isLoadingDetail.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 14.h),
              child: Column(
                children: [
                  Container(height: 160.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                  SizedBox(height: 14.h),
                  Container(height: 200.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                  SizedBox(height: 14.h),
                  Container(height: 160.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                ],
              ),
            ),
          );
        }

        final d = c.poDetail;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: d.handWritePODoc != null &&
                              d.handWritePODoc!.isNotEmpty
                          ? Image.network(
                              d.handWritePODoc!,
                              width: double.infinity,
                              height: 160.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _ImagePlaceholder(),
                            )
                          : _ImagePlaceholder(),
                    ),

                    SizedBox(height: 14.h),

                    Row(
                      children: [
                        CustomText(
                          text: '${d.poNumber} - ',
                          fontsize: 12.sp,
                          color: AppColors.primaryColor,
                          textAlign: TextAlign.start,
                        ),
                        if (d.urgencyTag.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.redColorFF1D1D
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: CustomText(
                              text: d.urgencyTag,
                              fontsize: 10.sp,
                              color: AppColors.redColorFF1D1D,
                              textAlign: TextAlign.start,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    CustomText(
                      text: d.title.isNotEmpty ? d.title : d.poNumber,
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.start,
                    ),


                    if (d.notes != null && d.notes!.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2121),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: const Color(0xFF3A3A3A)),
                        ),
                        child: CustomText(
                          text: d.notes!,
                          fontsize: 12.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                          textHeight: 1.5,
                        ),
                      ),
                    ],

                    SizedBox(height: 14.h),

                    POInfoGrid(detail: d),

                    Divider(
                        color: const Color(0xFF3A3A3A),
                        height: 20.h,
                        thickness: 0.5),


                    if (d.products.isNotEmpty) ...[
                      POProductList(products: d.products),
                      SizedBox(height: 16.h),
                    ],


                    if (d.documents.isNotEmpty) ...[
                      CustomText(
                        text: 'Documents',
                        fontsize: 13.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8.h),
                      ...d.documents.map((doc) => _DocumentTile(doc: doc)),
                      SizedBox(height: 16.h),
                    ],


                    POStatusTimeline(items: d.timeline),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 12.h),
              child: Obx(() => CustomButton(
                    title: d.isSentToVendor
                        ? 'Already Sent to Vendor'
                        : 'Contact Vendor',
                    loading: c.isSendingMail.value,
                    onpress: d.isSentToVendor
                        ? () {}
                        : () => c.sendVendorMail(d.id),
                    titlecolor: AppColors.blackColor,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        );
      }),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      color: const Color(0xFF1A1A1A),
      child: Icon(Icons.image_outlined,
          color: const Color(0xFF3A3A3A), size: 40.r),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final PODocumentItem doc;
  const _DocumentTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => openDocumentPreview(context, doc.url),
      child: Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          // Thumbnail or icon
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: !doc.isPdf && doc.url.isNotEmpty
                ? Image.network(
                    doc.url,
                    width: 34.r,
                    height: 34.r,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fileIcon(doc.isPdf),
                  )
                : _fileIcon(doc.isPdf),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              text: doc.fileName.isNotEmpty ? doc.fileName : 'Document',
              fontsize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
              maxline: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.remove_red_eye_outlined,
              color: AppColors.primaryColor, size: 18.r),
        ],
      ),
      ),
    );
  }

  Widget _fileIcon(bool isPdf) {
    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        color: isPdf
            ? AppColors.redColorFF1D1D.withValues(alpha: 0.15)
            : AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(
        isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
        color: isPdf ? AppColors.redColorFF1D1D : AppColors.primaryColor,
        size: 16.r,
      ),
    );
  }
}
