import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/physicians_controller.dart';
import '../domain/model/physician_model.dart';
import 'add_physicians_screen.dart';
import 'physicions_profile_screen.dart';
import 'widgets/physician_card.dart';

class PhysiciansScreen extends StatelessWidget {
  const PhysiciansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PhysiciansController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        titleSpacing: 8.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'Physicians',
              fontsize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: 'Manage doctors & surgeries',
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(right: 24.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: SvgPicture.asset('assets/icons/drawer.svg'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: c.scrollController,
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
        child: Column(
          children: [

            Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2121),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 18.r,
                    height: 18.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextFormField(
                      onChanged: c.onSearch,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by name or practice',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            GestureDetector(
              onTap: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddPhysicianScreen(),
                  ),
                );
                if (result == true) c.refresh();
              },
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF137FEC),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 18.r),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Add Physician',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            Obx(() {
              if (c.isLoading.value) {
                return Column(
                  children: List.generate(
                    5,
                    (_) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: const _PhysicianCardShimmer(),
                    ),
                  ),
                );
              }

              if (c.physicians.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: Column(
                    children: [
                      Icon(Icons.person_search,
                          color: AppColors.secondaryTextColor, size: 48.r),
                      SizedBox(height: 12.h),
                      CustomText(
                        text: 'No physicians found',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  ...c.physicians.map((p) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: PhysicianCard(
                          physician: p,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PhysicianProfileScreen(physician: p),
                            ),
                          ),
                          onAddSurgeries: () {},
                          onEdit: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddPhysicianScreen(physician: p),
                              ),
                            );
                            if (result == true) c.refresh();
                          },
                          onDelete: () => _confirmDelete(context, c, p),
                        ),
                      )),
                  if (c.isLoadingMore.value)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: const _LoadMoreIndicator(),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, PhysiciansController c, PhysicianModel p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E2121),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: CustomText(
          text: 'Delete Physician',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
        ),
        content: CustomText(
          text: 'Are you sure you want to delete ${p.fullName}?',
          fontsize: 13.sp,
          color: AppColors.secondaryTextColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText(
              text: 'Cancel',
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              c.deletePhysician(p.id);
            },
            child: CustomText(
              text: 'Delete',
              fontsize: 13.sp,
              color: const Color(0xFFFF4D4F),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhysicianCardShimmer extends StatelessWidget {
  const _PhysicianCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2E2E),
      highlightColor: const Color(0xFF3A3E3E),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2121),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 12.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 10.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
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

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2E2E),
      highlightColor: const Color(0xFF3A3E3E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 8.r,
            height: 8.r,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 8.r,
            height: 8.r,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
