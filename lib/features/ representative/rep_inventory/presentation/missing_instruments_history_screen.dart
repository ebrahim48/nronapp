import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/%20representative/rep_inventory/presentation/widgets/missing_instrument_history_widgets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/missing_instrument_history_controller.dart';

class MissingInstrumentHistoryScreen extends StatelessWidget {
  const MissingInstrumentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MissingInstrumentHistoryController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryTextColor,
            size: 18.r,
          ),
        ),
        title: CustomText(
          text: 'Missing Instrument History',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            CustomText(
              text: 'Unresolved equipment issues tracking.',
              fontsize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 16.h),

            // ── Search bar ──
            MissingSearchBar(
              controller: c.searchController,
              onFilterTap: () => c.openFilter(context),
            ),

            SizedBox(height: 16.h),

            // ── Stats ──
            Obx(() => MissingStatsRow(
              total: c.totalCount.value,
              missing: c.missingCount.value,
            )),

            SizedBox(height: 20.h),

            // ── List ──
            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: const Color(0xFF2A2A2A),
                    highlightColor: const Color(0xFF3A3A3A),
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 32.h),
                      itemCount: 6,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, __) => Container(
                        height: 110.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  );
                }
                final items = c.filteredItems;
                if (items.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No records found.',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.only(bottom: 32.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) => MissingReportCard(
                    item: items[i],
                    onTap: () => c.openDetail(context, items[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}