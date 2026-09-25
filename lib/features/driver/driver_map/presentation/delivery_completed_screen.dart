import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../driver_bottomnavbar/controller/driver_man-nav_controller.dart';


class DeliveryCompletedScreen extends StatelessWidget {
  const DeliveryCompletedScreen({super.key});

  void _goToHome(BuildContext context, {int tab = 0}) {
    final nav = Get.isRegistered<DriverMainNavController>()
        ? Get.find<DriverMainNavController>()
        : Get.put(DriverMainNavController());
    nav.changePage(tab);
    context.go(AppRoutes.driverBottomNavBar);
  }

  @override
  Widget build(BuildContext context) {
    // This screen is reached via context.go (stack cleared), so system back
    // would close the app — send the driver home instead.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToHome(context);
      },
      child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90.r,
                height: 90.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF1DB954),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 46.r,
                ),
              ),

              SizedBox(height: 24.h),

              Text(
                'Delivery Completed!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                ),
              ),

              SizedBox(height: 8.h),

              CustomText(
                text: 'Earnings added to your account',
                fontsize: 13.sp,
                color: AppColors.secondaryTextColor,
              ),

              SizedBox(height: 36.h),

              CustomButton(
                title: 'View Earnings',
                loading: false,
                onpress: () => _goToHome(context, tab: 3),
                titlecolor: AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

