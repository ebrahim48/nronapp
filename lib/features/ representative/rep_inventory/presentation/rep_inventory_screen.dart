import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../appdrawer/app_drawer.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/inventory_widgets.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/rep_inventory_controller.dart';
import '../model/implant_model.dart';


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
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
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
          } else if (c.tabs[activeTabIndex] == 'Implants') {
            context.pushNamed(AppRoutes.addImplantScreen);
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
              width: 32.r,
              height: 32.r,
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
            Obx(() {
              if (c.isLoadingStats.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Container(height: 80.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)))),
                          SizedBox(width: 12.w),
                          Expanded(child: Container(height: 80.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)))),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(child: Container(height: 80.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)))),
                          SizedBox(width: 12.w),
                          Expanded(child: Container(height: 80.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)))),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      InventoryStatCard(
                        iconPath: 'assets/icons/implantsinventory.svg',
                        label: 'Serialized Implants',
                        value: c.serializedImplants.value.toString(),
                        onTap: () => context.pushNamed(AppRoutes.serializedImplantsScreen),
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
                        label: 'Low Stock Alert',
                        value: c.lowStockAlert.value.toString(),
                      ),
                    ],
                  ),
                ],
              );
            }),

            SizedBox(height: 24.h),

            StartReceivingButton(onTap: () => context.pushNamed(AppRoutes.receivingSessionScreen)),

            SizedBox(height: 12.h),

            GestureDetector(
              onTap: () => context.pushNamed(AppRoutes.missingInstrumentHistoryScreen),
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2121),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, color: AppColors.primaryColor, size: 18.r),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Missing Instrument History',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

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

            Obx(() {
              if (c.isLoadingList.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: Column(
                    children: List.generate(
                      5,
                      (_) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        height: 110.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (c.isEmpty) {
                return Column(
                  children: [
                    SizedBox(height: 16.h),
                    const Center(child: InventoryEmptyState()),
                    SizedBox(height: 32.h),
                    Center(child: ViewFullListButton(onTap: c.viewFullList)),
                  ],
                );
              }
              return Column(
                children: c.inventoryItems.map((item) {
                  final tabName = c.tabs[c.activeTab.value];
                  if (tabName == 'Trays') {
                    return _TrayListItem(item: item);
                  }
                  if (tabName == 'Bio') {
                    return _BioListItem(item: item);
                  }
                  return _InventoryListItem(
                    item: item,
                    onDelete: () => _showDeleteDialog(context, c, item['id']?.toString() ?? ''),
                    onEdit: () {
                      final implant = ImplantModel(
                        id: item['id']?.toString() ?? '',
                        serialNumber: item['serial']?.toString() ?? '',
                        name: item['name']?.toString() ?? '',
                        lotNumber: item['lot']?.toString() ?? '',
                        material: item['material']?.toString() ?? '',
                        systemType: item['systemType']?.toString() ?? '',
                        vendor: item['vendor']?.toString() ?? '',
                        status: item['status']?.toString() ?? '',
                        facility: item['location']?.toString() ?? '',
                        recipientEmail: item['email']?.toString() ?? '',
                      );
                      context.pushNamed(AppRoutes.updateImplantScreen, extra: implant);
                    },
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, InventoryController c, String id) {
  showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF252525),
      title: const Text(
        'Delete Implant',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        'Are you sure you want to delete this implant? This action cannot be undone.',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontFamily: 'Poppins',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel',
              style: TextStyle(color: Colors.white54, fontFamily: 'Poppins')),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete',
              style: TextStyle(
                  color: Color(0xFFFF4B4B),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  ).then((confirmed) {
    if (confirmed == true) c.deleteImplant(id);
  });
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
    final imageUrl = item['image']?.toString() ?? '';
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.trayDetailsScreen, extra: item['id']?.toString() ?? ''),
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
            child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 72.r,
                  height: 72.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _TrayPlaceholder(size: 72.r),
                )
              : _TrayPlaceholder(size: 72.r),
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
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _InventoryListItem({required this.item, required this.onDelete, required this.onEdit});

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
                      onTap: widget.onDelete,
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
                      onTap: widget.onEdit,
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
                onTap: () => context.pushNamed(AppRoutes.implantDetailsScreen, extra: item['id']?.toString() ?? ''),
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
                              onTap: () => context.pushNamed(
                                AppRoutes.implantDetailsScreen,
                                extra: item['id']?.toString() ?? '',
                              ),
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

class _TrayPlaceholder extends StatelessWidget {
  final double size;
  const _TrayPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(Icons.medical_services_outlined, color: Colors.white24, size: size * 0.4),
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
      onTap: () => context.pushNamed(AppRoutes.detailsBioInventoryScreen, extra: item['id']?.toString() ?? ''),
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