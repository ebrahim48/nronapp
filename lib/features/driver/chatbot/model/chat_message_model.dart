class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

// ── Chat session (from /chatbot/sessions) ─────────────────────────────────────

class ChatSession {
  final String id;
  final String sessionId;
  final String title;
  final DateTime updatedAt;

  const ChatSession({
    required this.id,
    required this.sessionId,
    required this.title,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> e) {
    return ChatSession(
      id: e['_id']?.toString() ?? '',
      sessionId: e['sessionId']?.toString() ?? '',
      title: e['title']?.toString() ?? 'Untitled',
      updatedAt: DateTime.tryParse(e['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
  }
}
