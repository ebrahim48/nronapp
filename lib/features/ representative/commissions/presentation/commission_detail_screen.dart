import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/commission_controller.dart';
import '../domain/model/commission_model.dart';


class CommissionDetailScreen extends StatelessWidget {
  const CommissionDetailScreen({super.key});

  Color _statusColor(CommissionStatus s) {
    switch (s) {
      case CommissionStatus.pending:
        return AppColors.warningColor;
      case CommissionStatus.paid:
        return const Color(0xFF1DB954);
      case CommissionStatus.overdue:
        return AppColors.redColorFF1D1D;
      case CommissionStatus.approved:
        return const Color(0xFF1DB954);
    }
  }

  String _statusLabel(CommissionStatus s) {
    switch (s) {
      case CommissionStatus.pending:
        return 'PENDING';
      case CommissionStatus.paid:
        return 'PAID';
      case CommissionStatus.overdue:
        return 'OVERDUE';
      case CommissionStatus.approved:
        return 'APPROVED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CommissionController());

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
        if (c.isLoadingDetail.value) return _CommissionDetailShimmer();

        final d = c.commissionDetail;
        final statusColor = _statusColor(d.status);

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: statusColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time,
                            color: statusColor, size: 13.r),
                        SizedBox(width: 4.w),
                        Text(
                          _statusLabel(d.status),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomText(
                    text: 'Logged ${d.loggedDate}',
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        topRight: Radius.circular(14.r),
                      ),
                      child: Image.asset(
                        'assets/images/commissonimage.png',
                        width: double.infinity,
                        height: 170.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(14.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: d.productName,
                                    fontsize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  CustomText(
                                    text: d.saleId,
                                    fontsize: 13.sp,
                                    color: AppColors.warningColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Container(
                                width: 40.r,
                                height: 40.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Icon(
                                  Icons.medical_services_outlined,
                                  color: AppColors.primaryColor,
                                  size: 20.r,
                                ),
                              ),
                            ],
                          ),

                          Divider(
                              color: const Color(0xFF3A3A3A),
                              height: 20.h,
                              thickness: 0.5),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SURGEON',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontFamily: 'Poppins',
                                        color: AppColors.secondaryTextColor,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: d.surgeon,
                                      fontsize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTextColor,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: d.facility,
                                      fontsize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTextColor,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          Text(
                            'PROCEDURE DATE',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontFamily: 'Poppins',
                              color: AppColors.secondaryTextColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: d.procedureDate,
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              CustomText(
                text: 'Financial Breakdown',
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
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Column(
                  children: [
                    _FinancialRow(
                      label: 'Sale Amount',
                      value: '\$${d.saleAmount.toStringAsFixed(2)}',
                      valueColor: AppColors.primaryTextColor,
                    ),
                    SizedBox(height: 10.h),
                    _FinancialRow(
                      label: 'Commission Rate',
                      value: '${d.commissionRate.toInt()}%',
                      valueColor: AppColors.primaryTextColor,
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 345.w,
                      height: 1,
                      color: const Color(0xFFD4D4D4),
                    ),
                    SizedBox(height: 10.h),
                    _FinancialRow(
                      label: 'Your Commission',
                      value: '\$${d.yourCommission.toStringAsFixed(2)}',
                      valueColor: AppColors.warningColor,
                      isBold: true,
                      labelBold: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color:
                        AppColors.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.sync,
                        color: AppColors.primaryColor,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Synced with QuickBooks',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(
                          text:
                          'Ref: ${d.quickBooksRef}  •  ${d.quickBooksSyncTime}',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }
}

class _FinancialRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;
  final bool labelBold;

  const _FinancialRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isBold = false,
    this.labelBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            fontWeight:
            labelBold ? FontWeight.w700 : FontWeight.w400,
            color: AppColors.primaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 20.sp : 13.sp,
            fontFamily: 'Poppins',
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170.h,
      color: const Color(0xFF1A1A1A),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: const Color(0xFF3A3A3A),
          size: 48.r,
        ),
      ),
    );
  }
}

class _CommissionDetailShimmer extends StatelessWidget {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Box(width: 100.w, height: 28.h, radius: 20.r),
                _Box(width: 120.w, height: 16.h, radius: 4.r),
              ],
            ),
            SizedBox(height: 14.h),
            _Box(width: double.infinity, height: 280.h, radius: 14.r),
            SizedBox(height: 20.h),
            _Box(width: 160.w, height: 18.h, radius: 4.r),
            SizedBox(height: 10.h),
            _Box(width: double.infinity, height: 120.h, radius: 12.r),
            SizedBox(height: 16.h),
            _Box(width: double.infinity, height: 66.h, radius: 12.r),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _Box({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
