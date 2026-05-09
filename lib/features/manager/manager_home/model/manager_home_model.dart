import 'package:flutter/material.dart';

// ── Stat card ─────────────────────────────────────────────────────────────────

class ManagerStatModel {
  final String iconPath;
  final String label;
  final String value;
  final Color? valueColor;

  const ManagerStatModel({
    required this.iconPath,
    required this.label,
    required this.value,
    this.valueColor,
  });
}

// ── Team activity ─────────────────────────────────────────────────────────────

class TeamActivityModel {
  final String id;
  final String memberName;
  final String action;
  final String timeAgo;
  final String location;
  final String? avatarUrl;
  final String title;
  final String description;
  final String createdAt;

  const TeamActivityModel({
    required this.id,
    required this.memberName,
    required this.action,
    required this.timeAgo,
    required this.location,
    this.avatarUrl,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  static String _timeAgo(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'just now';
    } catch (_) {
      return '';
    }
  }

  factory TeamActivityModel.fromJson(Map<String, dynamic> e) {
    final resourceMap = e['resourceId'] is Map
        ? e['resourceId'] as Map<String, dynamic>
        : <String, dynamic>{};
    return TeamActivityModel(
      id: e['_id']?.toString() ?? '',
      memberName: '',
      action: e['action']?.toString() ?? '',
      timeAgo: _timeAgo(e['createdAt']?.toString()),
      location: e['module']?.toString() ?? '',
      avatarUrl: e['thumbnail']?.toString(),
      title: e['title']?.toString() ?? '',
      description: e['description']?.toString() ?? '',
      createdAt: e['createdAt']?.toString() ?? '',
    );
  }
}

// ── Monthly trend ─────────────────────────────────────────────────────────────

class MonthlyTrendPoint {
  final String month;
  final double sales;
  final double expenses;
  final double commission;

  const MonthlyTrendPoint({
    required this.month,
    required this.sales,
    required this.expenses,
    required this.commission,
  });

  factory MonthlyTrendPoint.fromJson(Map<String, dynamic> e) {
    return MonthlyTrendPoint(
      month: e['month']?.toString() ?? '',
      sales: (e['sales'] as num?)?.toDouble() ?? 0,
      expenses: (e['expenses'] as num?)?.toDouble() ?? 0,
      commission: (e['commission'] as num?)?.toDouble() ?? 0,
    );
  }
}
