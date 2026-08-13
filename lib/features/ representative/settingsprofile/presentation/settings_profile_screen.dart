import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/custom_widgets/custom_text_field.dart';
import '../../../../core/custom_widgets/role_aware_bottom_bar.dart';
import '../../appdrawer/app_drawer.dart';
import '../controller/setting_controller.dart';
import 'widgets/password_field.dart';
import 'widgets/personal_info_row.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_section_card.dart';
import 'widgets/settings_tile.dart';

class SettingProfileScreen extends StatelessWidget {
  /// When shown as a standalone (drawer-pushed) route it gets its own
  /// role-aware bottom nav bar. When embedded in a shell (rep tab 4) the
  /// shell already provides the bar, so this stays false to avoid a double bar.
  final bool standalone;

  const SettingProfileScreen({super.key, this.standalone = false});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      bottomNavigationBar:
          standalone ? const RoleAwareBottomBar() : null,
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
      body: Obx(() {
        if (c.isLoadingProfile.value && c.profile.value == null) {
          return _ProfileShimmer();
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              ProfileHeaderWidget(c: c),

              SizedBox(height: 20.h),

              // ── Personal Information ──────────────────────────────────
              Obx(() {
                final p = c.profile.value;
                return SettingsSectionCard(
                  iconPath: 'assets/icons/physician.svg',
                  title: 'Personal Information',
                  onEditTap: () {
                    c.fullNameCtrl.text = p?.fullName ?? '';
                    c.bioCtrl.text = p?.bio ?? '';
                    c.designationCtrl.text = p?.designation ?? '';
                    _showEditProfileSheet(context, c);
                  },
                  child: Column(
                    children: [
                      PersonalInfoRow(
                          label: 'Email', value: p?.email ?? '-'),
                      PersonalInfoRow(
                          label: 'Designation',
                          value: p?.designation?.isNotEmpty == true
                              ? p!.designation!
                              : '-'),
                      PersonalInfoRow(
                          label: 'Bio',
                          value: p?.bio?.isNotEmpty == true
                              ? p!.bio!
                              : '-'),
                      PersonalInfoRow(
                          label: 'Territory',
                          value: p?.territory?.isNotEmpty == true
                              ? p!.territory!
                              : '-'),
                      PersonalInfoRow(
                          label: 'Employee ID',
                          value: p?.employeeId?.isNotEmpty == true
                              ? p!.employeeId!
                              : '-',
                          isLast: true),
                    ],
                  ),
                );
              }),

              SizedBox(height: 14.h),

              // ── Settings & Support ────────────────────────────────────
              SettingsSectionCard(
                iconPath: 'assets/icons/physician.svg',
                title: 'Settings & Support',
                child: Column(
                  children: c.settingsTiles.asMap().entries.map((e) {
                    final tile = e.value;
                    final isLast = e.key == c.settingsTiles.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
                      child: SettingsTile(
                        iconPath: tile.iconPath,
                        title: tile.title,
                        subtitle: tile.subtitle,
                        fallbackIcon: tile.fallbackIcon,
                        onTap: tile.route.isEmpty
                            ? () => _showChangePasswordSheet(context, c)
                            : () => context.push(tile.route),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 28.h),

              // ── Logout ────────────────────────────────────────────────
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
        );
      }),
    );
  }

  // ── Edit Profile Bottom Sheet ─────────────────────────────────────────────
  void _showEditProfileSheet(BuildContext context, SettingsController c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(c: c),
    );
  }

  // ── Change Password Bottom Sheet ──────────────────────────────────────────
  void _showChangePasswordSheet(BuildContext context, SettingsController c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangePasswordSheet(c: c),
    );
  }
}

// ── Edit Profile Sheet ────────────────────────────────────────────────────────
class _EditProfileSheet extends StatelessWidget {
  final SettingsController c;
  const _EditProfileSheet({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2427),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: 'Edit Profile',
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 20.h),

              // Profile image picker
              Obx(() {
                final picked = c.selectedImage.value;
                final url = c.profile.value?.profileUrl;
                ImageProvider? img;
                if (picked != null) {
                  img = FileImage(picked);
                } else if (url != null && url.isNotEmpty) {
                  img = NetworkImage(url);
                }
                return Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: const Color(0xFF3A3A3A),
                        backgroundImage: img,
                        child: img == null
                            ? Icon(Icons.person,
                                size: 36.r,
                                color: AppColors.secondaryTextColor)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: c.pickImage,
                          child: Container(
                            width: 24.r,
                            height: 24.r,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF1E2427), width: 2),
                            ),
                            child: Icon(Icons.camera_alt,
                                color: AppColors.blackColor, size: 12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 20.h),

              _SheetLabel('Full Name'),
              CustomTextField(
                controller: c.fullNameCtrl,
                hintText: 'Enter full name',
              ),
              SizedBox(height: 8.h),

              _SheetLabel('Designation'),
              CustomTextField(
                controller: c.designationCtrl,
                hintText: 'Enter designation / company',
              ),
              SizedBox(height: 8.h),

              _SheetLabel('Bio'),
              CustomTextField(
                controller: c.bioCtrl,
                hintText: 'Enter bio',
                maxLine: 3,
              ),
              SizedBox(height: 20.h),

              Obx(() => CustomButton(
                    title: 'Save Changes',
                    loading: c.isUpdatingProfile.value,
                    onpress: c.updateProfile,
                    titlecolor: AppColors.blackColor,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Change Password Sheet ─────────────────────────────────────────────────────
class _ChangePasswordSheet extends StatelessWidget {
  final SettingsController c;
  const _ChangePasswordSheet({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2427),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Center(
              child: CustomText(
                text: 'Change Password',
                fontsize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 20.h),

            PasswordField(
              controller: c.currentPasswordController,
              hint: 'Current password',
              isVisible: c.showCurrentPassword,
              onToggle: () => c.showCurrentPassword.toggle(),
            ),
            PasswordField(
              controller: c.newPasswordController,
              hint: 'New password',
              isVisible: c.showNewPassword,
              onToggle: () => c.showNewPassword.toggle(),
            ),
            PasswordField(
              controller: c.confirmPasswordController,
              hint: 'Confirm new password',
              isVisible: c.showConfirmPassword,
              onToggle: () => c.showConfirmPassword.toggle(),
            ),

            SizedBox(height: 8.h),

            Obx(() => CustomButton(
                  title: 'Save Change',
                  loading: c.isChangingPassword.value,
                  onpress: c.savePasswordChange,
                  titlecolor: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: CustomText(
        text: text,
        fontsize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}

// ── Profile loading shimmer ───────────────────────────────────────────────────
class _ProfileShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Container(
                width: 92.r,
                height: 92.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Name
            Center(
              child: Container(
                  width: 160.w, height: 18.h, color: const Color(0xFF2A2A2A)),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Container(
                  width: 100.w, height: 14.h, color: const Color(0xFF2A2A2A)),
            ),
            SizedBox(height: 24.h),
            // Personal info card
            Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 14.h),
            // Settings card
            Container(
              width: double.infinity,
              height: 160.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
