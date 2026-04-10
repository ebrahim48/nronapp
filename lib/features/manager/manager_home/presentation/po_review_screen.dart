import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/po_info_grid.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/po_product_list.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/po_status_timeline.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../manager_controller/manager_po_controller.dart';


class POReviewScreen extends StatelessWidget {
  const POReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerPOController>();
    final d = c.poDetail;

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: d.imageAsset != null
                        ? Image.asset(
                      d.imageAsset!,
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
                    text: d.title,
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 14.h),

                  POInfoGrid(detail: d),

                  Divider(
                      color: const Color(0xFF3A3A3A),
                      height: 20.h,
                      thickness: 0.5),

                  CustomText(
                    text: 'Documents',
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.picture_as_pdf_outlined,
                                  color: AppColors.blackColor,
                                  size: 20.r),
                              SizedBox(width: 8.w),
                              Text(
                                'View PO Document (PDF)',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.open_in_new,
                              color: AppColors.blackColor, size: 18.r),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  POProductList(products: d.products),

                  SizedBox(height: 16.h),

                  CustomText(
                    text: 'Documents',
                    fontsize: 13.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  ...d.documents.map((doc) => Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                          color: const Color(0xFF3A3A3A)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34.r,
                          height: 34.r,
                          decoration: BoxDecoration(
                            color: doc.isPdf
                                ? AppColors.redColorFF1D1D
                                .withValues(alpha: 0.15)
                                : AppColors.primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius:
                            BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            doc.isPdf
                                ? Icons.picture_as_pdf_outlined
                                : Icons.image_outlined,
                            color: doc.isPdf
                                ? AppColors.redColorFF1D1D
                                : AppColors.primaryColor,
                            size: 16.r,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: doc.fileName,
                                fontsize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                              CustomText(
                                text: '${doc.size} • ${doc.date}',
                                fontsize: 10.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.remove_red_eye_outlined,
                            color: AppColors.primaryColor,
                            size: 18.r),
                      ],
                    ),
                  )),

                  SizedBox(height: 16.h),

                  POStatusTimeline(items: d.timeline),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 12.h),
            child: CustomButton(
              title: 'Contact Vendor',
              onpress: () {},
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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