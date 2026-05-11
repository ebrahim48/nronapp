import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/driver_online_banner.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/driver_state_card.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/job_request_card.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/location_prompt_card.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/driver_home_controller.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat cards shimmer
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Section title shimmer
          Container(
            height: 18.h,
            width: 160.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 12.h),
          // Job cards shimmer
          ...List.generate(
            3,
            (_) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontsize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        CustomText(
          text: subtitle,
          fontsize: 12.sp,
          color: AppColors.primaryColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _emptyState(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: CustomText(
        text: message,
        fontsize: 13.sp,
        color: AppColors.secondaryTextColor,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DriverHomeController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.chatbotScreen),
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: Icon(Icons.smart_toy_outlined,
            color: AppColors.blackColor, size: 24.r),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: c.fetchHome,
          color: AppColors.primaryColor,
          backgroundColor: const Color(0xFF1E2121),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),


                Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundImage:
                          const AssetImage('assets/images/profile.jpg'),
                      backgroundColor: const Color(0xFF3A3A3A),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Good Morning,',
                            fontsize: 11.sp,
                            color: AppColors.secondaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                          Obx(() => CustomText(
                                text: c.driverName.value.isNotEmpty
                                    ? c.driverName.value
                                    : 'Driver',
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              )),
                        ],
                      ),
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

                // SizedBox(height: 16.h),
                //
                // const DriverOnlineBanner(),

                SizedBox(height: 16.h),


                Obx(() {
                  if (c.showLocationPrompt.value) {
                    return Column(
                      children: [
                        const LocationPromptCard(),
                        SizedBox(height: 16.h),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),


                Obx(() {
                  if (c.isLoading.value) return _buildShimmer();

                  final data = c.homeData.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          DriverStatCard(stat: c.stats[0]),
                          SizedBox(width: 12.w),
                          DriverStatCard(stat: c.stats[1]),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          DriverStatCard(stat: c.stats[2]),
                          SizedBox(width: 12.w),
                          DriverStatCard(stat: c.stats[3]),
                        ],
                      ),

                      SizedBox(height: 20.h),


                      _sectionHeader(
                        'Active Jobs',
                        '${data.active} active',
                      ),
                      SizedBox(height: 10.h),
                      data.activeJobs.isEmpty
                          ? _emptyState('No active jobs')
                          : Column(
                              children: data.activeJobs
                                  .map((job) => JobRequestCard(
                                        job: job,
                                        onTap: () {
                                          c.selectJob(job);
                                          context.pushNamed(
                                              AppRoutes.jobDetailsScreen);
                                        },
                                      ))
                                  .toList(),
                            ),

                      SizedBox(height: 20.h),

                      _sectionHeader(
                        'Completed Today',
                        '${data.completed} done',
                      ),
                      SizedBox(height: 10.h),
                      data.completedToday.isEmpty
                          ? _emptyState('No completed jobs today')
                          : Column(
                              children: data.completedToday
                                  .map((job) => JobRequestCard(
                                        job: job,
                                        onTap: () {
                                          c.selectJob(job);
                                          context.pushNamed(
                                              AppRoutes.jobDetailsScreen);
                                        },
                                      ))
                                  .toList(),
                            ),

                      SizedBox(height: 20.h),

                      _sectionHeader(
                        'New Job Requests',
                        '${c.availableJobs} available',
                      ),
                      SizedBox(height: 10.h),
                      data.newJobRequests.isEmpty
                          ? _emptyState('No new job requests')
                          : Column(
                              children: data.newJobRequests
                                  .map((job) => JobRequestCard(
                                        job: job,
                                        onTap: () {
                                          c.selectJob(job);
                                          context.pushNamed(
                                              AppRoutes.jobDetailsScreen);
                                        },
                                      ))
                                  .toList(),
                            ),

                      SizedBox(height: 24.h),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
