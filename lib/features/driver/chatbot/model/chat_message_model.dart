class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final List<ChatAttachment> attachments;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.attachments = const [],
  });
}

// ── File attachment (e.g. a generated PDF from the chatbot) ───────────────────

class ChatAttachment {
  final String filename;
  final String mimeType;
  final String base64;

  const ChatAttachment({
    required this.filename,
    required this.mimeType,
    required this.base64,
  });

  factory ChatAttachment.fromJson(Map<String, dynamic> e) {
    return ChatAttachment(
      filename: e['filename']?.toString() ?? 'document.pdf',
      mimeType: e['mimeType']?.toString() ?? 'application/octet-stream',
      base64: e['base64']?.toString() ?? '',
    );
  }

  bool get isPdf => mimeType.contains('pdf') || filename.endsWith('.pdf');
  bool get hasData => base64.isNotEmpty;
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
