class NotificationSender {
  final String id;
  final String name;
  final String profileUrl;

  const NotificationSender({
    required this.id,
    required this.name,
    required this.profileUrl,
  });

  factory NotificationSender.fromJson(Map<String, dynamic> json) {
    return NotificationSender(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      profileUrl: json['profileUrl']?.toString() ?? '',
    );
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String createdAt;
  final bool isRead;
  final String published;
  final NotificationSender sender;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isRead,
    required this.published,
    required this.sender,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      isRead: json['isRead'] == true,
      published: json['published']?.toString() ?? '',
      sender: json['sender'] is Map
          ? NotificationSender.fromJson(
              json['sender'] as Map<String, dynamic>)
          : const NotificationSender(id: '', name: '', profileUrl: ''),
    );
  }

  IconType get iconType {
    final t = title.toLowerCase();
    if (t.contains('assigned')) return IconType.assigned;
    if (t.contains('delivered')) return IconType.delivered;
    if (t.contains('status')) return IconType.status;
    if (t.contains('new')) return IconType.newItem;
    return IconType.general;
  }
}

enum IconType { assigned, delivered, status, newItem, general }
