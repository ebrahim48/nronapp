import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/setting_controller.dart';


void _showDeleteDialog(BuildContext context, SettingsController c) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF242424),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        'Delete Account',
        style: TextStyle(
          color: AppColors.primaryTextColor,
          fontSize: 16.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
        style: TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: 13.sp,
          fontFamily: 'Poppins',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontFamily: 'Poppins',
              fontSize: 13.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            c.deleteAccount();
          },
          child: Text(
            'Delete',
            style: TextStyle(
              color: AppColors.redColorFF1D1D,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    ),
  );
}

class OthersScreen extends StatelessWidget {
  const OthersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingsController());

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
          text: 'Others',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: c.othersTiles.asMap().entries.map((e) {
              final tile = e.value;
              final isLast = e.key == c.othersTiles.length - 1;
              final isDelete = tile.title == 'Delete Account';

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isDelete) {
                        _showDeleteDialog(context, c);
                      } else if (tile.route.isNotEmpty) {
                        context.push(tile.route);
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            tile.iconPath,
                            width: 20.r,
                            height: 20.r,
                            colorFilter: ColorFilter.mode(
                              isDelete
                                  ? AppColors.primaryColor
                                  : AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: CustomText(
                              text: tile.title,
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: AppColors.secondaryTextColor,
                              size: 20.r),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                        height: 1,
                        color: const Color(0xFF3A3A3A),
                        thickness: 0.5,
                        indent: 16.w,
                        endIndent: 16.w),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}