import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmerList extends StatelessWidget {
  const NotificationShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: 8,
        separatorBuilder: (_, __) =>
            Divider(height: 1, thickness: 0.5, color: const Color(0xFF2A2A2A)),
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 13.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r))),
                    SizedBox(height: 6.h),
                    Container(
                        height: 11.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r))),
                    SizedBox(height: 4.h),
                    Container(
                        height: 11.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r))),
                    SizedBox(height: 8.h),
                    Container(
                        height: 10.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
