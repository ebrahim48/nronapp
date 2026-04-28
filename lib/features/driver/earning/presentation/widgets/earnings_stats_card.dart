import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';


class EarningsStatsGrid extends StatelessWidget {
  final double todayEarnings;
  final int todayDeliveries;
  final double thisWeekEarnings;
  final int thisWeekDeliveries;
  final double pendingEarnings;
  final int pendingDeliveries;
  final double totalPaid;
  final int totalDeliveries;

  const EarningsStatsGrid({
    super.key,
    required this.todayEarnings,
    required this.todayDeliveries,
    required this.thisWeekEarnings,
    required this.thisWeekDeliveries,
    required this.pendingEarnings,
    required this.pendingDeliveries,
    required this.totalPaid,
    required this.totalDeliveries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.attach_money,
                iconColor: const Color(0xFF4ADE80),
                bgColor: const Color(0xFF0F2A1A),
                label: 'Today',
                amount: '\$${todayEarnings.toInt()}',
                sub: '$todayDeliveries deliveries',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                icon: Icons.calendar_today_outlined,
                iconColor: const Color(0xFF60A5FA),
                bgColor: const Color(0xFF0F1A2A),
                label: 'This Week',
                amount: '\$${thisWeekEarnings.toInt()}',
                sub: '$thisWeekDeliveries deliveries',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.trending_up,
                iconColor: AppColors.warningColor,
                bgColor: const Color(0xFF2A1A0A),
                label: 'Pending',
                amount: '\$${pendingEarnings.toInt()}',
                sub: '$pendingDeliveries deliveries',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                icon: Icons.wallet_outlined,
                iconColor: const Color(0xFFA78BFA),
                bgColor: const Color(0xFF1A0F2A),
                label: 'Total Paid',
                amount: '\$${totalPaid.toInt()}',
                sub: '$totalDeliveries deliveries',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String amount;
  final String sub;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.amount,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 14.r),
              SizedBox(width: 5.w),
              CustomText(
                text: label,
                fontsize: 11.sp,
                color: AppColors.secondaryTextColor,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: amount,
            fontsize: 22.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 3.h),
          CustomText(
            text: sub,
            fontsize: 11.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}