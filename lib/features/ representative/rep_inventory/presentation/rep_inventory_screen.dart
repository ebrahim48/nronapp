import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../appdrawer/app_drawer.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/inventory_widgets.dart';
import '../../../../core/config/app-routes/app_routes.dart';
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
      drawer: const AppDrawer(),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: CustomText(
          text: 'My Inventory',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: SizedBox(
                width: 42.r,
                height: 42.r,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/drawer.svg',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Obx(() {
        final activeTabIndex = c.activeTab.value;
        return GestureDetector(
        onTap: () {
          if (c.tabs[activeTabIndex] == 'Trays') {
            context.pushNamed(AppRoutes.newTrayScreen);
          } else if (c.tabs[activeTabIndex] == 'Bio') {
            context.pushNamed(AppRoutes.addBioInventoryScreen);
          }
        },
        child: Container(
          width: 56.r,
          height: 56.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1AC8DB),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/tapbutton.svg',
              width: 24.r,
              height: 24.r,
            ),
          ),
        ),
      );
      }),

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
                      label: 'Total Trays',
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
                Center(child: ViewFullListButton(onTap: c.viewFullList)),
              ],
            )
                : Column(
              children: c.inventoryItems.map((item) {
                final tabName = c.tabs[c.activeTab.value];
                if (tabName == 'Trays') {
                  return _TrayListItem(item: item);
                }
                if (tabName == 'Bio') {
                  return _BioListItem(item: item);
                }
                return _InventoryListItem(item: item);
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }
}

class _TrayListItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _TrayListItem({required this.item});

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return const Color(0xFF4CAF50);
      case 'in stock':
        return AppColors.primaryColor;
      case 'shipped':
        return const Color(0xFFFF9800);
      default:
        return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.trayDetailsScreen),
      child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              'assets/images/tray.jpg',
              width: 72.r,
              height: 72.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: item['name'] ?? '',
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: _statusColor(item['status']).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: _statusColor(item['status'])),
                      ),
                      child: CustomText(
                        text: item['status'] ?? '',
                        fontsize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: _statusColor(item['status']),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.more_vert,
                      size: 18.r,
                      color: const Color(0xFFACACAC),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: item['serial'] ?? '',
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.r,
                      color: AppColors.secondaryTextColor,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CustomText(
                        text: item['location'] ?? '',
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _InventoryListItem extends StatefulWidget {
  final Map<String, dynamic> item;

  const _InventoryListItem({required this.item});

  @override
  State<_InventoryListItem> createState() => _InventoryListItemState();
}

class _InventoryListItemState extends State<_InventoryListItem> {
  double _offsetX = 0;

  double get _actionWidth => 105.w;

  void _onDragUpdate(DragUpdateDetails d) {
    setState(() {
      _offsetX = (_offsetX + d.delta.dx).clamp(-_actionWidth, 0.0);
    });
  }

  void _onDragEnd(DragEndDetails d) {
    setState(() {
      _offsetX = _offsetX < -_actionWidth / 2 ? -_actionWidth : 0;
    });
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return const Color(0xFF4CAF50);
      case 'in stock':
        return AppColors.primaryColor;
      case 'shipped':
        return const Color(0xFFFF9800);
      default:
        return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          height: 110.h,
          child: Stack(
            children: [
              // Swipe actions
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: _actionWidth / 2,
                        color: const Color(0xFFFD9499),
                        alignment: Alignment.center,
                        child: CustomText(
                          text: 'Delete',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: _actionWidth / 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D5ED),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          text: 'Edit',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Card
              Positioned(
                left: _offsetX,
                right: -_offsetX,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: Container(
                    width: double.infinity,
                    height: 110.h,
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A25292A),
                          offset: Offset(0.5, 1),
                          blurRadius: 1,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top: icon + name/serial/badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/shoulder.jpg',
                                width: 56.r,
                                height: 56.r,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          text: item['name'] ?? '',
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTextColor,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 3.h),
                                        decoration: BoxDecoration(
                                          color: _statusColor(item['status'])
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color: _statusColor(item['status']),
                                          ),
                                        ),
                                        child: CustomText(
                                          text: item['status'] ?? '',
                                          fontsize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: _statusColor(item['status']),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text:
                                        '${item['serial'] ?? ''} • ${item['material'] ?? ''}',
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
                        // Divider — full width, 310px effective
                        const Divider(
                          color: Color(0xFF3A3A3A),
                          height: 1,
                          thickness: 1,
                        ),
                        // Bottom: location + details
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12.r,
                              color: AppColors.secondaryTextColor,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: CustomText(
                                text: item['location'] ?? '',
                                fontsize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  CustomText(
                                    text: 'Details',
                                    fontsize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 14.r,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BioListItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _BioListItem({required this.item});

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return const Color(0xFF4CAF50);
      case 'in stock':
        return AppColors.primaryColor;
      case 'shipped':
        return const Color(0xFFFF9800);
      default:
        return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.detailsBioInventoryScreen),
      child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD4D4D4), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: item['name'] ?? '',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ),
              CustomText(
                text: item['expiry'] ?? '',
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: 'Lot-${item['serial'] ?? ''}',
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          Divider(color: const Color(0xFF3A3A3A), height: 1, thickness: 0.5),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.r,
                color: AppColors.secondaryTextColor,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: CustomText(
                  text: item['location'] ?? '',
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    CustomText(
                      text: 'Details',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16.r,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}