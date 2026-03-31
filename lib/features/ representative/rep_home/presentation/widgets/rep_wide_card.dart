import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/rep_home_controller.dart';

class RepWideCard extends StatelessWidget {
  const RepWideCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RepHomeController>();

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Recent Activity',
              fontsize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            GestureDetector(
              onTap: () {},
              child: CustomText(
                text: 'View All',
                fontsize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryColor,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // ── Activity items ────────────────────────────────────────
        ...c.activities.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _ActivityItem(item: item),
        )),
      ],
    ));
  }
}

class _ActivityItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ActivityItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final isSuccess = item['status'] == 'Success';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A25292A),
            blurRadius: 1,
            offset: Offset(0.5, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Icon box ───────────────────────────────────────────────
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                item['iconType'] == 'check'
                    ? 'assets/icons/click.svg'
                    : 'assets/icons/dots.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // ── Title + subtitle ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item['title'],
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: item['subtitle'],
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  maxline: 2,
                  textHeight: 1.4,
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // ── Time + status badge ────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: item['time'],
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 6.h),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  // Success: #00D500 at 60% opacity | Pending: amber
                  color: isSuccess
                      ? const Color(0x9900D500)
                      : const Color(0xFFE6A817).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: item['status'],
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}