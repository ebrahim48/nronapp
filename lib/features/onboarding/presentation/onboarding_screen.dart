import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app-routes/app_routes.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../model/onboarding_data.dart';
import 'widgets/onboarding_dots_nav.dart';
import 'widgets/onboarding_slide_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < onboardingSlides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFirstPage = _currentPage == 0;
    final isLastPage = _currentPage == onboardingSlides.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xff1E2121),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 164.5.h),

          // Page view
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingSlides.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) =>
                  OnboardingSlidePage(data: onboardingSlides[i]),
            ),
          ),

          // Dots + arrow
          OnboardingDotsNav(
            totalPages: onboardingSlides.length,
            currentPage: _currentPage,
            showArrow: isFirstPage,
            onArrowTap: _next,
          ),

          // Next / Get Started button — slides 2 & 3 only
          if (!isFirstPage) ...[
            SizedBox(height: 61.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                title: isLastPage ? 'Get Started' : 'Next',
                onpress: _next,
              ),
            ),
            SizedBox(height: 24.h),
          ],

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
