import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/manager_commission_controller.dart';
import 'widgets/commission_table_row.dart';
import 'widgets/commission_filter_sheet.dart';

class CommissionListScreen extends StatelessWidget {
  const CommissionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerCommissionController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Commissions',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ),
      body: Column(
        children: [
          // ── Search ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: TextField(
                onChanged: (v) => c.listSearchQuery.value = v,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Search Sale ID or Rep',
                  hintStyle: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                      color: AppColors.secondaryTextColor),
                  prefixIcon: Icon(Icons.search,
                      color: AppColors.secondaryTextColor, size: 18.r),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                ),
              ),
            ),
          ),

          // ── Header ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Recent Commission List',
                  fontsize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: () => CommissionFilterSheet.show(context),
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2121),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/filter.svg',
                        width: 20.r,
                        height: 20.r,
                        colorFilter: const ColorFilter.mode(
                            AppColors.primaryTextColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // ── List ─────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (c.isLoadingList.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 5,
                    itemBuilder: (_, __) => Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      height: 160.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                );
              }

              if (c.filteredItems.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No commissions found.',
                    fontsize: 14.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: c.filteredItems.length,
                itemBuilder: (context, i) => CommissionTableRow(
                  item: c.filteredItems[i],
                  onTap: () async {
                    await c.fetchDetail(c.filteredItems[i].id);
                    if (context.mounted) {
                      context.push(AppRoutes.managerCommissionDetailScreen);
                    }
                  },
                ),
              );
            }),
          ),

          // ── Footer ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Showing ${c.filteredItems.length} of ${c.totalEntries} entries',
                      fontsize: 11.sp,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                    GestureDetector(
                      onTap: c.downloadCSV,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Download CSV',
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
