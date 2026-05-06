import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/details_bio_inventory_controller.dart';

class DetailsBioInventoryScreen extends StatelessWidget {
  final String id;
  const DetailsBioInventoryScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DetailsBioInventoryController());
    WidgetsBinding.instance.addPostFrameCallback((_) => c.loadDetail(id));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (c.isLoading.value) {
            return Shimmer.fromColors(
              baseColor: const Color(0xFF2A2A2A),
              highlightColor: const Color(0xFF3A3A3A),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                child: Column(
                  children: List.generate(
                    4,
                    (_) => Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                Container(
                  width: double.infinity,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: c.imageUrl.value.startsWith('http')
                      ? Image.network(
                          c.imageUrl.value,
                          width: double.infinity,
                          height: 180.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                        )
                      : _ImagePlaceholder(),
                ),

                SizedBox(height: 20.h),

                _SectionCard(
                  title: 'General Information',
                  badge: c.status.value.isEmpty ? null : c.status.value,
                  children: [
                    _InfoRow(
                      iconPath: 'assets/icons/itemhome.svg',
                      label: 'Item Name',
                      value: c.name.value,
                    ),
                    SizedBox(height: 12.h),
                    _InfoRow(
                      iconPath: 'assets/icons/lotnumber.svg',
                      label: 'Lot Number',
                      value: c.lotNumber.value,
                    ),
                    SizedBox(height: 12.h),
                    _InfoRow(
                      iconPath: 'assets/icons/quantity.svg',
                      label: 'Quantity',
                      value: c.quantity.value,
                    ),
                    SizedBox(height: 12.h),
                    _InfoRow(
                      iconPath: 'assets/icons/calendar.svg',
                      label: 'Expiry Date',
                      value: c.expiryDate.value,
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                _SectionCard(
                  title: 'Location & Logistics',
                  children: [
                    _InfoRow(
                      iconPath: 'assets/icons/vendor.svg',
                      label: 'Vendor',
                      value: c.vendor.value,
                    ),
                    SizedBox(height: 12.h),
                    _InfoRow(
                      iconPath: 'assets/icons/map.svg',
                      label: 'Location',
                      value: c.location.value,
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                _SectionCard(
                  title: 'Additional Notes',
                  children: [
                    CustomText(
                      text: c.notes.value.isEmpty ? '—' : c.notes.value,
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
          );
        }),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.biotech_outlined,
          size: 48.r, color: const Color(0xFF3A3A3A)),
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
            text: value.isEmpty ? '—' : value,
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
