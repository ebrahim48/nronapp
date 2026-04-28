import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_card.dart';
import 'package:nron_app/features/%20representative/all_surgeries/presentation/widgets/surgery_search_bar.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../../appdrawer/app_drawer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../controller/surgery_controller.dart';

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

            // Search bar
            const SurgerySearchBar(),

            SizedBox(height: 12.h),

            // Add Surgery button
            CustomButton(
              title: 'Add Surgery',
              onpress: () => context.push(AppRoutes.addSurgeryScreen),
              color: const Color(0xFF1A6EFF),
              titlecolor: AppColors.primaryTextColor,
              fontWeight: FontWeight.w600,
              prefixIcon: Icon(Icons.add,
                  color: AppColors.primaryTextColor, size: 18.r),
            ),

            SizedBox(height: 16.h),

            // List
            Expanded(
              child: Obx(() {
                final list = c.filteredSurgeries;
                if (list.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No surgeries found',
                      fontsize: 14.sp,
                      color: AppColors.secondaryTextColor,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: list.length,
                  itemBuilder: (context, i) => SurgeryCard(
                    surgery: list[i],
                    onTap: () => context.push(AppRoutes.surgeryDetailScreen),
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