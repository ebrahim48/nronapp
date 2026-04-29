import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../controller/surgery_controller.dart';
import 'add_surgery_screen.dart';
import 'surgery_details_screen.dart';
import 'widgets/surgery_card.dart';
import 'widgets/surgery_search_bar.dart';

class AllSurgeriesScreen extends StatelessWidget {
  const AllSurgeriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SurgeryController());

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
          text: 'All Surgeries',
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
                    child: SvgPicture.asset('assets/icons/drawer.svg'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const SurgerySearchBar(),
            SizedBox(height: 12.h),
            CustomButton(
              title: 'Add Surgery',
              onpress: () async {
                c.clearForm();
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddSurgeryScreen()),
                );
                if (result == true) c.refresh();
              },
              color: const Color(0xFF1A6EFF),
              titlecolor: AppColors.primaryTextColor,
              fontWeight: FontWeight.w600,
              prefixIcon:
                  Icon(Icons.add, color: AppColors.primaryTextColor, size: 18.r),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 24.h),
                    itemCount: 5,
                    itemBuilder: (_, __) => const _SurgeryCardShimmer(),
                  );
                }
                if (c.surgeries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medical_services_outlined,
                            color: AppColors.secondaryTextColor, size: 48.r),
                        SizedBox(height: 12.h),
                        CustomText(
                          text: 'No surgeries found',
                          fontsize: 14.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: c.scrollController,
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: c.surgeries.length +
                      (c.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == c.surgeries.length) {
                      return const _SurgeryCardShimmer();
                    }
                    final s = c.surgeries[i];
                    return SurgeryCard(
                      surgery: s,
                      onTap: () async {
                        await c.fetchDetail(s.id);
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const SurgeryDetailScreen()),
                          );
                        }
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurgeryCardShimmer extends StatelessWidget {
  const _SurgeryCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2E2E),
      highlightColor: const Color(0xFF3A3E3E),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r)),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 12.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r)),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 10.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r)),
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
