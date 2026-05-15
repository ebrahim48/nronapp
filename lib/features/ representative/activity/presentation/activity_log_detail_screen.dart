import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/custom_widgets/app_network_image.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../model/activity_log_model.dart';

class ActivityLogDetailScreen extends StatelessWidget {
  final ActivityLogModel log;

  const ActivityLogDetailScreen({super.key, required this.log});

  Color get _actionColor {
    switch (log.action.toLowerCase()) {
      case 'create':  return const Color(0xFF08AF40);
      case 'update':  return const Color(0xFF00C5DA);
      case 'delete':  return const Color(0xFFE53935);
      case 'approve': return const Color(0xFF7B61FF);
      default:        return AppColors.secondaryTextColor;
    }
  }

  IconData get _moduleIcon {
    switch (log.module.toLowerCase()) {
      case 'shipment': return Icons.local_shipping_outlined;
      case 'sales':    return Icons.bar_chart_outlined;
      case 'implant':  return Icons.medical_services_outlined;
      case 'expense':  return Icons.receipt_long_outlined;
      default:         return Icons.history_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: 56.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Activity Details',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero card ──────────────────────────────────────────────
            _SectionCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: _actionColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(_moduleIcon, color: _actionColor, size: 24.r),
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
                                text: log.title,
                                fontsize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            _ActionBadge(
                                action: log.action, color: _actionColor),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: log.message,
                          fontsize: 12.sp,
                          color: AppColors.secondaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.access_time_outlined,
                                color: AppColors.secondaryTextColor,
                                size: 12.r),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: log.formattedDate,
                              fontsize: 11.sp,
                              color: AppColors.secondaryTextColor,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // ── Thumbnail ──────────────────────────────────────────────
            if (log.thumbnail.isNotEmpty) ...[
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Attachment'),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: AppNetworkImage(
                        imageUrl: log.thumbnail,
                        width: double.infinity,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // ── Actor ──────────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Performed By'),
                  SizedBox(height: 10.h),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: log.actorEmail,
                  ),
                  SizedBox(height: 6.h),
                  _InfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Role',
                    value: _capitalize(log.actorRole),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // ── Resource info ──────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Resource Info'),
                  SizedBox(height: 10.h),
                  _InfoRow(
                    icon: Icons.category_outlined,
                    label: 'Module',
                    value: _capitalize(log.module),
                  ),
                  SizedBox(height: 6.h),
                  _InfoRow(
                    icon: Icons.layers_outlined,
                    label: 'Model',
                    value: log.resourceModel,
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // ── Metadata ───────────────────────────────────────────────
            if (_readableMetadata.isNotEmpty) ...[
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Details'),
                    SizedBox(height: 10.h),
                    ..._readableMetadata.entries.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: _InfoRow(
                            icon: _metaIcon(e.key),
                            label: _formatKey(e.key),
                            value: _formatValue(e.key, e.value.toString()),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // ── Tags ───────────────────────────────────────────────────
            if (log.tags.isNotEmpty) ...[
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Tags'),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: log.tags
                          .map((tag) => _TagChip(label: tag))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // MongoDB ObjectID — 24-char hex string
  static final _objectIdRegex = RegExp(r'^[a-f0-9]{24}$');

  bool _isObjectId(String v) => _objectIdRegex.hasMatch(v.trim());

  // Only entries that are readable (not ObjectIDs, not nested objects/lists)
  Map<String, dynamic> get _readableMetadata => Map.fromEntries(
        log.metadata.entries.where((e) =>
            e.value is! Map &&
            e.value is! List &&
            !_isObjectId(e.value?.toString() ?? '')),
      );

  String _formatValue(String key, String raw) {
    final k = key.toLowerCase();
    if ((k.contains('price') || k.contains('amount') ||
            k.contains('commission') || k.contains('bill')) &&
        double.tryParse(raw) != null) {
      return '\$$raw';
    }
    if (k.contains('date') && raw.contains('T')) {
      try {
        final dt = DateTime.parse(raw).toLocal();
        const months = [
          'Jan','Feb','Mar','Apr','May','Jun',
          'Jul','Aug','Sep','Oct','Nov','Dec'
        ];
        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
      } catch (_) {}
    }
    return raw;
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatKey(String key) {
    return key
        .replaceAllMapped(
            RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}')
        .split('_')
        .join(' ')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  IconData _metaIcon(String key) {
    final k = key.toLowerCase();
    if (k.contains('id')) return Icons.tag_outlined;
    if (k.contains('price') || k.contains('amount') || k.contains('commission')) {
      return Icons.attach_money_outlined;
    }
    if (k.contains('address') || k.contains('pickup') || k.contains('dropoff')) {
      return Icons.location_on_outlined;
    }
    if (k.contains('status')) return Icons.info_outline;
    if (k.contains('date')) return Icons.calendar_today_outlined;
    if (k.contains('distance')) return Icons.route_outlined;
    if (k.contains('company')) return Icons.business_outlined;
    if (k.contains('type') || k.contains('service')) return Icons.label_outline;
    if (k.contains('priority')) return Icons.priority_high_outlined;
    return Icons.chevron_right;
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2121),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        CustomText(
          text: title,
          fontsize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.secondaryTextColor, size: 14.r),
        SizedBox(width: 8.w),
        SizedBox(
          width: 90.w,
          child: CustomText(
            text: label,
            fontsize: 12.sp,
            color: AppColors.secondaryTextColor,
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: CustomText(
            text: value,
            fontsize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class _ActionBadge extends StatelessWidget {
  final String action;
  final Color color;
  const _ActionBadge({required this.action, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.6),
      ),
      child: CustomText(
        text: action.toUpperCase(),
        fontsize: 10.sp,
        fontWeight: FontWeight.w700,
        color: color,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3), width: 0.6),
      ),
      child: CustomText(
        text: '#$label',
        fontsize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}
