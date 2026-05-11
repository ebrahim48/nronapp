import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_commission_controller.dart';

class CommissionManagementScreen extends StatelessWidget {
  const CommissionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerCommissionController>();

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
          text: 'Commission Management',
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
            Text('Sales Team Rates',
                style: TextStyle(
                    fontSize: 22.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColor)),
            SizedBox(height: 4.h),
            CustomText(
              text:
                  'Manage and update individual commission structures for your representatives.',
              fontsize: 12.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 16.h),

            // ── Avg + Reps stats ──────────────────────────────────────
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color:
                                  AppColors.primaryColor.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                text: 'Avg. Commission',
                                fontsize: 10.sp,
                                color: AppColors.primaryColor,
                                textAlign: TextAlign.start),
                            SizedBox(height: 4.h),
                            CustomText(
                                text: '${c.avgCommission.value}%',
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2121),
                          borderRadius: BorderRadius.circular(10.r),
                          border:
                              Border.all(color: const Color(0xFF3A3A3A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                text: 'Reps',
                                fontsize: 10.sp,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start),
                            SizedBox(height: 4.h),
                            CustomText(
                                text: '${c.totalReps.value}',
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),

            SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: 'Team Commission Rates',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start),
              ],
            ),

            SizedBox(height: 10.h),

            // ── Rep rate list ─────────────────────────────────────────
            Obx(() {
              if (c.isLoadingManage.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Column(
                    children: List.generate(
                      3,
                      (_) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        height: 160.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (c.repRates.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: CustomText(
                      text: 'No commission rates found.',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Column(
                children: c.repRates.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rep = entry.value;
                  // Each card gets its own TextEditingController
                  final rateCtrl = TextEditingController();
                  final isUpdating = false.obs;

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: const Color(0xFF3A3A3A), width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Rep info row ──────────────────────────────
                        Row(
                          children: [
                            ClipOval(
                              child: rep.avatarUrl != null &&
                                      rep.avatarUrl!.isNotEmpty
                                  ? Image.network(
                                      rep.avatarUrl!,
                                      width: 44.r,
                                      height: 44.r,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _fallbackAvatar(),
                                    )
                                  : _fallbackAvatar(),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text: rep.name.isNotEmpty
                                          ? rep.name
                                          : 'Representative',
                                      fontsize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryTextColor,
                                      textAlign: TextAlign.start),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.redColorFF1D1D
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        child: Text(rep.role,
                                            style: TextStyle(
                                                fontSize: 9.sp,
                                                fontFamily: 'Poppins',
                                                color: AppColors.redColorFF1D1D,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      SizedBox(width: 6.w),
                                      Icon(Icons.access_time,
                                          color: AppColors.secondaryTextColor,
                                          size: 11.r),
                                      SizedBox(width: 2.w),
                                      Text('Updated ${rep.updatedDate}',
                                          style: TextStyle(
                                              fontSize: 9.sp,
                                              fontFamily: 'Poppins',
                                              color:
                                                  AppColors.secondaryTextColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Current rate badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                    color: AppColors.primaryColor
                                        .withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                '${rep.currentRate.toStringAsFixed(0)}%',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 14.h),
                        Divider(
                            height: 1,
                            thickness: 0.5,
                            color: const Color(0xFF2A2A2A)),
                        SizedBox(height: 12.h),

                        // ── New rate input + Update button ────────────
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 44.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                      color: const Color(0xFF3A3A3A)),
                                ),
                                child: TextField(
                                  controller: rateCtrl,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d{0,3}(\.\d{0,2})?')),
                                  ],
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontFamily: 'Poppins',
                                      color: AppColors.primaryTextColor),
                                  decoration: InputDecoration(
                                    hintText: 'New rate %',
                                    hintStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Poppins',
                                        color: AppColors.secondaryTextColor),
                                    suffixText: '%',
                                    suffixStyle: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: 'Poppins',
                                        color: AppColors.secondaryTextColor),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 12.h),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Obx(() => isUpdating.value
                                ? SizedBox(
                                    width: 44.r,
                                    height: 44.r,
                                    child: Center(
                                      child: SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      final rateText = rateCtrl.text.trim();
                                      final rate = double.tryParse(rateText);
                                      if (rate == null) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              'Enter a valid rate'),
                                          backgroundColor:
                                              AppColors.redColorFF1D1D,
                                          duration:
                                              const Duration(seconds: 2),
                                        ));
                                        return;
                                      }
                                      isUpdating.value = true;
                                      await c.updateRate(index,
                                          newRate: rate);
                                      isUpdating.value = false;
                                      rateCtrl.clear();
                                    },
                                    child: Container(
                                      height: 44.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.check,
                                              color: AppColors.blackColor,
                                              size: 14.r),
                                          SizedBox(width: 4.w),
                                          Text('Update',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.blackColor)),
                                        ],
                                      ),
                                    ),
                                  )),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      width: 44,
      height: 44,
      color: const Color(0xFF3A3A3A),
      child: const Icon(Icons.person, color: Colors.white54),
    );
  }
}
