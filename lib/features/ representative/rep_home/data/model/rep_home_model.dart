class RepHomeStats {
  final int totalSales;
  final int activePOs;
  final int totalInventory;
  final int expenses;

  const RepHomeStats({
    this.totalSales = 0,
    this.activePOs = 0,
    this.totalInventory = 0,
    this.expenses = 0,
  });

  factory RepHomeStats.fromJson(Map<String, dynamic> json) => RepHomeStats(
        totalSales: (json['totalSales'] as num?)?.toInt() ?? 0,
        activePOs: (json['activePOs'] as num?)?.toInt() ?? 0,
        totalInventory: (json['totalInventory'] as num?)?.toInt() ?? 0,
        expenses: (json['expenses'] as num?)?.toInt() ?? 0,
      );
}

class MonthlyTrend {
  final String month;
  final double sales;
  final double expenses;
  final double commission;

  const MonthlyTrend({
    required this.month,
    required this.sales,
    required this.expenses,
    required this.commission,
  });

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) => MonthlyTrend(
        month: json['month']?.toString() ?? '',
        sales: (json['sales'] as num?)?.toDouble() ?? 0,
        expenses: (json['expenses'] as num?)?.toDouble() ?? 0,
        commission: (json['commission'] as num?)?.toDouble() ?? 0,
      );
}

class RecentActivity {
  final String id;
  final String title;
  final String description;
  final String module;
  final String action;
  final String createdAt;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.module,
    required this.action,
    required this.createdAt,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) => RecentActivity(
        id: json['_id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        module: json['module']?.toString() ?? '',
        action: json['action']?.toString() ?? '',
        createdAt: json['createdAt']?.toString() ?? '',
      );

  String get timeAgo {
    if (createdAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}
