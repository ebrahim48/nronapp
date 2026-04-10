import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/manager/managerinventory/presentation/widgets/manager_inventory_widgets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_inventory_controller.dart';
import '../../appdrawer/app_drawer.dart';


class ManagerInventoryScreen extends StatelessWidget {
  const ManagerInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ManagerInventoryController());

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const ManagerAppDrawer(),
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 24.w,
        title: CustomText(
          text: 'My Inventory',
          fontsize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24.w),
            child: GestureDetector(
              onTap: () => scaffoldKey.currentState?.openDrawer(),
              child: SvgPicture.asset('assets/icons/drawer.svg',
                width: 22.r, height: 22.r,
                colorFilter: const ColorFilter.mode(AppColors.primaryTextColor, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
        child: Column(
          children: [
            Obx(() => Column(
              children: [
                Row(children: [
                  ManagerStatCard(iconPath: 'assets/icons/managerinventory.svg', label: 'Serialized Implants', value: '${c.serializedImplants.value}'),
                  SizedBox(width: 12.w),
                  ManagerStatCard(iconPath: 'assets/icons/managerinventory.svg', label: 'Total  Trays', value: '${c.totalTrays.value}'),
                ]),
                SizedBox(height: 12.h),
                Row(children: [
                  ManagerStatCard(iconPath: 'assets/icons/managerinventory.svg', label: 'Bio Inventory', value: '${c.bioInventory.value}'),
                  SizedBox(width: 12.w),
                  ManagerStatCard(iconPath: 'assets/icons/managerinventory.svg', label: 'Low Stock Alart', value: '${c.lowStockAlert.value}'),
                ]),
                SizedBox(height: 12.h),
                Row(children: [
                  ManagerAlertCard(
                    iconPath: 'assets/icons/missingandtransfer.svg',
                    count: c.missingCount.value,
                    title: 'Missing Instrument',
                    subtitle: 'Inter-hospital logistics requiring manager approval to proceed.',
                    onTap: () => context.push(AppRoutes.managerMissingReportScreen),
                  ),
                  SizedBox(width: 12.w),
                  ManagerAlertCard(
                    iconPath: 'assets/icons/transferrequests.svg',
                    count: c.pendingTransferCount.value,
                    title: 'Pending Transfer Requests',
                    subtitle: 'Inter-hospital logistics requiring manager approval to proceed.',
                    onTap: () => context.push(AppRoutes.managerTransferRequestsScreen),
                  ),
                ]),
              ],
            )),

            SizedBox(height: 16.h),

            Obx(() => InventoryDistributionCard(
              selectedLine: c.selectedProductLine.value,
              lines: c.productLines,
              items: c.distributionItems.cast<Map<String, dynamic>>(),
              onChanged: (v) { if (v != null) c.selectProductLine(v); },
            )),

            SizedBox(height: 16.h),

            Obx(() => RecentMovementCard(
              activeTab: c.movementTab.value,
              data: c.weeklyData,
              days: c.weekDays,
              onTabChange: c.selectMovementTab,
            )),
          ],
        ),
      ),
    );
  }
}