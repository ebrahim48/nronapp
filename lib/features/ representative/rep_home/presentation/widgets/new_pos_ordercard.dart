import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/rep_purchase_order_controller.dart';

class NewPoOrderCard extends StatelessWidget {
  final OrderType type;
  final String imagePath;
  final String svgIcon;
  final String title;
  final String subtitle;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onButtonTap;

  const NewPoOrderCard({
    super.key,
    required this.type,
    required this.imagePath,
    required this.svgIcon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.isSelected,
    required this.onTap,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 345.w,
        height: 280.h,
        decoration: BoxDecoration(
          color: const Color(0x4D1E293B),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 4,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.r),
          child: Column(
            children: [
              SizedBox(
                width: 345.w,
                height: 110.h,
                child: Stack(
                  children: [
                    // Image
                    Positioned.fill(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.0, 0.4904, 1.0],
                            colors: [
                              Color(0xFF1C1F25),
                              Color(0x861C1F25),
                              Color(0x401C1F25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 12.h),
                  child: SizedBox(
                    width: 309.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: const Color(0x1A137FEC),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  svgIcon,
                                  width: 22.w,
                                  height: 22.w,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: title,
                                  fontsize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                  textAlign: TextAlign.start,
                                ),
                                CustomText(
                                  text: subtitle,
                                  fontsize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF94A3B8),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),

                        CustomText(
                          text: description,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                          textAlign: TextAlign.start,
                          maxline: 2,
                        ),

                        GestureDetector(
                          onTap: onButtonTap,
                          child: Container(
                            width: 309.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0x1A00D5ED)
                                  : const Color(0x1A00C5DA),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.primaryTextColor,
                                width: isSelected ? 1 : 0.5,
                              ),
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'Selected Choice',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}