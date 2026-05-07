import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipments_list_controller.dart';
import '../model/shipment_model.dart';
import 'job_details_screen.dart';
import 'widgets/shipment_card.dart';

class ShipmentsListScreen extends StatefulWidget {
  const ShipmentsListScreen({super.key});

  @override
  State<ShipmentsListScreen> createState() => _ShipmentsListScreenState();
}

class _ShipmentsListScreenState extends State<ShipmentsListScreen> {
  late final ShipmentsListController _ctrl;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  static const _tabs = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ShipmentsListController());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    Get.delete<ShipmentsListController>(force: true);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _ctrl.fetchShipments();
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
          text: 'Shipments',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Column(
        children: [
          // ── Tabs ──
          Obx(() => Container(
                color: const Color(0xFF1E2427),
                child: Row(
                  children: List.generate(_tabs.length, (i) {
                    final selected = _ctrl.selectedTabIndex.value == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _ctrl.setTab(i),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selected
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: CustomText(
                            text: _tabs[i],
                            fontsize: 13.sp,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? AppColors.primaryColor
                                : AppColors.secondaryTextColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )),

          SizedBox(height: 12.h),
          Center(
            child: Container(
              width: 345.w,
              height: 1,
              color: const Color(0xFFD4D4D4),
            ),
          ),
          SizedBox(height: 12.h),

          // ── Search ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: AppColors.dotButtonInactiveColor, width: 0.6),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  Icon(Icons.search,
                      color: AppColors.secondaryTextColor, size: 18.r),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: AppColors.primaryTextColor,
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                      ),
                      onChanged: _ctrl.setSearch,
                      decoration: InputDecoration(
                        hintText: 'Search by job name, company...',
                        hintStyle: TextStyle(
                          color: AppColors.secondaryTextColor,
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'Recent Shipments',
                fontsize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // ── List ──
          Expanded(
            child: Obx(() {
              if (_ctrl.isLoading.value) return _shimmer();
              if (_ctrl.shipments.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No shipments found',
                    color: AppColors.secondaryTextColor,
                  ),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _ctrl.shipments.length +
                    (_ctrl.isLoadingMore.value ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i == _ctrl.shipments.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    );
                  }
                  final s = _ctrl.shipments[i];
                  return ShipmentCard(
                    shipment: s,
                    onTap: () => _openDetails(context, s),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, ShipmentModel s) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JobDetailsScreen(id: s.id)),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
