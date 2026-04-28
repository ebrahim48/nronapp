import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../appdrawer/app_drawer.dart';
import '../controller/rep_home_controller.dart';
import 'widgets/rep_chart_section.dart';
import 'widgets/rep_header.dart';
import 'widgets/rep_quick_actions.dart';
import 'widgets/rep_stat_grid.dart';
import 'widgets/rep_wide_card.dart';

class RepresentativeHomeScreen extends StatefulWidget {
  const RepresentativeHomeScreen({super.key});

  @override
  State<RepresentativeHomeScreen> createState() =>
      _RepresentativeHomeScreenState();
}

class _RepresentativeHomeScreenState extends State<RepresentativeHomeScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(RepHomeController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: const RepHeader(),
              ),

              SizedBox(height: 15.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: const RepStatGrid(),
              ),

              SizedBox(height: 15.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: const RepChartSection(),
              ),

              SizedBox(height: 15.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: const RepQuickActions(),
              ),

              SizedBox(height: 15.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: const RepWideCard(),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}