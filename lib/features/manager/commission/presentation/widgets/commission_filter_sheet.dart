import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/manager_commission_controller.dart';
import '../../model/manager_commission_model.dart';

class CommissionFilterSheet extends StatelessWidget {
  const CommissionFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CommissionFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerCommissionController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Filter by Territory & Rep',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: 'Adjust parameters for the commission audit ledger',
                    fontsize: 11.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close,
                    color: AppColors.primaryTextColor, size: 22.r),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          CustomText(
            text: 'Representative Selection',
            fontsize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 8.h),

          Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: TextField(
              onChanged: (v) => c.repSearchQuery.value = v,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                  color: AppColors.primaryTextColor),
              decoration: InputDecoration(
                hintText: 'Search Sale ID or Rep',
                hintStyle: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.secondaryTextColor),
                prefixIcon: Icon(Icons.search,
                    color: AppColors.secondaryTextColor, size: 18.r),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 13.h),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Bill Status',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: c.selectedBillStatus.value ==
                            CommissionBillStatus.all,
                        onTap: () => c.selectedBillStatus.value =
                            CommissionBillStatus.all,
                      ),
                      SizedBox(width: 8.w),
                      _FilterChip(
                        label: 'Open',
                        isSelected: c.selectedBillStatus.value ==
                            CommissionBillStatus.open,
                        onTap: () => c.selectedBillStatus.value =
                            CommissionBillStatus.open,
                      ),
                      SizedBox(width: 8.w),
                      _FilterChip(
                        label: 'Closed',
                        isSelected: c.selectedBillStatus.value ==
                            CommissionBillStatus.closed,
                        onTap: () => c.selectedBillStatus.value =
                            CommissionBillStatus.closed,
                      ),
                    ],
                  )),

                  SizedBox(height: 16.h),

                  CustomText(
                    text: 'Payment Status',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: c.selectedPaymentStatus.value ==
                            CommissionPaymentStatus.all,
                        onTap: () => c.selectedPaymentStatus.value =
                            CommissionPaymentStatus.all,
                      ),
                      SizedBox(width: 8.w),
                      _FilterChip(
                        label: 'Paid',
                        isSelected: c.selectedPaymentStatus.value ==
                            CommissionPaymentStatus.paid,
                        onTap: () => c.selectedPaymentStatus.value =
                            CommissionPaymentStatus.paid,
                      ),
                      SizedBox(width: 8.w),
                      _FilterChip(
                        label: 'Unpaid',
                        isSelected: c.selectedPaymentStatus.value ==
                            CommissionPaymentStatus.unpaid,
                        onTap: () => c.selectedPaymentStatus.value =
                            CommissionPaymentStatus.unpaid,
                      ),
                    ],
                  )),

                  SizedBox(height: 16.h),

                  CustomText(
                    text: 'Territory Selection',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 3.5,
                    children: c.territories.map((t) {
                      final isSelected =
                          c.selectedTerritory.value == t;
                      return GestureDetector(
                        onTap: () => c.toggleTerritory(t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : const Color(0xFF3A3A3A),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              t,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.blackColor
                                    : AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: c.resetFilters,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.redColorFF1D1D,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  c.applyFilters();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFF3A3A3A),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.blackColor
                : AppColors.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}