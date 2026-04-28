import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/personal_info_row.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/profile_header.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/profile_state_row.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/settings_section_card.dart';
import 'package:nron_app/features/%20representative/settingsprofile/presentation/widgets/settings_tile.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../appdrawer/app_drawer.dart';
import '../controller/setting_controller.dart';


class SettingProfileScreen extends StatelessWidget {
  const SettingProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingsController());
    final profile = c.userProfile;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Setting & Profile',
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            CustomText(
              text: 'Manage your account and preferences',
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
              textAlign: TextAlign.start,
            ),
          ],
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
              height: 1, color: const Color(0xFF3A3A3A), thickness: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            ProfileHeaderWidget(profile: profile),

            SizedBox(height: 20.h),

            ProfileStatsRow(profile: profile, showRating: false),

            SizedBox(height: 16.h),

            SettingsSectionCard(
              iconPath: 'assets/icons/physician.svg',
              title: 'Personal Information',
              onEditTap: () {},
              child: Column(
                children: [
                  PersonalInfoRow(label: 'Email', value: profile.email),
                  PersonalInfoRow(label: 'Phone', value: profile.phone),
                  PersonalInfoRow(
                      label: 'Territory', value: profile.territory),
                  PersonalInfoRow(
                      label: 'Employee ID',
                      value: profile.employeeId,
                      isLast: true),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            SettingsSectionCard(
              iconPath: 'assets/icons/physician.svg',
              title: 'Settings & Support',
              onEditTap: () {},
              child: Column(
                children: c.settingsTiles.asMap().entries.map((e) {
                  final tile = e.value;
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: e.key < c.settingsTiles.length - 1
                            ? 8.h
                            : 0),
                    child: SettingsTile(
                      iconPath: tile.iconPath,
                      title: tile.title,
                      subtitle: tile.subtitle,
                      onTap: () => context.push(tile.route),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 28.h),

            GestureDetector(
              onTap: c.logout,
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                      color: AppColors.redColorFF1D1D, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout,
                        color: AppColors.redColorFF1D1D, size: 18.r),
                    SizedBox(width: 8.w),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: AppColors.redColorFF1D1D,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            CustomText(
              text: 'APP VERSION 1.0.0',
              fontsize: 11.sp,
              color: AppColors.secondaryTextColor,
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}