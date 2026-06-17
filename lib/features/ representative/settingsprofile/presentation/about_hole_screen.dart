import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/setting_controller.dart';

class AboutHoleScreen extends StatefulWidget {
  const AboutHoleScreen({super.key});

  @override
  State<AboutHoleScreen> createState() => _AboutHoleScreenState();
}

class _AboutHoleScreenState extends State<AboutHoleScreen> {
  late SettingsController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.put(SettingsController());
    _c.fetchAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'About H.O.L.E',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2427),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  'assets/images/abouthole.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(Icons.info_outline,
                        color: AppColors.primaryColor, size: 64.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            CustomText(
              text: 'About H.O.L.E',
              fontsize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 12.h),
            Obx(() {
              if (_c.isLoadingContent.value) return _ContentShimmer();
              final content = _c.aboutContent.value;
              if (content == null || content.isEmpty) return _EmptyContent();
              return _ContentCard(content: content);
            }),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final String content;
  const _ContentCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Html(
        data: content,
        style: {
          'body': Style(
            color: AppColors.secondaryTextColor,
            fontSize: FontSize(13.sp),
            fontFamily: 'Poppins',
            lineHeight: const LineHeight(1.6),
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
          'p': Style(
            color: AppColors.secondaryTextColor,
            margin: Margins.only(bottom: 8),
          ),
          'span': Style(
            color: AppColors.secondaryTextColor,
          ),
        },
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Center(
        child: Text(
          'Content not available.',
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            color: AppColors.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}

class _ContentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Container(
        width: double.infinity,
        height: 160.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
