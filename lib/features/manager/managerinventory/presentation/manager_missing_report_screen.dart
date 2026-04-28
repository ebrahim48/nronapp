import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_missing_report_controller.dart';


class ManagerMissingReportScreen extends StatelessWidget {
  const ManagerMissingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerMissingReportController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: AppColors.primaryTextColor, size: 18.r)),
        title: CustomText(text: 'Missing Instrument Report', fontsize: 16.sp,
            fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/search.svg', width: 18.r, height: 18.r,
                            colorFilter: const ColorFilter.mode(AppColors.secondaryTextColor, BlendMode.srcIn)),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextFormField(
                            onChanged: c.onSearch,
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp, color: AppColors.primaryTextColor),
                            decoration: InputDecoration(
                              hintText: 'Search Tray ID or Facility...',
                              hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp, color: AppColors.secondaryTextColor),
                              border: InputBorder.none, isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 48.r, height: 48.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Center(child: SvgPicture.asset('assets/icons/drawer1.svg', width: 20.r, height: 20.r,
                      colorFilter: const ColorFilter.mode(AppColors.primaryTextColor, BlendMode.srcIn))),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Obx(() => Row(
              children: [
                _StatBox(label: 'Total', value: '${c.total.value}', valueColor: AppColors.primaryTextColor),
                SizedBox(width: 12.w),
                _StatBox(label: 'Missing', value: '${c.missing.value}', valueColor: const Color(0xFFEC0101)),
              ],
            )),

            SizedBox(height: 16.h),

            Obx(() => Column(
              children: c.filtered.map((r) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.managerReportDetailsScreen, extra: r),
                  child: _MissingReportCard(item: r),
                ),
              )).toList(),
            )),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatBox({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: label, fontsize: 12.sp, fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
            SizedBox(height: 4.h),
            CustomText(text: value, fontsize: 24.sp, fontWeight: FontWeight.w700,
                color: valueColor, textAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }
}

class _MissingReportCard extends StatelessWidget {
  final MissingReportItem item;
  const _MissingReportCard({required this.item});

  Color get _statusColor => item.status == 'Missing' ? const Color(0xFFEC0101) : const Color(0xFFE6A817);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              children: [
                _Badge(label: item.trayId, color: AppColors.primaryColor),
                SizedBox(width: 8.w),
                _Badge(label: item.status, color: _statusColor),
                const Spacer(),
                Icon(Icons.chevron_right, color: AppColors.secondaryTextColor, size: 18.r),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(text: item.facility, fontsize: 15.sp,
                  fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(item.reporterImage, width: 28.r, height: 28.r, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => CircleAvatar(radius: 14.r, backgroundColor: const Color(0xFF2A2A2A))),
                ),
                SizedBox(width: 8.w),
                Expanded(child: CustomText(text: item.reporter, fontsize: 13.sp,
                    fontWeight: FontWeight.w500, color: AppColors.primaryTextColor, textAlign: TextAlign.start)),
                CustomText(text: item.date, fontsize: 11.sp,
                    fontWeight: FontWeight.w400, color: AppColors.secondaryTextColor, textAlign: TextAlign.end),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: CustomText(text: label, fontsize: 11.sp, fontWeight: FontWeight.w600,
          color: color, textAlign: TextAlign.center),
    );
  }
}