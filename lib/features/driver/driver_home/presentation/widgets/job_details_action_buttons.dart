import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';

class JobDetailActionButtons extends StatelessWidget {
  final VoidCallback onDecline;
  final VoidCallback onAccept;
  final bool isAccepting;

  const JobDetailActionButtons({
    super.key,
    required this.onDecline,
    required this.onAccept,
    this.isAccepting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          top: BorderSide(color: const Color(0xFF3A3A3A), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onDecline,
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2121),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Center(
                  child: Text(
                    'Decline',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: onAccept,
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: isAccepting
                    ? Center(
                        child: SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blackColor,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.navigation_outlined,
                              color: AppColors.blackColor, size: 18.r),
                          SizedBox(width: 6.w),
                          Text(
                            'Accept Job',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}