import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/inventory_widgets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/rep_inventory_controller.dart';


class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(InventoryController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'My Inventory',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          // Drawer / hamburger icon
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/drawer.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    InventoryStatCard(
                      iconPath: 'assets/icons/implantsinventory.svg',
                      label: 'Serialized Implants',
                      value: c.serializedImplants.value.toString(),
                    ),
                    SizedBox(width: 12.w),
                    InventoryStatCard(
                      iconPath: 'assets/icons/implantsinventory.svg',
                      label: 'Total  Trays',
                      value: c.totalTrays.value.toString(),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    InventoryStatCard(
                      iconPath: 'assets/icons/implantsinventory.svg',
                      label: 'Bio Inventory',
                      value: c.bioInventory.value.toString(),
                    ),
                    SizedBox(width: 12.w),
                    InventoryStatCard(
                      iconPath: 'assets/icons/implantsinventory.svg',
                      label: 'Low Stock Alart',
                      value: c.lowStockAlert.value.toString(),
                    ),
                  ],
                ),
              ],
            )),

            SizedBox(height: 24.h),

            StartReceivingButton(onTap: c.startReceivingSession),

            SizedBox(height: 24.h),

            InventorySearchBar(
              onSearch: c.onSearch,
              onFilter: c.openFilter,
            ),

            SizedBox(height: 24.h),

            Obx(() => InventoryTabRow(
              activeIndex: c.activeTab.value,
              tabs: c.tabs,
              onSelect: c.selectTab,
            )),

            SizedBox(height: 24.h),

            Obx(() => c.isEmpty
                ? Column(
              children: [
                SizedBox(height: 16.h),

                const Center(child: InventoryEmptyState()),

                SizedBox(height: 32.h),

                Center(
                  child: ViewFullListButton(onTap: c.viewFullList),
                ),
              ],
            )
                : Column(
              children: c.inventoryItems
                  .map((item) => _InventoryListItem(item: item))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }
}

class _InventoryListItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _InventoryListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/implantsinventory.svg',
            width: 24.r,
            height: 24.r,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item['name'] ?? '',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: item['serial'] ?? '',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}