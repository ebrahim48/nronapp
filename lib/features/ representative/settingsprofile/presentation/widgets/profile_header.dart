import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/custom_widgets/custom_text.dart';
import '../../controller/setting_controller.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final SettingsController c;

  const ProfileHeaderWidget({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final p = c.profile.value;
      final picked = c.selectedImage.value;

      ImageProvider? imageProvider;
      if (picked != null) {
        imageProvider = FileImage(picked);
      } else if (p?.profileUrl != null && p!.profileUrl!.isNotEmpty) {
        imageProvider = NetworkImage(p.profileUrl!);
      }

      return Column(
        children: [
          // ── Avatar ──────────────────────────────────────────────────
          Stack(
            children: [
              CircleAvatar(
                radius: 46.r,
                backgroundColor: const Color(0xFF3A3A3A),
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(Icons.person,
                        size: 40.r, color: AppColors.secondaryTextColor)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: c.pickImage,
                  child: Container(
                    width: 26.r,
                    height: 26.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.backgroundColor, width: 2),
                    ),
                    child: Icon(Icons.camera_alt,
                        color: AppColors.blackColor, size: 13.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Name ─────────────────────────────────────────────────────
          CustomText(
            text: p?.fullName ?? '',
            fontsize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
          SizedBox(height: 4.h),

          // ── Role badge ───────────────────────────────────────────────
          if ((p?.role ?? '').isNotEmpty)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomText(
                text: _roleLabel(p!.role),
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),

          if ((p?.designation ?? '').isNotEmpty) ...[
            SizedBox(height: 4.h),
            CustomText(
              text: p!.designation!,
              fontsize: 13.sp,
              color: AppColors.secondaryTextColor,
            ),
          ],

          SizedBox(height: 16.h),

          // ── Role-based stats ─────────────────────────────────────────
          if (p != null) _buildStats(p),
        ],
      );
    });
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'manager':
        return 'Manager';
      case 'driver':
        return 'Driver';
      case 'representative':
        return 'Representative';
      default:
        return role;
    }
  }

  Widget _buildStats(dynamic p) {
    switch (p.role) {
      case 'representative':
        return _StatsRow(items: [
          _StatItem(
            label: 'TOTAL POS',
            value: '${p.totalPurchaseOrderCount}',
            valueColor: AppColors.primaryTextColor,
          ),
          _StatItem(
            label: 'COMM YTD',
            value: '\$${_formatAmount(p.totalCommission)}',
            valueColor: AppColors.primaryColor,
          ),
        ]);

      case 'manager':
        return Column(
          children: [
            _StatsRow(items: [
              _StatItem(
                label: 'TOTAL SALES',
                value: '\$${_formatAmount(p.totalSalesAmount)}',
                valueColor: AppColors.primaryTextColor,
              ),
              _StatItem(
                label: 'COMMISSION',
                value: '\$${_formatAmount(p.totalCommission)}',
                valueColor: AppColors.primaryColor,
              ),
            ]),
            SizedBox(height: 10.h),
            _StatsRow(items: [
              _StatItem(
                label: 'ACTIVE REPS',
                value: '${p.activeReps}',
                valueColor: AppColors.primaryTextColor,
              ),
              _StatItem(
                label: 'TOTAL SALES COUNT',
                value: '${p.totalSalesCount}',
                valueColor: AppColors.primaryTextColor,
              ),
            ]),
          ],
        );

      case 'driver':
        return _StatsRow(items: [
          _StatItem(
            label: 'TOTAL EARNINGS',
            value: '\$${_formatAmount(p.totalEarnings)}',
            valueColor: AppColors.primaryTextColor,
          ),
          _StatItem(
            label: 'DELIVERIES',
            value: '${p.totalDeliveries}',
            valueColor: AppColors.primaryColor,
          ),
          _StatItem(
            label: 'SUCCESS',
            value: '${p.successRate.toInt()}%',
            valueColor: AppColors.primaryTextColor,
          ),
        ]);

      default:
        return const SizedBox.shrink();
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toStringAsFixed(0);
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final List<_StatItem> items;
  const _StatsRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map((item) => Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2427),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: const Color(0xFF3A3A3A), width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: item.label,
                        fontsize: 9.sp,
                        color: AppColors.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: item.value,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: item.valueColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final Color valueColor;
  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });
}
