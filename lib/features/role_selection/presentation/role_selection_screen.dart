import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app-routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/custom_widgets/custom_text.dart';
import '../../../global/custom_assets/assets.gen.dart';
import 'widgets/role_card.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 48.h),
              SizedBox(
                width: 322.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Assets.images.splashicon.image(
                      width: 150.w,
                      height: 150.h,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: 16.h),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                        children: const [
                          TextSpan(text: 'Welcome to '),
                          TextSpan(
                            text: 'H.O.L.E',
                            style: TextStyle(color: Color(0xFF00C5DA)),
                          ),
                          TextSpan(
                            text: ' APP',
                            style: TextStyle(color: Color(0xFF00C5DA)),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8.h),

                    // Subtitle
                    CustomText(
                      text:
                      'Choose your role to personalize your surgical revenue operations journey.',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.center,
                      textHeight: 1.4,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 36.h),

              // ── Manager Card ──────────────────────────────────────────────
              RoleCard(
                iconPath: 'assets/icons/managericon.svg',
                label: 'Manager',
                subtitle:
                'Direct team logistics, inventory intelligence, and executive approvals.',
                style: RoleCardStyle.manager,
                onTap: () => context.go(AppRoutes.representativeHome),
              ),

              SizedBox(height: 16.h),

              // ── Representative Card ───────────────────────────────────────
              RoleCard(
                iconPath: 'assets/icons/reprentative.svg',
                label: 'Representative',
                subtitle:
                'Optimize field operations, procurement workflows, and commission tracking.',
                style: RoleCardStyle.representative,
                onTap: () => context.go(AppRoutes.representativeHome),
              ),

              SizedBox(height: 16.h),

              // ── Privacy First Card ────────────────────────────────────────
              _PrivacyCard(),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Privacy First Card ────────────────────────────────────────────────────────
class _PrivacyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0x1A00C5DA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0x3300C5DA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info icon circle
          Container(
            width: 32.r,
            height: 32.r,
            decoration: const BoxDecoration(
              color: Color(0xFFE6A817),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'i',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Privacy Frist',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text:
                  'Managers and representatives have separate, role-appropriate experiences. Enterprise-grade security ensures data integrity.',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                  textHeight: 1.4,
                  maxline: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}