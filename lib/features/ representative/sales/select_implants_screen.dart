import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../core/custom_widgets/custom_button.dart';
import 'controller/sales_controller.dart';
import 'model/sales_model.dart';



class SelectImplantsScreen extends StatefulWidget {
  const SelectImplantsScreen({super.key});

  @override
  State<SelectImplantsScreen> createState() => _SelectImplantsScreenState();
}

class _SelectImplantsScreenState extends State<SelectImplantsScreen> {
  // 0 = Inventory Item, 1 = PO Item
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Get.find<SaleController>().fetchInventory();
  }

  Color _availabilityColor(ImplantAvailability a) {
    switch (a) {
      case ImplantAvailability.available:
        return const Color(0xFF1DB954);
      case ImplantAvailability.inStock:
        return AppColors.primaryColor;
      case ImplantAvailability.backordered:
        return AppColors.redColorFF1D1D;
    }
  }

  String _availabilityLabel(ImplantAvailability a) {
    switch (a) {
      case ImplantAvailability.available:
        return 'Available';
      case ImplantAvailability.inStock:
        return 'In Stock';
      case ImplantAvailability.backordered:
        return 'Backordered';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SaleController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Select product',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [


          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Row(
                children: [
                  _buildTabOption('Inventory Item', 0),
                  _buildTabOption('PO Item', 1),
                ],
              ),
            ),
          ),


          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(10.r),
                      border:
                      Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: TextField(
                      onChanged: (v) {
                        if (_selectedTab == 0) {
                          c.implantSearchQuery.value = v;
                        } else {
                          c.poSearchQuery.value = v;
                        }
                      },
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search name Serial number ...',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.secondaryTextColor,
                        ),
                        prefixIcon: Icon(Icons.search,
                            color: AppColors.secondaryTextColor,
                            size: 18.r),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 13.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Obx(() {
                  final hasFilter = _selectedTab == 0 && c.inventoryModelFilter.value.isNotEmpty;
                  return GestureDetector(
                    onTap: _selectedTab == 0
                        ? () => _showInventoryFilterSheet(c)
                        : null,
                    child: Container(
                      width: 46.r,
                      height: 46.r,
                      decoration: BoxDecoration(
                        color: hasFilter
                            ? AppColors.primaryColor.withOpacity(0.15)
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: hasFilter
                              ? AppColors.primaryColor
                              : const Color(0xFF3A3A3A),
                        ),
                      ),
                      child: Icon(Icons.tune,
                          color: hasFilter
                              ? AppColors.primaryColor
                              : AppColors.secondaryTextColor,
                          size: 20.r),
                    ),
                  );
                }),
              ],
            ),
          ),

          Expanded(
            child: _selectedTab == 0
                ? _buildInventoryList(c)
                : _buildPoList(c),
          ),


          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
            child: _selectedTab == 0
                ? Obx(() => CustomButton(
              title:
              '+ Add Selected Items (${c.selectedImplantCount})',
              onpress: () {
                c.confirmSelectedImplants();
                Navigator.pop(context);
              },
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ))
                : Obx(() => CustomButton(
              title: '+ Add Selected Items (${c.selectedPoCount})',
              onpress: () {
                c.confirmSelectedPoItems();
                Navigator.pop(context);
              },
              titlecolor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            )),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }



  String _poStatusLabel(ImplantAvailability a) {
    switch (a) {
      case ImplantAvailability.available: return 'Open';
      case ImplantAvailability.inStock: return 'Complete';
      case ImplantAvailability.backordered: return 'Lost';
    }
  }

  void _showInventoryFilterSheet(SaleController c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2427),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Obx(() {
        final current = c.inventoryModelFilter.value;
        const filters = ['', 'Implant', 'Tray', 'Bio'];
        const labels = ['All', 'Implant', 'Tray', 'Bio'];
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
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
              SizedBox(height: 18.h),
              CustomText(
                text: 'Filter by Type',
                fontsize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: List.generate(filters.length, (i) {
                  final isSelected = current == filters[i];
                  return GestureDetector(
                    onTap: () {
                      c.inventoryModelFilter.value = filters[i];
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0xFF3A3A3A),
                        ),
                      ),
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.blackColor
                              : AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabOption(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Colors.black
                  : AppColors.secondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildInventoryList(SaleController c) {
    return Obx(() {
      if (c.isLoadingInventory.value) {
        return _ShimmerList();
      }
      if (c.allImplants.isEmpty) {
        return Center(
          child: CustomText(
            text: 'No inventory items found.',
            fontsize: 14.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.center,
          ),
        );
      }
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        itemCount: c.filteredImplants.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final item = c.filteredImplants[index];
          final realIndex = c.allImplants.indexOf(item);
          return GestureDetector(
            onTap: () => c.toggleImplant(realIndex),
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: item.isSelected
                      ? AppColors.primaryColor
                      : const Color(0xFF3A3A3A),
                  width: item.isSelected ? 1.5 : 0.8,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CheckboxWidget(isSelected: item.isSelected),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: CustomText(
                                text: item.name,
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.productModel.isNotEmpty) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A2A2A),
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(color: const Color(0xFF3A3A3A)),
                                    ),
                                    child: Text(
                                      item.productModel,
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.secondaryTextColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                ],
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: _availabilityColor(item.availability)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    _availabilityLabel(item.availability),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: _availabilityColor(item.availability),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (item.serial.isNotEmpty || item.material.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: CustomText(
                              text: [item.serial, item.material]
                                  .where((s) => s.isNotEmpty)
                                  .join(' • '),
                              fontsize: 11.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        SizedBox(height: 6.h),
                        if (item.location.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: AppColors.secondaryTextColor,
                                  size: 13.r),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: CustomText(
                                  text: item.location,
                                  fontsize: 11.sp,
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
        },
      );
    });
  }


  Widget _buildPoList(SaleController c) {
    return Obx(() {
      if (c.isLoadingInventory.value) {
        return _ShimmerList();
      }
      if (c.allPoItems.isEmpty) {
        return Center(
          child: CustomText(
            text: 'No PO items found.',
            fontsize: 14.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.center,
          ),
        );
      }
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        itemCount: c.filteredPoItems.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final item = c.filteredPoItems[index];
          final realIndex = c.allPoItems.indexOf(item);
          return _buildPoFeeCard(item, realIndex, c);
        },
      );
    });
  }


  Widget _buildPoFeeCard(ImplantItem item, int i, SaleController c) {
    return GestureDetector(
      onTap: () => c.togglePoItem(i),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: item.isSelected ? AppColors.primaryColor : const Color(0xFF3A3A3A),
            width: item.isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CheckboxWidget(isSelected: item.isSelected),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PO Number + status badge + thumbnail
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: item.name,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: _availabilityColor(item.availability).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          _poStatusLabel(item.availability),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: _availabilityColor(item.availability),
                          ),
                        ),
                      ),
                      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.network(
                            item.imageUrl!,
                            width: 36.r,
                            height: 36.r,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Order type + amount
                  Row(
                    children: [
                      if (item.serial.isNotEmpty)
                        CustomText(
                          text: item.serial,
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      if (item.serial.isNotEmpty && item.totalAmount > 0)
                        CustomText(
                          text: '  •  ',
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      if (item.totalAmount > 0)
                        Text(
                          '\$${item.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                    ],
                  ),
                  // Products count
                  if (item.material.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    CustomText(
                      text: item.material,
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                  // Procedure date
                  if (item.location.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            color: AppColors.secondaryTextColor, size: 11.r),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: item.location,
                          fontsize: 11.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _CheckboxWidget extends StatelessWidget {
  final bool isSelected;
  const _CheckboxWidget({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.r,
      height: 22.r,
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : const Color(0xFF5A5A5A),
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, color: AppColors.blackColor, size: 14.r)
          : null,
    );
  }
}



class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        itemCount: 5,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (_, __) => Container(
          height: 88.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}