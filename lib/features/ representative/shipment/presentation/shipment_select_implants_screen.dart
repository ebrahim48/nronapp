import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../rep_inventory/controller/implant_controller.dart';
import '../../rep_inventory/model/implant_model.dart';

class ShipmentSelectImplantsScreen extends StatefulWidget {
  final List<Map<String, String>> initialSelected;
  const ShipmentSelectImplantsScreen({
    super.key,
    this.initialSelected = const [],
  });

  @override
  State<ShipmentSelectImplantsScreen> createState() =>
      _ShipmentSelectImplantsScreenState();
}

class _ShipmentSelectImplantsScreenState
    extends State<ShipmentSelectImplantsScreen> {
  late final ImplantsController _ctrl;
  late final Set<String> _selectedIds;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ImplantsController(), tag: 'shipment_select');
    _selectedIds = Set<String>.from(
      widget.initialSelected
          .map((m) => m['product'] ?? '')
          .where((s) => s.isNotEmpty),
    );
  }

  @override
  void dispose() {
    Get.delete<ImplantsController>(tag: 'shipment_select', force: true);
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(String id) => setState(() {
        if (_selectedIds.contains(id)) {
          _selectedIds.remove(id);
        } else {
          _selectedIds.add(id);
        }
      });

  void _confirm() {
    final result = _selectedIds
        .map((id) => <String, String>{'product': id, 'productType': 'Implant'})
        .toList();
    Navigator.pop(context, result);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF00BCD4);
      case 'in_stock':
        return const Color(0xFF22C55E);
      case 'shipped':
        return const Color(0xFFE53935);
      default:
        return AppColors.secondaryTextColor;
    }
  }

  Color _statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF0D2E3A);
      case 'in_stock':
        return const Color(0xFF0D2E1A);
      case 'shipped':
        return const Color(0xFF3A0D0D);
      default:
        return const Color(0xFF252525);
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'in_stock':
        return 'In Stock';
      case 'shipped':
        return 'Shipped';
      default:
        return status.isNotEmpty ? status : 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        centerTitle: false,
        title: CustomText(
          text: 'Select Implants',
          fontsize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Column(
        children: [
          // ── Search ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 14.w),
                        Icon(Icons.search,
                            size: 18.r,
                            color: AppColors.secondaryTextColor),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.primaryTextColor,
                              fontFamily: 'Poppins',
                            ),
                            onChanged: _ctrl.setSearch,
                            decoration: InputDecoration(
                              hintText: 'Search name, serial number...',
                              hintStyle: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.secondaryTextColor,
                                fontFamily: 'Poppins',
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2121),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Icon(Icons.tune_rounded,
                      size: 20.r, color: AppColors.primaryTextColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // ── List ──
          Expanded(
            child: Obx(() {
              if (_ctrl.isLoading.value) return _shimmer();
              final items = _ctrl.filtered;
              if (items.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No implants found',
                    color: AppColors.secondaryTextColor,
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (_, i) {
                  final item = items[i];
                  final selected = _selectedIds.contains(item.id);
                  return _ImplantCard(
                    implant: item,
                    isSelected: selected,
                    statusLabel: _statusLabel(item.status),
                    statusColor: _statusColor(item.status),
                    statusBg: _statusBg(item.status),
                    onTap: () => _toggle(item.id),
                  );
                },
              );
            }),
          ),

          // ── Add Selected button ──
          Container(
            color: AppColors.backgroundColor,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
            child: GestureDetector(
              onTap: _selectedIds.isEmpty ? null : _confirm,
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  color: _selectedIds.isEmpty
                      ? AppColors.primaryColor.withValues(alpha: 0.4)
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Colors.black, size: 20.r),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Add Selected Items (${_selectedIds.length})',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => Container(
          height: 96.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}

class _ImplantCard extends StatelessWidget {
  final ImplantModel implant;
  final bool isSelected;
  final String statusLabel;
  final Color statusColor;
  final Color statusBg;
  final VoidCallback onTap;

  const _ImplantCard({
    required this.implant,
    required this.isSelected,
    required this.statusLabel,
    required this.statusColor,
    required this.statusBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFF3A3A3A),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Container(
                  width: 22.r,
                  height: 22.r,
                  margin: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : const Color(0xFF6A6A6A),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 14.r)
                      : null,
                ),
                SizedBox(width: 12.w),
                // Name + serial
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: implant.name.isNotEmpty
                            ? implant.name
                            : implant.systemType,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        text: implant.serialNumber.isNotEmpty
                            ? '${implant.serialNumber} • ${implant.material}'
                            : implant.material,
                        fontsize: 11.sp,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: CustomText(
                    text: statusLabel,
                    fontsize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            if (implant.facility.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xFF2E2E2E)),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 13.r,
                      color: AppColors.secondaryTextColor),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: CustomText(
                      text: implant.facility,
                      fontsize: 12.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
