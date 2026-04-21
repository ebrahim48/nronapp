import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/password_screen.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/personal_info_screen.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/driver_avatar.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/performane_banner.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/profile_state_cards.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/settings_menu_cards.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/total_earnings_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/profile_controller.dart';


class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final _ctrl = ProfileController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          final p = _ctrl.profile;
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back_ios_new,
                              color: AppColors.primaryTextColor,
                              size: 18.r),
                        ),
                        SizedBox(width: 12.w),
                        CustomText(
                          text: 'Profile',
                          fontsize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),


                  Row(
                    children: [
                      DriverAvatar(
                        initial: p.avatarInitial,
                        isOnline: p.isAvailable,
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: p.name,
                              fontsize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: 'ID: ${p.driverId}',
                              fontsize: 12.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const PersonalInfoScreen(),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomText(
                              text: 'Edit',
                              fontsize: 12.sp,
                              color: AppColors.secondaryTextColor,
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.edit_outlined,
                                color: AppColors.secondaryTextColor,
                                size: 14.r),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 9.r,
                          height: 9.r,
                          decoration: BoxDecoration(
                            color: p.isAvailable
                                ? const Color(0xFF4ADE80)
                                : AppColors.secondaryTextColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomText(
                            text: 'Available for Jobs',
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Switch(
                          value: p.isAvailable,
                          onChanged: _ctrl.toggleAvailability,
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),

                  ProfileStatCards(
                    completedDeliveries: p.completedDeliveries,
                    successRate: p.successRate,
                  ),
                  SizedBox(height: 14.h),

                  TotalEarningsCard(
                    totalEarnings: p.totalEarnings,
                    onViewDetails: () {},
                  ),
                  SizedBox(height: 22.h),

                  CustomText(
                    text: 'Account',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                    bottom: 8.h,
                  ),
                  SettingsMenuCard(
                    items: [
                      SettingsMenuItem(
                        icon: Icons.person_outline,
                        label: 'Personal Information',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const PersonalInfoScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),

                  CustomText(
                    text: 'Settings & Support',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                    bottom: 8.h,
                  ),
                  SettingsMenuCard(
                    items: [
                      SettingsMenuItem(
                        icon: Icons.lock_outline,
                        label: 'Change Password',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ChangePasswordScreen(),
                          ),
                        ),
                      ),
                      SettingsMenuItem(
                        icon: Icons.credit_card_outlined,
                        label: 'Payment Methods',
                        onTap: () {
                          context.pushNamed(AppRoutes.paymentMethodsScreen);
                        },
                      ),
                      SettingsMenuItem(
                        icon: Icons.headset_mic_outlined,
                        label: 'Help & Support',
                        onTap: () {
                          context.pushNamed(AppRoutes.contactSupportScreen);
                        },
                      ),
                      SettingsMenuItem(
                        icon: Icons.grid_view_outlined,
                        label: 'Others',
                        onTap: () {
                          context.pushNamed(AppRoutes.othersScreen);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  const PerformanceBanner(progressValue: 0.75),
                  SizedBox(height: 14.h),

                  GestureDetector(
                    onTap: () => context.goNamed(AppRoutes.signInScreen),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A0A0A),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout,
                              color: Colors.redAccent, size: 18.r),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: 'Logout',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

