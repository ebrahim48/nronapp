import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';

class ActivityFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ActivityFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive ? AppColors.primaryColor : const Color(0xFF3A3A3A),
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontsize: 12.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.black : AppColors.primaryTextColor,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}


class FilterRowLabel extends StatelessWidget {
  final String label;
  const FilterRowLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: label,
      fontsize: 12.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.secondaryTextColor,
      textAlign: TextAlign.start,
    );
  }
}


class ActivityInventoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String facility;
  final VoidCallback onDetails;

  const ActivityInventoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.facility,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                fontsize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: date,
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.end,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomText(
            text: subtitle,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          Divider(color: const Color(0xFF3A3A3A), thickness: 0.5, height: 1),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/map.svg',
                    width: 11.r,
                    height: 11.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: facility,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              GestureDetector(
                onTap: onDetails,
                child: Row(
                  children: [
                    CustomText(
                      text: 'Details',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                    Icon(Icons.chevron_right,
                        color: AppColors.primaryColor, size: 14.r),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivitySaleCard extends StatelessWidget {
  final String date;
  final String status;
  final String serial;
  final String doctor;
  final String facility;
  final String surgeryAmount;
  final String totalAmount;

  const ActivitySaleCard({
    super.key,
    required this.date,
    required this.status,
    required this.serial,
    required this.doctor,
    required this.facility,
    required this.surgeryAmount,
    required this.totalAmount,
  });

  Color get _statusColor {
    switch (status) {
      case 'Complete': return const Color(0xFF08AF40);
      case 'Pending':  return const Color(0xFFE6A817);
      default:         return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: date,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                      color: _statusColor.withValues(alpha: 0.4), width: 0.5),
                ),
                child: CustomText(
                  text: status,
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: _statusColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Serial
          CustomText(
            text: serial,
            fontsize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 6.h),
          // Doctor + dot + facility
          Row(
            children: [
              CustomText(
                text: doctor,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Container(
                  width: 5.r,
                  height: 5.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: CustomText(
                  text: facility,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: const Color(0xFF3A3A3A), thickness: 0.5, height: 1),
          SizedBox(height: 8.h),
          // Surgery + total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Surgery',
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  CustomText(
                    text: surgeryAmount,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              CustomText(
                text: totalAmount,
                fontsize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ActivityImplantCard extends StatelessWidget {
  final String name;
  final String serial;
  final String material;
  final String status;
  final String facility;
  final String imagePath;
  final VoidCallback onDetails;

  const ActivityImplantCard({
    super.key,
    required this.name,
    required this.serial,
    required this.material,
    required this.status,
    required this.facility,
    required this.imagePath,
    required this.onDetails,
  });

  Color get _statusColor {
    switch (status) {
      case 'In Stock':   return const Color(0xFF00C5DA);
      case 'Available':  return const Color(0xFF08AF40);
      case 'Shipped':    return const Color(0xFFE6A817);
      default:           return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          Row(
            children: [
              // Icon circle
              Container(
                width: 44.r,
                height: 44.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2A2A2A),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/implantsinventory.svg',
                    width: 22.r,
                    height: 22.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: name,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: _statusColor, width: 1),
                          ),
                          child: CustomText(
                            text: status,
                            fontsize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: _statusColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    CustomText(
                      text: '$serial • $material',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: const Color(0xFF3A3A3A), thickness: 0.5, height: 1),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/map.svg',
                    width: 11.r,
                    height: 11.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: facility,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              GestureDetector(
                onTap: onDetails,
                child: Row(
                  children: [
                    CustomText(
                      text: 'Details',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                    Icon(Icons.chevron_right,
                        color: AppColors.primaryColor, size: 14.r),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ActivityBillingCard extends StatelessWidget {
  final String clinic;
  final String type;
  final String status;
  final String surgeon;
  final String totalBill;

  const ActivityBillingCard({
    super.key,
    required this.clinic,
    required this.type,
    required this.status,
    required this.surgeon,
    required this.totalBill,
  });

  Color get _statusColor {
    switch (status) {
      case 'Paid':    return const Color(0xFF08AF40);
      case 'Pending': return const Color(0xFFE6A817);
      default:        return AppColors.secondaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clinic + Paid badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: clinic,
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.start,
              ),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: status,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Type in teal
          CustomText(
            text: type,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          Divider(color: const Color(0xFF3A3A3A), thickness: 0.5, height: 1),
          SizedBox(height: 8.h),
          // Surgeon + Total Bill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Surgeon',
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: surgeon,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: 'Total Bill',
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: totalBill,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A25292A),
            blurRadius: 1,
            offset: Offset(0.5, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}