class ActivityLogModel {
  final String id;
  final String actorEmail;
  final String actorRole;
  final String action;
  final String module;
  final String resourceModel;
  final String title;
  final String message;
  final String thumbnail;
  final Map<String, dynamic> metadata;
  final List<String> tags;
  final String createdAt;

  const ActivityLogModel({
    required this.id,
    required this.actorEmail,
    required this.actorRole,
    required this.action,
    required this.module,
    required this.resourceModel,
    required this.title,
    required this.message,
    required this.thumbnail,
    required this.metadata,
    required this.tags,
    required this.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    final actor = json['actor'] is Map
        ? json['actor'] as Map<String, dynamic>
        : <String, dynamic>{};
    return ActivityLogModel(
      id: json['_id']?.toString() ?? '',
      actorEmail: actor['email']?.toString() ?? '',
      actorRole: actor['role']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      module: json['module']?.toString() ?? '',
      resourceModel: json['resourceModel']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : {},
      tags: (json['tags'] is List)
          ? List<String>.from(json['tags'] as List)
          : [],
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  String get formattedDate {
    if (createdAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $h:$m';
    } catch (_) {
      return createdAt;
    }
  }
}

class ActivityModuleFilter {
  final String module;
  final String resourceModel;

  const ActivityModuleFilter({
    required this.module,
    required this.resourceModel,
  });

  factory ActivityModuleFilter.fromJson(Map<String, dynamic> json) {
    return ActivityModuleFilter(
      module: json['module']?.toString() ?? '',
      resourceModel: json['resourceModel']?.toString() ?? '',
    );
  }
}
