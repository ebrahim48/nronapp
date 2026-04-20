import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/driver_online_banner.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/driver_state_card.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/job_request_card.dart';
import 'package:nron_app/features/driver/driver_home/presentation/widgets/location_prompt_card.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/driver_home_controller.dart';


class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

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
        child: SingleChildScrollView(
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
                          text: c.driverName.value,
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

              SizedBox(height: 16.h),

              const DriverOnlineBanner(),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'New Job Requests',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  Obx(() => CustomText(
                    text: '${c.availableJobs} available',
                    fontsize: 12.sp,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.start,
                  )),
                ],
              ),

              SizedBox(height: 10.h),

              Obx(() => Column(
                children: c.jobRequests
                    .map(
                      (job) => JobRequestCard(
                    job: job,
                    onTap: () => context.pushNamed(AppRoutes.jobDetailsScreen),
                  ),
                )
                    .toList(),
              )),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}