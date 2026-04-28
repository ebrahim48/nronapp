import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/manager/managershipment/presentation/widgets/shipment_card.dart';
import 'package:nron_app/features/manager/managershipment/presentation/widgets/state_card.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipmentcontroller.dart';


class ManagerShipmentsScreen extends StatelessWidget {
  const ManagerShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ShipmentController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const ManagerAppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: CustomText(
            text: 'Shipments',
            fontsize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
        ),
        actions: [
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: SvgPicture.asset('assets/icons/drawer.svg'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            // Stats 2x2
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    ShipmentStatCard(
                      label: 'Pending Jobs',
                      value: c.pendingJobs.value.toString().padLeft(2, '0'),
                      valueColor: AppColors.primaryTextColor,
                    ),
                    SizedBox(width: 12.w),
                    ShipmentStatCard(
                      label: 'Driver',
                      value: c.drivers.value.toString().padLeft(2, '0'),
                      valueColor: AppColors.warningColor,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    ShipmentStatCard(
                      label: 'In Transit',
                      value: c.inTransit.value.toString().padLeft(2, '0'),
                      valueColor: AppColors.primaryColor,
                    ),
                    SizedBox(width: 12.w),
                    ShipmentStatCard(
                      label: 'Delivered',
                      value: c.delivered.value.toString().padLeft(2, '0'),
                      valueColor: const Color(0xFF1DB954),
                    ),
                  ],
                ),
              ],
            )),

            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Active Shipments',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: () {},
                  child: CustomText(
                    text: 'View All',
                    fontsize: 13.sp,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Obx(() => Column(
              children: c.activeShipments
                  .map(
                    (s) => ActiveShipmentCard(
                  shipment: s,
                  onTap: () => context.push(AppRoutes.jobReviewScreen),
                ),
              )
                  .toList(),
            )),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}