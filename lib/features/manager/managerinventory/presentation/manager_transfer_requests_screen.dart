import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_transfer_requets_controller.dart';

class ManagerTransferRequestsScreen extends StatelessWidget {
  const ManagerTransferRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerTransferRequestsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: AppColors.primaryTextColor, size: 18.r)),
        title: CustomText(text: 'Transfer Requests', fontsize: 16.sp,
            fontWeight: FontWeight.w600, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
        child: Column(
          children: [
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: c.filters.map((f) {
                  final isActive = c.selectedFilter.value == f;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () => c.selectFilter(f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 34.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: isActive ? AppColors.primaryColor : const Color(0xFF3A3A3A)),
                        ),
                        child: Center(
                          child: CustomText(text: f, fontsize: 13.sp,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              color: isActive ? Colors.black : AppColors.primaryTextColor,
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),

            SizedBox(height: 16.h),

            Obx(() => Column(
              children: c.filtered.map((r) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _TransferCard(item: r, onApprove: () => c.approve(r.id), onReject: () => c.reject(r.id)),
              )).toList(),
            )),
          ],
        ),
      ),
    );
  }
}

class _TransferCard extends StatelessWidget {
  final TransferRequestItem item;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _TransferCard({required this.item, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.r, height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(child: SvgPicture.asset('assets/icons/transferrequests.svg', width: 22.r, height: 22.r,
                    colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn))),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: item.itemName, fontsize: 14.sp,
                        fontWeight: FontWeight.w700, color: AppColors.primaryTextColor, textAlign: TextAlign.start),
                    SizedBox(height: 4.h),
                    Row(children: [
                      Icon(Icons.calendar_today_outlined, color: AppColors.secondaryTextColor, size: 11.r),
                      SizedBox(width: 4.w),
                      CustomText(text: item.date, fontsize: 11.sp, fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
                    ]),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6A817).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE6A817).withValues(alpha: 0.5)),
                ),
                child: CustomText(text: item.status.toUpperCase(), fontsize: 10.sp,
                    fontWeight: FontWeight.w700, color: const Color(0xFFE6A817), textAlign: TextAlign.center),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Divider(color: const Color(0xFF3A3A3A), thickness: 0.5, height: 1),
          SizedBox(height: 10.h),

          _InfoRow(icon: Icons.location_on_outlined, label: 'From:', value: item.from),
          SizedBox(height: 6.h),
          _InfoRow(icon: Icons.flag_outlined, label: 'To:', value: item.to, iconColor: const Color(0xFFEC0101)),
          SizedBox(height: 6.h),
          _InfoRow(icon: Icons.person_outline, label: 'Requested By:', value: item.requestedBy),
          SizedBox(height: 6.h),
          _InfoRow(icon: Icons.inventory_2_outlined, label: 'Batch:', value: item.batch),

          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onApprove,
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.check_circle_outline, color: Colors.black, size: 16.r),
                      SizedBox(width: 6.w),
                      CustomText(text: 'Approve', fontsize: 13.sp, fontWeight: FontWeight.w600,
                          color: Colors.black, textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: onReject,
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFEC0101)),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.cancel_outlined, color: const Color(0xFFEC0101), size: 16.r),
                      SizedBox(width: 6.w),
                      CustomText(text: 'Reject', fontsize: 13.sp, fontWeight: FontWeight.w600,
                          color: const Color(0xFFEC0101), textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({required this.icon, required this.label, required this.value, this.iconColor = const Color(0xFF888888)});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 14.r),
        SizedBox(width: 6.w),
        CustomText(text: label, fontsize: 12.sp, fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor, textAlign: TextAlign.start),
        SizedBox(width: 4.w),
        Expanded(child: CustomText(text: value, fontsize: 12.sp, fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor, textAlign: TextAlign.start)),
      ],
    );
  }
}