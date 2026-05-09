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
              // Avatar — network or fallback
              ClipOval(
                child: activity.avatarUrl != null &&
                        activity.avatarUrl!.isNotEmpty
                    ? Image.network(
                        activity.avatarUrl!,
                        width: 40.r,
                        height: 40.r,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackAvatar(),
                      )
                    : _fallbackAvatar(),
              ),

              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      activity.title.isNotEmpty
                          ? activity.title
                          : '${activity.memberName.isNotEmpty ? activity.memberName : 'User'} ${activity.action}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    if (activity.description.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          activity.description,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Poppins',
                            color: AppColors.secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
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
                text: [
                  if (activity.timeAgo.isNotEmpty) activity.timeAgo,
                  if (activity.location.isNotEmpty) activity.location,
                ].join(' • '),
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

  Widget _fallbackAvatar() {
    return Container(
      width: 40.r,
      height: 40.r,
      color: const Color(0xFF00C5DA),
      child: Icon(Icons.person, color: Colors.white, size: 18.r),
    );
  }
}
