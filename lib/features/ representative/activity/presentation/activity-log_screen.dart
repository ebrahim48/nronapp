import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/actitvity_log_controller.dart';
import 'widgets/activity_log_widgets.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ActivityLogController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 24.w,
        title: CustomText(
          text: 'Activity Log',
          fontsize: 22.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 24.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: SvgPicture.asset(
                  'assets/icons/drawer.svg',
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                CustomText(
                  text: 'MODULE:',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: c.modules.map((m) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ActivityFilterChip(
                            label: m,
                            isActive: c.selectedModule.value == m,
                            onTap: () => c.selectModule(m),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                CustomText(
                  text: 'RANGE:',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(width: 10.w),
                Obx(() => Row(
                  children: c.ranges.map((r) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ActivityFilterChip(
                        label: r,
                        isActive: c.selectedRange.value == r,
                        onTap: () => c.selectRange(r),
                      ),
                    );
                  }).toList(),
                )),
              ],
            ),

            SizedBox(height: 16.h),

            Obx(() => Column(
              children: c.filtered.map((item) {
                Widget card;

                switch (item.type) {
                  case ActivityType.inventory:
                    card = ActivityInventoryCard(
                      title: item.data['title'],
                      subtitle: item.data['subtitle'],
                      date: item.data['date'],
                      facility: item.data['facility'],
                      onDetails: () {},
                    );
                    break;

                  case ActivityType.sale:
                    card = ActivitySaleCard(
                      date: item.data['date'],
                      status: item.data['status'],
                      serial: item.data['serial'],
                      doctor: item.data['doctor'],
                      facility: item.data['facility'],
                      surgeryAmount: item.data['surgeryAmount'],
                      totalAmount: item.data['totalAmount'],
                    );
                    break;

                  case ActivityType.implant:
                    card = ActivityImplantCard(
                      name: item.data['name'],
                      serial: item.data['serial'],
                      material: item.data['material'],
                      status: item.data['status'],
                      facility: item.data['facility'],
                      imagePath: item.data['imagePath'],
                      onDetails: () {},
                    );
                    break;

                  case ActivityType.billing:
                    card = ActivityBillingCard(
                      clinic: item.data['clinic'],
                      type: item.data['type'],
                      status: item.data['status'],
                      surgeon: item.data['surgeon'],
                      totalBill: item.data['totalBill'],
                    );
                    break;
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: card,
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }
}