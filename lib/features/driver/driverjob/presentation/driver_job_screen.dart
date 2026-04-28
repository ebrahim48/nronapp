import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/active_job_card.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/completed_job_card.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/completed_period_filter.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/job_tab_bar.dart';
import 'package:nron_app/features/driver/driverjob/presentation/widgets/new_job_card.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/driver_job_controller.dart';
import '../model/driver_job_model.dart';


class DriverJobsScreen extends StatelessWidget {
  const DriverJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DriverJobController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'My Jobs',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(Icons.notifications_outlined,
                              color: AppColors.primaryTextColor, size: 20.r),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const JobsTabBar(),
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: Obx(() {
                switch (c.selectedTab.value) {
                  case DriverJobTab.newJobs:
                    return _NewJobsBody(c: c, context: context);
                  case DriverJobTab.active:
                    return _ActiveJobsBody(c: c, context: context);
                  case DriverJobTab.completed:
                    return _CompletedJobsBody(c: c);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewJobsBody extends StatelessWidget {
  final DriverJobController c;
  final BuildContext context;

  const _NewJobsBody({required this.c, required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Available Jobs',
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              Obx(() => CustomText(
                text: '${c.newJobCount} jobs',
                fontsize: 12.sp,
                color: AppColors.primaryColor,
                textAlign: TextAlign.start,
              )),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: c.newJobs.length,
            itemBuilder: (ctx, i) => NewJobCard(
              job: c.newJobs[i],
              onTap: () => context.pushNamed(AppRoutes.newDeliveryDetailsScreen),
              onAccept: c.acceptNewJob,
              onDecline: c.declineNewJob,
            ),
          )),
        ),
      ],
    );
  }
}

class _ActiveJobsBody extends StatelessWidget {
  final DriverJobController c;
  final BuildContext context;

  const _ActiveJobsBody({required this.c, required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Active Jobs',
                fontsize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              Obx(() => CustomText(
                text: '${c.activeJobCount} jobs',
                fontsize: 12.sp,
                color: AppColors.primaryColor,
                textAlign: TextAlign.start,
              )),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: c.activeJobs.length,
            itemBuilder: (ctx, i) => ActiveJobCard(
              job: c.activeJobs[i],
              onNavigate: c.navigateJob,
              onTap: () => context.pushNamed(AppRoutes.driverJobDetailsScreen),
            ),
          )),
        ),
      ],
    );
  }
}

class _CompletedJobsBody extends StatelessWidget {
  final DriverJobController c;

  const _CompletedJobsBody({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const CompletedPeriodFilter(),
        ),
        SizedBox(height: 14.h),
        Expanded(
          child: Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: c.completedJobs.length,
            itemBuilder: (ctx, i) =>
                CompletedJobCard(job: c.completedJobs[i]),
          )),
        ),
      ],
    );
  }
}