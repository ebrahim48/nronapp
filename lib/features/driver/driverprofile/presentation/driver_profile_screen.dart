import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nron_app/core/config/app-routes/app_routes.dart';
import 'package:nron_app/core/helpers/prefs_helper.dart';
import 'package:nron_app/core/utils/app_colors.dart';
import 'package:nron_app/core/custom_widgets/custom_text.dart';
import 'package:nron_app/features/driver/driverprofile/controller/driver_profile_api_controller.dart';
import 'package:nron_app/features/driver/driverprofile/model/user_profile_model.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/password_screen.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/personal_info_screen.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/settings_menu_cards.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  late final DriverProfileApiController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(DriverProfileApiController());
  }

  @override
  void dispose() {
    Get.delete<DriverProfileApiController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (_ctrl.isLoading.value && _ctrl.profile.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final p = _ctrl.profile.value;
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── AppBar row ────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Profile',
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                        textAlign: TextAlign.start,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PersonalInfoScreen(isSetupMode: false),
                          ),
                        ).then((_) => _ctrl.fetchProfile()),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined,
                                  color: AppColors.primaryColor, size: 14.r),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: 'Edit',
                                fontsize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Profile header ────────────────────────────────────────
                _ProfileHeader(p: p, ctrl: _ctrl),
                SizedBox(height: 16.h),

                // ── Stats row ─────────────────────────────────────────────
                _StatsRow(p: p),
                SizedBox(height: 14.h),

                // ── Info card ─────────────────────────────────────────────
                if (p != null) _InfoCard(p: p),
                if (p != null) SizedBox(height: 14.h),

                // ── Account ───────────────────────────────────────────────
                _SectionLabel('Account'),
                SettingsMenuCard(
                  items: [
                    SettingsMenuItem(
                      icon: Icons.person_outline,
                      label: 'Personal Information',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PersonalInfoScreen(isSetupMode: false),
                        ),
                      ).then((_) => _ctrl.fetchProfile()),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // ── Settings & Support ────────────────────────────────────
                _SectionLabel('Settings & Support'),
                SettingsMenuCard(
                  items: [
                    SettingsMenuItem(
                      icon: Icons.lock_outline,
                      label: 'Change Password',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      ),
                    ),
                    SettingsMenuItem(
                      icon: Icons.credit_card_outlined,
                      label: 'Payment Methods',
                      onTap: () =>
                          context.pushNamed(AppRoutes.paymentMethodsScreen),
                    ),
                    SettingsMenuItem(
                      icon: Icons.headset_mic_outlined,
                      label: 'Help & Support',
                      onTap: () =>
                          context.pushNamed(AppRoutes.contactSupportScreen),
                    ),
                    SettingsMenuItem(
                      icon: Icons.grid_view_outlined,
                      label: 'Others',
                      onTap: () => context.pushNamed(AppRoutes.othersScreen),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),

                // ── Logout ────────────────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    await PrefsHelper.remove('auth_token');
                    await PrefsHelper.remove('auth_refresh_token');
                    await PrefsHelper.remove('user_role');
                    AppRoutes.goRouter.go(AppRoutes.roleSelection);
                  },
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
      }),
    );
  }
}

// ── Profile header ────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final UserProfileModel? p;
  final DriverProfileApiController ctrl;

  const _ProfileHeader({required this.p, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final name = p?.fullName ?? '';
    final designation = p?.designation ?? '';
    final profileUrl = p?.profileUrl;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'D';

    return Row(
      children: [
        // Avatar
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    width: 3),
              ),
              child: ClipOval(
                child: profileUrl != null && profileUrl.isNotEmpty
                    ? Image.network(profileUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: CustomText(
                            text: initial,
                            fontsize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ))
                    : Center(
                        child: CustomText(
                          text: initial,
                          fontsize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
              ),
            ),
            Obx(() => Positioned(
                  bottom: 2.r,
                  right: 2.r,
                  child: Container(
                    width: 14.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      color: ctrl.isAvailable.value
                          ? const Color(0xFF4ADE80)
                          : AppColors.secondaryTextColor,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.backgroundColor, width: 2),
                    ),
                  ),
                )),
          ],
        ),
        SizedBox(width: 14.w),

        // Name & designation
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name.isNotEmpty ? name : 'Driver',
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              if (designation.isNotEmpty) ...[
                SizedBox(height: 3.h),
                CustomText(
                  text: designation,
                  fontsize: 12.sp,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
              SizedBox(height: 8.h),
              // Availability toggle
              Obx(() => GestureDetector(
                    onTap: () =>
                        ctrl.toggleAvailability(!ctrl.isAvailable.value),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: ctrl.isAvailable.value
                            ? const Color(0xFF0F2A1A)
                            : const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: ctrl.isAvailable.value
                              ? const Color(0xFF2E6B47)
                              : const Color(0xFF3A3A3A),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7.r,
                            height: 7.r,
                            decoration: BoxDecoration(
                              color: ctrl.isAvailable.value
                                  ? const Color(0xFF4ADE80)
                                  : AppColors.secondaryTextColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          CustomText(
                            text: ctrl.isAvailable.value
                                ? 'Available'
                                : 'Offline',
                            fontsize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: ctrl.isAvailable.value
                                ? const Color(0xFF4ADE80)
                                : AppColors.secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final UserProfileModel? p;
  const _StatsRow({required this.p});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.wallet_outlined,
            label: 'Earnings',
            value: '\$${(p?.totalEarnings ?? 0).toInt()}',
            color: const Color(0xFF4ADE80),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCard(
            icon: Icons.local_shipping_outlined,
            label: 'Deliveries',
            value: '${p?.totalDeliveries ?? 0}',
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCard(
            icon: Icons.verified_outlined,
            label: 'Success',
            value: '${(p?.successRate ?? 0).toInt()}%',
            color: const Color(0xFF60A5FA),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16.r),
          SizedBox(height: 8.h),
          CustomText(
            text: value,
            fontsize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 2.h),
          CustomText(
            text: label,
            fontsize: 10.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final UserProfileModel p;
  const _InfoCard({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Information',
            fontsize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 12.h),
          _InfoRow(icon: Icons.email_outlined, label: 'Email', value: p.email),
          if (p.bio?.isNotEmpty == true)
            _InfoRow(
                icon: Icons.info_outline, label: 'Bio', value: p.bio!),
          if (p.address?.isNotEmpty == true)
            _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: p.address!),
          if (p.currentAddress?.isNotEmpty == true)
            _InfoRow(
                icon: Icons.my_location_outlined,
                label: 'Current Location',
                value: p.currentAddress!,
                isLast: true),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14.r, color: AppColors.secondaryTextColor),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: label,
                    fontsize: 10.sp,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 1.h),
                  CustomText(
                    text: value,
                    fontsize: 13.sp,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 6.h),
          Divider(color: const Color(0xFF3A3A3A), height: 1, thickness: 0.5),
          SizedBox(height: 10.h),
        ],
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: text,
        fontsize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryTextColor,
        textAlign: TextAlign.start,
      ),
    );
  }
}
