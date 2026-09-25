import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/managerinventory/presentation/widgets/manager_inventory_widgets.dart';
import '../../../../core/utils/app_colors.dart';
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
              child: SvgPicture.asset(
                'assets/icons/drawer.svg',
                width: 22.r,
                height: 22.r,
                colorFilter: const ColorFilter.mode(
                    AppColors.primaryTextColor, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _showCreateOptions(context),
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1AC8DB),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/plusicon.svg',
              width: 22.r,
              height: 22.r,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
        child: Column(
          children: [
            // Error banner
            Obx(() {
              if (c.errorMessage.value.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A1A),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFEC0101).withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: const Color(0xFFEC0101), size: 18.r),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: c.errorMessage.value,
                        fontsize: 11.sp,
                        color: const Color(0xFFEC0101),
                        textAlign: TextAlign.start,
                        maxline: 3,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: c.refresh,
                      child: Icon(Icons.refresh, color: AppColors.primaryColor, size: 20.r),
                    ),
                  ],
                ),
              );
            }),

            // ── Stats + Alert cards ──────────────────────────────────────
            Obx(() {
              if (c.isLoadingStats.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Column(
                    children: [
                      Row(children: [
                        _ShimmerCard(),
                        SizedBox(width: 12.w),
                        _ShimmerCard(),
                      ]),
                      SizedBox(height: 12.h),
                      Row(children: [
                        _ShimmerCard(),
                        SizedBox(width: 12.w),
                        _ShimmerCard(),
                      ]),
                      SizedBox(height: 12.h),
                      Row(children: [
                        _ShimmerCard(height: 120.h),
                        SizedBox(width: 12.w),
                        _ShimmerCard(height: 120.h),
                      ]),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Row(children: [
                    ManagerStatCard(
                      iconPath: 'assets/icons/managerinventory.svg',
                      label: 'Serialized Implants',
                      value: '${c.serializedImplants.value}',
                    ),
                    SizedBox(width: 12.w),
                    ManagerStatCard(
                      iconPath: 'assets/icons/managerinventory.svg',
                      label: 'Total Trays',
                      value: '${c.totalTrays.value}',
                    ),
                  ]),
                  SizedBox(height: 12.h),
                  Row(children: [
                    ManagerStatCard(
                      iconPath: 'assets/icons/managerinventory.svg',
                      label: 'Bio Inventory',
                      value: '${c.bioInventory.value}',
                    ),
                    SizedBox(width: 12.w),
                    ManagerStatCard(
                      iconPath: 'assets/icons/managerinventory.svg',
                      label: 'Low Stock Alert',
                      value: '${c.lowStockAlert.value}',
                      valueColor: c.lowStockAlert.value > 0
                          ? const Color(0xFFEC0101)
                          : Colors.white,
                    ),
                  ]),
                  SizedBox(height: 12.h),
                  Row(children: [
                    ManagerAlertCard(
                      iconPath: 'assets/icons/missingandtransfer.svg',
                      count: c.missingInstruments.value,
                      title: 'Missing Instrument',
                      subtitle:
                          'Inter-hospital logistics requiring manager approval to proceed.',
                      onTap: () =>
                          context.push(AppRoutes.managerMissingReportScreen),
                    ),
                    SizedBox(width: 12.w),
                    ManagerAlertCard(
                      iconPath: 'assets/icons/transferrequests.svg',
                      count: c.pendingTransferRequests.value,
                      title: 'Pending Transfer Requests',
                      subtitle:
                          'Inter-hospital logistics requiring manager approval to proceed.',
                      onTap: () =>
                          context.push(AppRoutes.managerTransferRequestsScreen),
                    ),
                  ]),
                ],
              );
            }),

            SizedBox(height: 16.h),

            // ── Distribution card (dynamic) ──────────────────────────────
            Obx(() {
              if (c.isLoadingStats.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Container(
                    height: 280.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                );
              }
              return InventoryDistributionCard(
                selectedLine: c.selectedProductLine.value,
                lines: c.productLines,
                total: c.distributionTotal.value,
                items: c.distributionItems.cast<Map<String, dynamic>>(),
                onChanged: (v) {
                  if (v != null) c.selectProductLine(v);
                },
              );
            }),

            SizedBox(height: 16.h),

            // ── Recent movement card (dynamic) ───────────────────────────
            Obx(() {
              if (c.isLoadingStats.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                );
              }
              return RecentMovementCard(
                activeTab: c.movementTab.value,
                data: c.activeChartData,
                days: c.activeChartLabels,
                onTabChange: c.selectMovementTab,
              );
            }),
          ],
        ),
      ),
    );
  }
}

void _showCreateOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E2121),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: 'Create New',
            fontsize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 16.h),
          _CreateOptionTile(
            icon: 'assets/icons/managerinventory.svg',
            label: 'Add Implant',
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.addImplantScreen);
            },
          ),
          SizedBox(height: 12.h),
          _CreateOptionTile(
            icon: 'assets/icons/managerinventory.svg',
            label: 'New Tray',
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.newTrayScreen);
            },
          ),
          SizedBox(height: 12.h),
          _CreateOptionTile(
            icon: 'assets/icons/managerinventory.svg',
            label: 'Add Bio Inventory',
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.addBioInventoryScreen);
            },
          ),
        ],
      ),
    ),
  );
}

class _CreateOptionTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _CreateOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF252929),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor, BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            CustomText(
              text: label,
              fontsize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.secondaryTextColor,
              size: 14.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double? height;
  const _ShimmerCard({this.height});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height ?? 90.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
