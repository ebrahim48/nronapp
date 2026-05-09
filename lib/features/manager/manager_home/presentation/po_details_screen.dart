import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/manager/manager_home/presentation/widgets/po_status_timeline.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../manager_controller/manager_po_controller.dart';

class PODetailsScreen extends StatelessWidget {
  const PODetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManagerPOController>();

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
        title: Obx(() => CustomText(
              text: c.isLoadingDetail.value
                  ? 'Details'
                  : 'Details ${c.poDetail.poNumber}',
              fontsize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            )),
        centerTitle: false,
        actions: [
          Obx(() {
            final d = c.poDetail;
            if (c.isLoadingDetail.value || d.repName == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundImage: d.repAvatarAsset != null
                          ? AssetImage(d.repAvatarAsset!)
                          : null,
                      backgroundColor: const Color(0xFF3A3A3A),
                    ),
                    SizedBox(width: 6.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: d.repName!,
                          fontsize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(
                          text: 'REP',
                          fontsize: 8.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (c.isLoadingDetail.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 14.h),
              child: Container(
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: 16.w, vertical: 14.h),
          child: POStatusTimeline(items: c.poDetail.timeline),
        );
      }),
    );
  }
}
