import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
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
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                              color: AppColors.primaryTextColor,
                              size: 20.r),
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
                    return _NewJobsBody(c: c);
                  case DriverJobTab.active:
                    return _ActiveJobsBody(c: c);
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

// ── Shimmer card placeholder ──────────────────────────────────────────────────

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        height: 130.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

Widget _buildShimmerList() {
  return ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    itemCount: 4,
    itemBuilder: (_, __) => const _ShimmerCard(),
  );
}

Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined,
            color: AppColors.secondaryTextColor, size: 48.r),
        SizedBox(height: 12.h),
        CustomText(
          text: message,
          fontsize: 14.sp,
          color: AppColors.secondaryTextColor,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// ── New Jobs ──────────────────────────────────────────────────────────────────

class _NewJobsBody extends StatelessWidget {
  final DriverJobController c;

  const _NewJobsBody({required this.c});

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
          child: Obx(() {
            if (c.isLoading.value) return _buildShimmerList();
            if (c.newJobs.isEmpty) {
              return RefreshIndicator(
                onRefresh: c.fetchJobs,
                color: AppColors.primaryColor,
                child: ListView(
                  children: [
                    SizedBox(height: 80.h),
                    _buildEmptyState('No new jobs available'),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: c.fetchJobs,
              color: AppColors.primaryColor,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: c.newJobs.length,
                itemBuilder: (ctx, i) {
                  final job = c.newJobs[i];
                  return NewJobCard(
                    job: job,
                    onTap: () async {
                      await c.fetchJobDetail(job.id);
                      if (context.mounted) {
                        context.pushNamed(
                            AppRoutes.newDeliveryDetailsScreen);
                      }
                    },
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Active Jobs ───────────────────────────────────────────────────────────────

class _ActiveJobsBody extends StatelessWidget {
  final DriverJobController c;

  const _ActiveJobsBody({required this.c});

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
          child: Obx(() {
            if (c.isLoading.value) return _buildShimmerList();
            if (c.activeJobs.isEmpty) {
              return RefreshIndicator(
                onRefresh: c.fetchJobs,
                color: AppColors.primaryColor,
                child: ListView(
                  children: [
                    SizedBox(height: 80.h),
                    _buildEmptyState('No active jobs'),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: c.fetchJobs,
              color: AppColors.primaryColor,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: c.activeJobs.length,
                itemBuilder: (ctx, i) {
                  final job = c.activeJobs[i];
                  return ActiveJobCard(
                    job: job,
                    onNavigate: () => context.pushNamed(
                      AppRoutes.driverMapScreen,
                      extra: job.id,
                    ),
                    onTap: () async {
                      await c.fetchJobDetail(job.id);
                      if (context.mounted) {
                        context.pushNamed(
                            AppRoutes.driverJobDetailsScreen);
                      }
                    },
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Completed Jobs ────────────────────────────────────────────────────────────

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
          child: Obx(() {
            if (c.isLoading.value) return _buildShimmerList();
            if (c.completedJobs.isEmpty) {
              return RefreshIndicator(
                onRefresh: c.fetchJobs,
                color: AppColors.primaryColor,
                child: ListView(
                  children: [
                    SizedBox(height: 80.h),
                    _buildEmptyState('No completed jobs'),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: c.fetchJobs,
              color: AppColors.primaryColor,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: c.completedJobs.length,
                itemBuilder: (ctx, i) =>
                    CompletedJobCard(job: c.completedJobs[i]),
              ),
            );
          }),
        ),
      ],
    );
  }
}
