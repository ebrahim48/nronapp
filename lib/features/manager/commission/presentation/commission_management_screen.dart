import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_commission_controller.dart';

class CommissionManagementScreen extends StatelessWidget {
  const CommissionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerCommissionController());

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
            Text('Sales Team Rates', style: TextStyle(fontSize: 22.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w800, color: AppColors.primaryTextColor)),
            SizedBox(height: 4.h),
            CustomText(text: 'Manage and update individual commission structures for your representatives.', fontsize: 12.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),

            SizedBox(height: 16.h),

            // Avg + Reps stats
            Obx(() => Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: 'Avg. Commission', fontsize: 10.sp, color: AppColors.primaryColor, textAlign: TextAlign.start),
                        SizedBox(height: 4.h),
                        CustomText(text: '${c.avgCommission.value}%', fontsize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
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
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: 'Reps', fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                        SizedBox(height: 4.h),
                        CustomText(text: '${c.totalReps.value}', fontsize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
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
                CustomText(text: 'Team Commission Rates', fontsize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                GestureDetector(
                  onTap: () {},
                  child: CustomText(text: 'View More', fontsize: 12.sp, color: AppColors.primaryColor, textAlign: TextAlign.start),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Obx(() => Column(
              children: c.repRates.asMap().entries.map((e) {
                final rep = e.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22.r,
                            backgroundImage: rep.avatarAsset != null ? AssetImage(rep.avatarAsset!) : null,
                            backgroundColor: const Color(0xFF3A3A3A),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: rep.name, fontsize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.redColorFF1D1D.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: Text(rep.role, style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', color: AppColors.redColorFF1D1D, fontWeight: FontWeight.w600)),
                                    ),
                                    SizedBox(width: 6.w),
                                    Icon(Icons.access_time, color: AppColors.secondaryTextColor, size: 11.r),
                                    SizedBox(width: 2.w),
                                    Text('Updated ${rep.updatedDate}', style: TextStyle(fontSize: 9.sp, fontFamily: 'Poppins', color: AppColors.secondaryTextColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: 'Current Rate', fontsize: 10.sp, color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                              CustomText(text: '${rep.currentRate}%', fontsize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => c.updateRate(e.key),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, color: AppColors.blackColor, size: 14.r),
                                  SizedBox(width: 4.w),
                                  Text('Update Rate', style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            )),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}