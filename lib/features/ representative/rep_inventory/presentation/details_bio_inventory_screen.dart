import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/details_bio_inventory_controller.dart';

class DetailsBioInventoryScreen extends StatelessWidget {
  const DetailsBioInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DetailsBioInventoryController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              SizedBox(height: 12.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back_ios,
                        color: AppColors.primaryTextColor, size: 18.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'Biological Details',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Item Image
              Container(
                width: double.infinity,
                height: 180.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2121),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/biological.png',
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 20.h),

              // General Information Card
              _SectionCard(
                title: 'General Information',
                badge: 'In Stock',
                children: [
                  _InfoRow(
                    iconPath: 'assets/icons/itemhome.svg',
                    label: 'Item Name',
                    value: c.item['name'],
                  ),
                  SizedBox(height: 12.h),
                  _InfoRow(
                    iconPath: 'assets/icons/lotnumber.svg',
                    label: 'Lot Number',
                    value: c.item['lotNumber'],
                  ),
                  SizedBox(height: 12.h),
                  _InfoRow(
                    iconPath: 'assets/icons/quantity.svg',
                    label: 'Quantity',
                    value: c.item['quantity'],
                  ),
                  SizedBox(height: 12.h),
                  _InfoRow(
                    iconPath: 'assets/icons/calendar.svg',
                    label: 'Expiry Date',
                    value: c.item['expiryDate'],
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Location & Logistics Card
              _SectionCard(
                title: 'Location & Logistics',
                children: [
                  _InfoRow(
                    iconPath: 'assets/icons/vendor.svg',
                    label: 'Vendor',
                    value: c.item['vendor'],
                  ),
                  SizedBox(height: 12.h),
                  _InfoRow(
                    iconPath: 'assets/icons/map.svg',
                    label: 'Location',
                    value: c.item['location'],
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Additional Notes
              _SectionCard(
                title: 'Additional Notes',
                children: [
                  CustomText(
                    text: c.item['notes'],
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                    textHeight: 1.5,
                  ),
                ],
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}


class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String? badge;

  const _SectionCard({
    required this.title,
    required this.children,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              if (badge != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: CustomText(
                    text: badge!,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4CAF50),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _InfoRow({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: const Color(0xFF1AC8DB).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 16.r,
                height: 16.r,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          CustomText(
            text: label,
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          const Spacer(),
          CustomText(
            text: value,
            fontsize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
