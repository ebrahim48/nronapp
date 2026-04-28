import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/%20representative/shipment/presentation/widgets/shipment_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/shipments_controller.dart';
import 'job_details_screen.dart';


class ShipmentsListScreen extends StatefulWidget {
  const ShipmentsListScreen({super.key});

  @override
  State<ShipmentsListScreen> createState() => _ShipmentsListScreenState();
}

class _ShipmentsListScreenState extends State<ShipmentsListScreen> {
  final _controller = ShipmentsController();
  final _searchController = TextEditingController();

  static const _tabs = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.menu,
                color: AppColors.primaryTextColor, size: 22.r),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Column(
            children: [
              Container(
                color: const Color(0xFF1E2427),
                child: Row(
                  children: List.generate(_tabs.length, (i) {
                    final selected = _controller.selectedTabIndex == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _controller.setTab(i),
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
              ),
              SizedBox(height: 12.h),
              Center(
                child: Container(
                  width: 345.w,
                  height: 1,
                  color: const Color(0xFFD4D4D4),
                ),
              ),
              SizedBox(height: 12.h),

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
                          onChanged: _controller.setSearch,
                          decoration: InputDecoration(
                            hintText: 'Search by PO#, Surgeon, or facility',
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

              // ── List ──────────────────────────────────────────────────────
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
              Expanded(
                child: _controller.filteredShipments.isEmpty
                    ? Center(
                  child: CustomText(
                    text: 'No shipments found',
                    color: AppColors.secondaryTextColor,
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _controller.filteredShipments.length,
                  itemBuilder: (_, i) {
                    final s = _controller.filteredShipments[i];
                    return ShipmentCard(
                      shipment: s,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailsScreen(shipment: s),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}