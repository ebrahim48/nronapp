import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/helpers/pdf_helper.dart';
import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import 'controller/sales_controller.dart';


class PackingSlipScreen extends StatelessWidget {
  const PackingSlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SaleController>();

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
          text: 'Packing Slip Preview',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final d = c.detailObs.value;
        if (d == null) {
          return Center(
            child: CustomText(
              text: 'No data available.',
              fontsize: 14.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.center,
            ),
          );
        }
        final items = d.inventoryItems;
        final subtotal = items.fold<double>(
            0, (sum, i) => sum + (i.price * i.qty));
        final total = subtotal > 0 ? subtotal : d.totalAmount;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2427),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'H.O.L.E',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                                Text(
                                  'LOGISTICS & INVENTORY\nSYSTEM',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'PACKING\nSLIP',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                                Text(
                                  'ID: ${d.saleNumber}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Divider(
                          color: const Color(0xFF3A3A3A),
                          height: 20.h,
                          thickness: 0.5),

                      // Sale ID + Date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SALE ID',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.secondaryTextColor,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  d.saleNumber,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'DATE',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.secondaryTextColor,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  d.procedureDate.isEmpty
                                      ? '—'
                                      : d.procedureDate,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      // Facility + Physician
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FACILITY',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Poppins',
                                    color: AppColors.secondaryTextColor,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  d.facility.isEmpty ? '—' : d.facility,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'PHYSICIAN',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Poppins',
                                  color: AppColors.secondaryTextColor,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                d.physician.isEmpty ? '—' : d.physician,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Table header
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              'PRODUCT',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryTextColor,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'QTY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryTextColor,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'PRICE',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryTextColor,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Divider(
                          color: const Color(0xFF3A3A3A),
                          height: 12.h,
                          thickness: 0.5),

                      // Items
                      if (items.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            'No items.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        )
                      else
                        ...items.map((item) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name.isEmpty
                                              ? item.tag
                                              : item.name,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color:
                                                AppColors.primaryTextColor,
                                          ),
                                        ),
                                        if (item.serial.isNotEmpty)
                                          Text(
                                            'SN: ${item.serial}',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontFamily: 'Poppins',
                                              color: AppColors
                                                  .secondaryTextColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      item.qty.toString().padLeft(2, '0'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Poppins',
                                        color: AppColors.primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.price > 0
                                          ? '\$${(item.price * item.qty).toStringAsFixed(2)}'
                                          : '—',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Poppins',
                                        color: AppColors.primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),

                      Divider(
                          color: const Color(0xFF3A3A3A),
                          height: 8.h,
                          thickness: 0.5),

                      SizedBox(height: 8.h),

                      // Subtotal
                      if (subtotal > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Subtotal:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              '\$${subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                      ],

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'TOTAL:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Dashed divider
                      Row(
                        children: List.generate(
                          60,
                          (index) => Expanded(
                            child: Container(
                              height: 1,
                              color: index % 2 == 0
                                  ? const Color(0xFF3A3A3A)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        'Thank you for choosing InvictusOS. For support, contact logistics@invictos.io',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  CustomButton(
                    title: 'Generate PDF',
                    onpress: () => PdfHelper.sharePackingSlipPdf(d),
                    color: Colors.transparent,
                    borderColor: AppColors.warningColor,
                    titlecolor: AppColors.warningColor,
                    fontWeight: FontWeight.w600,
                    prefixIcon: SvgPicture.asset(
                      'assets/icons/download.svg',
                      width: 16.r,
                      height: 16.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.warningColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    title: 'Email to Vendor',
                    onpress: () => c.emailPackingSlipToVendor(d),
                    color: const Color(0xFF1E2A3A),
                    titlecolor: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.primaryTextColor,
                      size: 18.r,
                    ),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}