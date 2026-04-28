import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../model/manager_home_model.dart';

class TeamActivityTile extends StatelessWidget {
  final TeamActivityModel activity;
  final bool isLast;

  const TeamActivityTile({
    super.key,
    required this.activity,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20.r,
                backgroundImage: activity.avatarAsset != null
                    ? AssetImage(activity.avatarAsset!)
                    : null,
                backgroundColor: const Color(0xFF00C5DA),
                child: activity.avatarAsset == null
                    ? Icon(Icons.person,
                    color: Colors.white,
                    size: 18.r)
                    : null,
              ),

              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${activity.memberName} ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      TextSpan(
                        text: activity.action,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Sub info
        Padding(
          padding: EdgeInsets.only(left: 52.w, bottom: 4.h),
          child: Row(
            children: [
              CustomText(
                text: '${activity.timeAgo} • ${activity.location}',
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
              height: 1,
              color: const Color(0xFF3A3A3A),
              thickness: 0.5),
      ],
    );
  }
}